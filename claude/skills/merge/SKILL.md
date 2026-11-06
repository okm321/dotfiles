---
name: merge
description: Commit, rebase, and merge the current branch.
disable-model-invocation: true
allowed-tools: Read, Bash, Glob, Grep
---

<!-- Customize the commit style and rebase behavior to match your workflow. -->

**Arguments:** `$ARGUMENTS`

Check the arguments for flags:

- `--keep`, `-k` → pass `--keep` to `workmux merge` (keeps the worktree and tmux window after merging)
- `--no-verify`, `-n` → pass `--no-verify` to `workmux merge`

Strip all flags from arguments.

Commit, rebase, and merge the current branch.

This command finishes work on the current branch by:

1. Committing any staged changes
2. Rebasing onto the base branch
3. Running `workmux merge` to merge and clean up

## Step 1: Commit

If there are staged changes, commit them. Use lowercase, imperative mood, no conventional commit prefixes. Skip if nothing is staged.

## Step 2: Rebase

Get the base branch from git config:

```
git config --local --get "branch.$(git branch --show-current).workmux-base"
```

If no base branch is configured, default to "main".

Rebase onto the local base branch (do NOT fetch from origin first):

```
git rebase <base-branch>
```

IMPORTANT: Do NOT run `git fetch`. Do NOT rebase onto `origin/<branch>`. Only rebase onto the local branch name (e.g., `git rebase main`, not `git rebase origin/main`).

If conflicts occur, follow the `/rebase` skill's conflict resolution
procedure, treating `<base-branch>` as the target branch.

## Step 3: Merge

Run: `workmux merge --rebase --notification [--keep] [--no-verify]`

Include `--keep` only if the `--keep` flag was passed in arguments.
Include `--no-verify` only if the `--no-verify` flag was passed in arguments.

This will merge the branch into the base branch and clean up the worktree and
tmux window (unless `--keep` is used).
