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

# Calculate performance metrics
metrics=""
if [[ -n "$transcript_path" ]] && [[ "$transcript_path" != "null" ]] && [[ -f "$transcript_path" ]]; then
    # Count messages (looking for message boundaries)
    msg_count=$(grep -c '"role":\s*"' "$transcript_path" 2>/dev/null || echo "0")
    
    # Estimate token usage (rough estimate: ~4 chars per token)
    if [[ -s "$transcript_path" ]]; then
        char_count=$(wc -c < "$transcript_path" 2>/dev/null || echo "0")
        token_estimate=$((char_count / 4))
        
        # Format token count for readability
        if [[ $token_estimate -ge 1000000 ]]; then
            token_display="${token_estimate:0:${#token_estimate}-6}.${token_estimate:${#token_estimate}-6:1}M"
        elif [[ $token_estimate -ge 1000 ]]; then
            token_display="${token_estimate:0:${#token_estimate}-3}.${token_estimate:${#token_estimate}-3:1}K"
        else
            token_display="${token_estimate}"
        fi
    else
        token_display="0"
    fi
    
    # Calculate session duration using file modification time
    if [[ -f "$transcript_path" ]]; then
        # Get file modification time and current time
        if command -v stat >/dev/null 2>&1; then
            if stat -f%m "$transcript_path" >/dev/null 2>&1; then
                # macOS stat
                file_mtime=$(stat -f%m "$transcript_path" 2>/dev/null || echo "0")
            else
                # Linux stat
                file_mtime=$(stat -c%Y "$transcript_path" 2>/dev/null || echo "0")
            fi
        else
            file_mtime="0"
        fi
        
        current_time=$(date +%s)
        duration=$((current_time - file_mtime))
        
        # Format duration
        if [[ $duration -ge 3600 ]]; then
            hours=$((duration / 3600))
            minutes=$(((duration % 3600) / 60))
            duration_display="${hours}h${minutes}m"
        elif [[ $duration -ge 60 ]]; then
            minutes=$((duration / 60))
            seconds=$((duration % 60))
            duration_display="${minutes}m${seconds}s"
        else
            duration_display="${duration}s"
        fi
    else
        duration_display="0s"
    fi
    
    # Build compact metrics string
    metrics=" ${token_display}t·${msg_count}m·${duration_display}"
fi

# Format similar to your p10k style: user@host dir git_info | model [metrics]
printf "\033[38;5;242m%s@%s\033[0m \033[38;5;4m%s\033[0m\033[37m%s\033[0m \033[38;5;5m❯\033[0m \033[38;5;214m%s\033[0m\033[38;5;214m%s\033[0m" \
    "$username" "$hostname" "$dir_display" "$git_info" "$model_name" "$metrics"