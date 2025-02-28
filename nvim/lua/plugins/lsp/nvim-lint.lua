-- lua/plugins/lsp/nvim-lint.lua
return {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost" },
    config = function()
        local lint = require("lint")

        -- monorepo対応の設定ファイル検索関数
        local function find_config_file(filename, start_dir)
            local current_dir = start_dir or vim.fn.expand("%:p:h")
            local root_dir = vim.fn.getcwd()

            -- 現在のディレクトリに設定ファイルがあるか確認
            if vim.fn.filereadable(current_dir .. "/" .. filename) == 1 then
                return current_dir .. "/" .. filename
            end

            -- 親ディレクトリを遡る（ルートディレクトリまで）
            local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
            if parent_dir == current_dir or current_dir == root_dir then
                return nil
            end

            return find_config_file(filename, parent_dir)
        end

        -- リンター設定
        lint.linters_by_ft = {
            javascript = { "eslint" },
            typescript = { "eslint" },
            javascriptreact = { "eslint" },
            typescriptreact = { "eslint" },
            vue = { "eslint" },
            terraform = { "tflint" },
            hcl = { "tflint" },
            markdown = { "markdownlint-cli2" },
            sql = { "sqlfluff" },
        }

        -- プロジェクト固有のリンターを検出（monorepo対応版）
        local function get_linters(ft)
            -- JavaScriptとTypeScript関連
            if ft:match("javascript") or ft:match("typescript") then
                -- Biomeの設定ファイルを探す
                if find_config_file(".biome.json") then
                    -- Biomeがインストールされているか確認
                    if vim.fn.executable("biome") == 1 then
                        return { "eslint" } -- 一時的にBiomeの代わりにeslintを使用
                    end
                end

                -- ESLintの設定ファイルを探す
                if find_config_file(".eslintrc.js") or
                    find_config_file(".eslintrc.json") or
                    find_config_file(".eslintrc.yml") or
                    find_config_file(".eslintrc") then
                    return { "eslint" }
                end
                -- Vue
            elseif ft == "vue" then
                if find_config_file(".eslintrc.js") or
                    find_config_file(".eslintrc.json") or
                    find_config_file(".eslintrc.yml") or
                    find_config_file(".eslintrc") then
                    return { "eslint" }
                end
            end

            -- デフォルトのリンターを返す
            return lint.linters_by_ft[ft] or {}
        end

        -- リントを自動実行
        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
        vim.api.nvim_create_autocmd(
            { "BufWritePost" },
            {
                group = lint_augroup,
                callback = function()
                    -- ファイルタイプを取得
                    local ft = vim.bo.filetype
                    if ft == "" then return end

                    -- プロジェクト固有のリンターを取得
                    local linters = get_linters(ft)

                    -- 遅延実行でエラー抑制
                    vim.defer_fn(function()
                        if #linters > 0 then
                            -- 特定のリンターを使用
                            lint.try_lint(linters)
                        else
                            -- デフォルトのリンターを使用
                            lint.try_lint()
                        end
                    end, 100)
                end,
            }
        )

        -- デバッグコマンドの追加
        vim.api.nvim_create_user_command("LintDebug", function()
            local file = vim.fn.expand("%:p")
            local ft = vim.bo.filetype
            print("Current file:", file)
            print("Current filetype:", ft)

            local linters = get_linters(ft)
            print("Selected linters:", vim.inspect(linters))

            if ft:match("javascript") or ft:match("typescript") or ft == "vue" then
                local biome_path = find_config_file(".biome.json") or "not found"
                local eslint_path = find_config_file(".eslintrc.js") or
                    find_config_file(".eslintrc.json") or
                    find_config_file(".eslintrc.yml") or
                    find_config_file(".eslintrc") or "not found"

                print("Biome config found at:", biome_path)
                print("ESLint config found at:", eslint_path)

                -- eslintとbiomeコマンドが利用可能か確認
                print("eslint executable:", vim.fn.executable("eslint") == 1)
                print("eslint_d executable:", vim.fn.executable("eslint_d") == 1)
                print("biome executable:", vim.fn.executable("biome") == 1)
            end
        end, {})
    end,
}
