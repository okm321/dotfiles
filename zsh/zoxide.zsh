# zoxide with git worktree awareness
# Converts paths to current worktree when jumping within the same repository

function __zoxide_worktree_convert() {
    local target_path="$1"

    # Check if we're inside a git repository
    local current_toplevel
    current_toplevel="$(git rev-parse --show-toplevel 2>/dev/null)" || return 1

    # Get git common dir (shared across worktrees)
    local git_common_dir
    git_common_dir="$(git rev-parse --git-common-dir 2>/dev/null)" || return 1

    # List all worktrees
    local worktrees
    worktrees="$(git worktree list --porcelain 2>/dev/null)" || return 1

    # Find worktree that contains the target path
    local worktree_root
    while IFS= read -r line; do
        if [[ "$line" =~ ^worktree\ (.+)$ ]]; then
            worktree_root="${match[1]}"
            # Check if target path is under this worktree
            if [[ "$target_path" == "$worktree_root"* ]] && [[ "$worktree_root" != "$current_toplevel" ]]; then
                # Convert path to current worktree
                local relative_path="${target_path#$worktree_root}"
                local converted_path="${current_toplevel}${relative_path}"

                # Only return if the converted path exists
                if [[ -d "$converted_path" ]]; then
                    echo "$converted_path"
                    return 0
                fi
            fi
        fi
    done <<< "$worktrees"

    return 1
}

function cd() {
    # Fallback to builtin cd if zoxide is not initialized
    if ! typeset -f __zoxide_z > /dev/null 2>&1; then
        builtin cd "$@"
        return
    fi

    # If no arguments or special cases, use default behavior
    if [[ "$#" -eq 0 ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]$ ]]; then
        __zoxide_z "$@"
        return
    fi

    # If path exists, use default behavior
    if [[ -d "$1" ]]; then
        __zoxide_z "$@"
        return
    fi

    # Query zoxide for the target path
    local result
    result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@" 2>/dev/null)"

    if [[ -z "$result" ]]; then
        __zoxide_z "$@"
        return
    fi

    # Try to convert to current worktree
    local converted
    converted="$(__zoxide_worktree_convert "$result")"

    if [[ -n "$converted" ]]; then
        __zoxide_cd "$converted"
    else
        __zoxide_cd "$result"
    fi
}

function cdi() {
    local result
    result="$(\command zoxide query --interactive -- "$@" 2>/dev/null)"

    if [[ -z "$result" ]]; then
        return 1
    fi

    # Try to convert to current worktree
    local converted
    converted="$(__zoxide_worktree_convert "$result")"

    if [[ -n "$converted" ]]; then
        __zoxide_cd "$converted"
    else
        __zoxide_cd "$result"
    fi
}
