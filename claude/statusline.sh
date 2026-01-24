#!/bin/bash

# Read JSON input
input=$(cat)

# Extract data
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
output_style=$(echo "$input" | jq -r '.output_style.name')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Get current directory name
dir_name=$(basename "$current_dir")

# Get git branch if in a git repo
git_branch=""
if git -C "$current_dir" rev-parse --git-dir > /dev/null 2>&1; then
    git_branch=$(git -C "$current_dir" --no-optional-locks branch --show-current 2>/dev/null)
    if [ -n "$git_branch" ]; then
        git_branch=" $git_branch"
    fi
fi

# Build status line with colors
printf "\033[34m%s\033[0m" "$dir_name"
if [ -n "$git_branch" ]; then
    printf "\033[35m%s\033[0m" "$git_branch"
fi
printf " \033[33m%s\033[0m" "$model"
if [ -n "$output_style" ] && [ "$output_style" != "null" ]; then
    printf " \033[32m(%s)\033[0m" "$output_style"
fi
if [ -n "$remaining" ]; then
    printf " \033[90mctx:%s%%\033[0m" "$remaining"
fi
