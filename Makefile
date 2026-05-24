.PHONY: switch update gc check show help

FLAKE := $(HOME)/dotfiles/nix

# HOST の優先順位:
#  1. 環境変数 / コマンドライン引数 (例: make switch HOST=work-mac)
#  2. ~/dotfiles/.nix-host ファイル (各マシン固有、gitignored)
#  3. fallback: macbook-casone
HOST ?= $(shell cat $(HOME)/dotfiles/.nix-host 2>/dev/null || echo macbook-casone)

help: ## このヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'
	@echo
	@echo "  current HOST: \033[33m$(HOST)\033[0m"

switch: ## nix-darwin + Home Manager をビルドして反映 (nix/ 配下を自動 stage)
	@git -C $(HOME)/dotfiles add -A nix/
	sudo darwin-rebuild switch --flake $(FLAKE)#$(HOST)

update: ## flake input を全て最新化
	nix flake update --flake $(FLAKE)

gc: ## /nix/store の不要な世代を一括削除
	sudo nix-collect-garbage -d
	nix-collect-garbage -d

check: ## flake の評価チェック (構文 / 依存)
	nix flake check $(FLAKE)

show: ## flake.nix の outputs (= 利用可能な darwinConfigurations) を表示
	nix flake show $(FLAKE)
