#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract information from JSON
model_name=$(echo "$input" | jq -r '.model.display_name')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')
session_id=$(echo "$input" | jq -r '.session_id')
transcript_path=$(echo "$input" | jq -r '.transcript_path')

# Get system information
username=$(whoami)
hostname=$(hostname -s)

# Get directory info - show relative to project if inside project, otherwise show basename
if [[ "$current_dir" == "$project_dir"* ]] && [[ -n "$project_dir" ]] && [[ "$project_dir" != "null" ]]; then
    # Inside project - show relative path from project root
    relative_path=${current_dir#$project_dir}
    relative_path=${relative_path#/}  # Remove leading slash
    if [[ -z "$relative_path" ]]; then
        dir_display="$(basename "$project_dir")"
    else
        dir_display="$(basename "$project_dir")/$relative_path"
    fi
else
    # Outside project or no project - show basename of current directory
    dir_display=$(basename "$current_dir")
fi

# Get git status if in a git repository
git_info=""
if git rev-parse --is-inside-work-tree &>/dev/null; then
    branch=$(git branch --show-current 2>/dev/null)
    if [[ -z "$branch" ]]; then
        # Detached HEAD
        commit=$(git rev-parse --short HEAD 2>/dev/null)
        branch="@$commit"
    fi
    
    # Check for dirty status
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        git_info=" $branch (dirty)"
    else
        git_info=" $branch (clean)"
    fi
fi

# Get current date and time
current_date=$(date +"%Y/%m/%d")
current_time=$(date +"%H:%M")

# Format: "2025/08/22 14:35 ❯ dotfiles main(clean) ❯ Claude 3.5 Sonnet"
# Date/time uses same color as directory name (color 4 = blue)
printf "\033[38;5;4m%s %s\033[0m \033[38;5;5m❯\033[0m \033[38;5;4m%s\033[0m\033[37m%s\033[0m \033[38;5;5m❯\033[0m \033[38;5;214m%s\033[0m" \
    "$current_date" "$current_time" "$dir_display" "$git_info" "$model_name"