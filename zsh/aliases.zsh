# Claude Desktop 설정 파일 편집
alias claude-desktop-setting='nvim ~/Library/Application\ Support/Claude/claude_desktop_config.json'

# lazygit
alias gg='lazygit'

# yazi file manager
alias yz='yazi'

alias nv='nvim'

alias c='clear'

alias cl='claude'

alias cx='codex'

alias b='brxce'

alias ba='brxce add'

alias bt='brxce wn tree'

# bruce 프로젝트 폴더 열기
alias bn='cd ~/Projects/bruce && nv'

# docker logs for brxce-backend-dev
alias l1='docker logs -f brxce-backend-dev 2>&1 | grep "BRXCE:AGENT"'
alias l2='docker logs -f --tail 0 brxce-backend-dev 2>&1 | grep -E "BRXCE:AGENT|FAST"'
