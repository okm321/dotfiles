#!/usr/bin/env python3
"""RSS/APIで技術記事を収集し、claude CLIで要約してObsidianに保存する"""

import json
import os
import re
import subprocess
import sys
import urllib.request
from datetime import datetime, timedelta, timezone
from html.parser import HTMLParser
from pathlib import Path
from xml.etree import ElementTree

SCRIPT_DIR = Path(__file__).resolve().parent
OBSIDIAN_DIR = Path.home() / "obsidian" / "AIDigest"
HISTORY_FILE = SCRIPT_DIR / "history.txt"
JST = timezone(timedelta(hours=9))
UA = {"User-Agent": "Mozilla/5.0 (AI-Digest/1.0)"}


# --- 記事収集 ---


def load_history() -> set[str]:
    if not HISTORY_FILE.exists():
        return set()
    return set(HISTORY_FILE.read_text().strip().splitlines())


def save_history(urls: set[str]) -> None:
    HISTORY_FILE.write_text("\n".join(sorted(urls)) + "\n")


def fetch_json(url: str) -> dict | list:
    req = urllib.request.Request(url, headers=UA)
    with urllib.request.urlopen(req, timeout=15) as resp:
        return json.loads(resp.read())


def fetch_xml(url: str) -> ElementTree.Element:
    req = urllib.request.Request(url, headers=UA)
    with urllib.request.urlopen(req, timeout=15) as resp:
        return ElementTree.fromstring(resp.read())


def collect_hatena(limit: int = 15) -> list[dict]:
    """はてなブックマーク IT ホットエントリ"""
    ns = {
        "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
        "rss": "http://purl.org/rss/1.0/",
        "dc": "http://purl.org/dc/elements/1.1/",
        "hatena": "http://www.hatena.ne.jp/info/xmlns#",
    }
    root = fetch_xml("https://b.hatena.ne.jp/hotentry/it.rss")
    articles = []
    for item in root.findall("rss:item", ns)[:limit]:
        title = item.find("rss:title", ns)
        link = item.get(f"{{{ns['rdf']}}}about", "")
        bookmarks = item.find("hatena:bookmarkcount", ns)
        subjects = [s.text for s in item.findall("dc:subject", ns) if s.text]
        articles.append({
            "source": "hatena",
            "title": title.text if title is not None else "",
            "url": link,
            "bookmarks": int(bookmarks.text) if bookmarks is not None else 0,
            "tags": subjects,
        })
    return articles


def collect_zenn(limit: int = 15) -> list[dict]:
    """Zenn デイリートレンド"""
    data = fetch_json("https://zenn.dev/api/articles?order=daily")
    articles = []
    for item in data.get("articles", [])[:limit]:
        articles.append({
            "source": "zenn",
            "title": item["title"],
            "url": f"https://zenn.dev{item['path']}",
            "likes": item.get("liked_count", 0),
        })
    return articles


def collect_hackernews(limit: int = 15) -> list[dict]:
    """Hacker News トップストーリー"""
    ids = fetch_json("https://hacker-news.firebaseio.com/v0/topstories.json")
    articles = []
    for story_id in ids[:limit]:
        item = fetch_json(f"https://hacker-news.firebaseio.com/v0/item/{story_id}.json")
        if not item or item.get("type") != "story":
            continue
        articles.append({
            "source": "hackernews",
            "title": item.get("title", ""),
            "url": item.get("url", f"https://news.ycombinator.com/item?id={story_id}"),
            "score": item.get("score", 0),
            "hn_url": f"https://news.ycombinator.com/item?id={story_id}",
        })
    return articles


def collect_devto(limit: int = 10) -> list[dict]:
    """dev.to 直近1日の人気記事"""
    data = fetch_json(f"https://dev.to/api/articles?per_page={limit}&top=1")
    articles = []
    for item in data[:limit]:
        articles.append({
            "source": "devto",
            "title": item["title"],
            "url": item["url"],
            "reactions": item.get("public_reactions_count", 0),
            "tags": item.get("tag_list", []),
        })
    return articles


def collect_qiita(limit: int = 15) -> list[dict]:
    """Qiita 人気記事（直近でストックが多い記事）"""
    data = fetch_json(f"https://qiita.com/api/v2/items?per_page={limit}&query=stocks:>10")
    articles = []
    for item in data[:limit]:
        articles.append({
            "source": "qiita",
            "title": item["title"],
            "url": item["url"],
            "likes": item.get("likes_count", 0),
            "tags": [t["name"] for t in item.get("tags", [])],
        })
    return articles


def collect_all(history: set[str]) -> dict[str, list[dict]]:
    sources = {}
    collectors = {
        "hatena": collect_hatena,
        "zenn": collect_zenn,
        "qiita": collect_qiita,
        "hackernews": collect_hackernews,
        "devto": collect_devto,
    }
    for name, fn in collectors.items():
        try:
            raw = fn()
            filtered = [a for a in raw if a["url"] not in history]
            print(f"  {name}: {len(filtered)}件（{len(raw) - len(filtered)}件は既出）")
            sources[name] = filtered
        except Exception as e:
            print(f"  {name}: 取得失敗 ({e})", file=sys.stderr)
            sources[name] = []
    return sources


# --- 要約 ---


TWITTER_ACCOUNTS = [
    "tonkotsuboy_com",
    "kenn",
    "oikon48",
    "AnthropicAI",
    "claudeai",
    "azu_re",
    "mizchi",
]

TWITTER_SEARCH_PROMPT = """\
WebSearchツールを使って、以下のXアカウントの直近ツイートを検索してください。

## 検索対象アカウント
{account_queries}

## 出力ルール
- 見つかったツイートのURLだけをリストで出力（1行1URL）
- 形式: `https://x.com/ユーザー名/status/ID`
- プロフィールURL（/statusなし）は除外
- ツイートが見つからなければ「なし」とだけ出力
- **前置き文や説明は一切不要。URLリストだけを出力する**
"""

SUMMARIZE_PROMPT = """\
あなたはAI開発のトレンドウォッチャーです。
以下の記事リストとツイートから、エンジニアにとって価値のあるダイジェストを作成してください。

## 読者プロファイル
フルスタックエンジニア（TypeScript/Go、Neovim、Ghostty、tmux）。
AI開発・LLM・コーディングツール・開発環境に関心が高い。

## 話題のツイート（X/Twitter）
{tweets}

## 記事リスト

### はてなブックマーク IT ホットエントリ
{hatena}

### Zenn デイリートレンド
{zenn}

### Qiita 人気記事
{qiita}

### Hacker News トップストーリー
{hackernews}

### dev.to 人気記事
{devto}

## 出力ルール
- **AI/LLM・AIコーディングツール・AI開発手法に関連するもののみ** を厳選する。件数制限なし、重要なものはすべて採用
- **採用基準**: AI、LLM、機械学習、Claude Code、Cursor、GitHub Copilot、MCP、AIエージェント、プロンプトエンジニアリング、vibe coding、AI開発ワークフローなどに直接関係するもの
- **除外**: AI規制・政策・資金調達、設計原則一般論、ランタイム比較など AI と直接関係ないもの
- 該当するものがないソースは無理に採用しなくてよい
- 日本語で書く（英語は日本語に翻訳）
- セクション見出し(##)は不要。記事を `---` で区切って並べるだけ
- **冒頭に前置き文を入れないこと。1つ目の記事/ツイートからいきなり始める**

## フォーマット

**ツイートの場合:**
要約1〜2行。

![](https://x.com/ユーザー名/status/ID)

**記事の場合:**
要約1〜2行。

```cardlink
url: 記事のURL
title: "記事タイトル"
host: ドメイン名
```
"""


TWITTER_EPOCH_MS = 1288834974657


def tweet_id_to_datetime(tweet_id: int) -> datetime:
    timestamp_ms = (tweet_id >> 22) + TWITTER_EPOCH_MS
    return datetime.fromtimestamp(timestamp_ms / 1000, tz=JST)


def search_tweets() -> str:
    """WebSearchでフォローアカウントのツイートを検索し、Snowflake IDで日付フィルタ"""
    now = datetime.now(JST)
    cutoff = now - timedelta(days=2)

    account_queries = "\n".join(
        f"- `site:x.com/{account}` を検索" for account in TWITTER_ACCOUNTS
    )
    prompt = TWITTER_SEARCH_PROMPT.format(account_queries=account_queries)
    env = {k: v for k, v in os.environ.items() if k != "CLAUDECODE"}
    result = subprocess.run(
        ["claude", "-p", prompt, "--allowedTools", "WebSearch"],
        capture_output=True, text=True, timeout=300, env=env,
    )
    if result.returncode != 0:
        print(f"  Twitter検索失敗: {result.stderr[:100]}", file=sys.stderr)
        return "(なし)"

    tweet_pattern = re.compile(r"https://x\.com/\w+/status/(\d+)")
    seen = set()
    urls = []
    for line in result.stdout.strip().split("\n"):
        m = tweet_pattern.search(line)
        if not m:
            continue
        url = m.group(0)
        tweet_id = int(m.group(1))
        if tweet_id in seen:
            continue
        seen.add(tweet_id)
        tweet_date = tweet_id_to_datetime(tweet_id)
        if tweet_date >= cutoff:
            urls.append(url)
            print(f"  ツイート取得: {tweet_date.strftime('%Y-%m-%d %H:%M')} {url}")
        else:
            print(f"  古いツイート除外: {tweet_date.strftime('%Y-%m-%d')} {url}")
    if not urls:
        return "(なし)"
    return "\n".join(f"- {url}" for url in urls)


def format_articles(articles: list[dict]) -> str:
    lines = []
    for a in articles:
        meta = []
        if "bookmarks" in a:
            meta.append(f"{a['bookmarks']}users")
        if "likes" in a:
            meta.append(f"♥{a['likes']}")
        if "score" in a:
            meta.append(f"▲{a['score']}")
        if "reactions" in a:
            meta.append(f"♥{a['reactions']}")
        meta_str = f" ({', '.join(meta)})" if meta else ""
        lines.append(f"- {a['title']}{meta_str}\n  {a['url']}")
    return "\n".join(lines) if lines else "(なし)"


def summarize(sources: dict[str, list[dict]], tweets: str) -> str:
    prompt = SUMMARIZE_PROMPT.format(
        tweets=tweets,
        hatena=format_articles(sources.get("hatena", [])),
        zenn=format_articles(sources.get("zenn", [])),
        qiita=format_articles(sources.get("qiita", [])),
        hackernews=format_articles(sources.get("hackernews", [])),
        devto=format_articles(sources.get("devto", [])),
    )
    env = {k: v for k, v in os.environ.items() if k != "CLAUDECODE"}
    result = subprocess.run(
        ["claude", "-p", prompt],
        capture_output=True,
        text=True,
        timeout=300,
        env=env,
    )
    if result.returncode != 0:
        print(f"claude CLI error: {result.stderr}", file=sys.stderr)
        sys.exit(1)
    return result.stdout.strip()


# --- 後処理 ---


class OGPParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.og_image = None

    def handle_starttag(self, tag, attrs):
        if tag != "meta":
            return
        attrs_dict = dict(attrs)
        prop = attrs_dict.get("property", "") or attrs_dict.get("name", "")
        if prop == "og:image" and "content" in attrs_dict:
            self.og_image = attrs_dict["content"]


def fetch_og_image(url: str) -> str | None:
    try:
        req = urllib.request.Request(url, headers=UA)
        with urllib.request.urlopen(req, timeout=10) as resp:
            html = resp.read(50000).decode("utf-8", errors="ignore")
        parser = OGPParser()
        parser.feed(html)
        return parser.og_image
    except Exception:
        return None


def strip_preamble(content: str) -> str:
    """前置き文を除去。最初のcardlink/ツイート埋め込み/実質的な内容行から開始"""
    lines = content.split("\n")
    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped and not stripped.startswith(("検索", "調査", "以下", "まとめ", "結果")):
            return "\n".join(lines[i:])
    return content


def enrich_cardlinks(content: str) -> str:
    pattern = re.compile(r"(```cardlink\n)(.*?)(```)", re.DOTALL)

    def replace_cardlink(match: re.Match) -> str:
        block = match.group(2)
        if "image:" in block:
            return match.group(0)
        url_match = re.search(r"url:\s*(.+)", block)
        if not url_match:
            return match.group(0)
        url = url_match.group(1).strip()
        print(f"  OG画像取得: {url}")
        og_image = fetch_og_image(url)
        if og_image:
            return match.group(1) + block.rstrip("\n") + f"\nimage: {og_image}\n" + match.group(3)
        return match.group(0)

    return pattern.sub(replace_cardlink, content)


# --- 保存 ---


def save_to_obsidian(content: str, date: datetime) -> Path:
    OBSIDIAN_DIR.mkdir(parents=True, exist_ok=True)
    date_str = date.strftime("%Y-%m-%d")
    filepath = OBSIDIAN_DIR / f"AI Digest {date_str}.md"
    frontmatter = f"""---
tags:
  - AI
  - development
  - digest
  - auto-generated
date: {date_str}
---
"""
    filepath.write_text(frontmatter + f"# AI Digest {date_str}\n\n" + content)
    return filepath


# --- メイン ---


def extract_urls(sources: dict[str, list[dict]], tweets: str) -> set[str]:
    urls = set()
    for articles in sources.values():
        for a in articles:
            urls.add(a["url"])
    tweet_pattern = re.compile(r"https://x\.com/\w+/status/\d+")
    for m in tweet_pattern.finditer(tweets):
        urls.add(m.group(0))
    return urls


def trim_history(history: set[str], max_size: int = 500) -> set[str]:
    if len(history) <= max_size:
        return history
    sorted_urls = sorted(history)
    return set(sorted_urls[-max_size:])


def main():
    now = datetime.now(JST)

    history = load_history()
    print(f"履歴: {len(history)}件")

    print("記事を収集中...")
    sources = collect_all(history)

    print("X(Twitter)を検索中...")
    tweets = search_tweets()
    tweet_count = tweets.count("x.com") if tweets != "(なし)" else 0
    print(f"  ツイート: {tweet_count}件")

    total = sum(len(v) for v in sources.values()) + tweet_count
    if total == 0:
        print("記事が取得できませんでした", file=sys.stderr)
        sys.exit(1)

    print("要約を生成中...")
    content = summarize(sources, tweets)
    content = strip_preamble(content)

    print("OG画像を取得中...")
    content = enrich_cardlinks(content)

    filepath = save_to_obsidian(content, now)
    print(f"保存完了: {filepath}")

    new_urls = extract_urls(sources, tweets)
    history = trim_history(history | new_urls)
    save_history(history)
    print(f"履歴更新: {len(history)}件")


if __name__ == "__main__":
    main()
