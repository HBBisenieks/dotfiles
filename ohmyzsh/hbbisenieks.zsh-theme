# HBBisenieks ohmyzsh theme, with either color-block or emoji-based exit status in prompt

# OLD Prompt, kept for posterity.
# PROMPT='$BG[008] %B%n %{$bg[blue]%} %c %(?.$BG[002].$BG[001])  %{$reset_color%} $FG[003]%#%b '

where=""
SESSION_TYPE='local'

prompt_context() {
	if [[ -n "$SSH_CONNECTION" ]] ; then
		where="%m"
		SESSION_TYPE='ssh'
	fi
}

prompt_context

if [[ `uname` == 'Linux' || "$SESSION_TYPE" == 'ssh' ]] ; then
	# Color-based exit status prompt for Linux and remote connections
	PROMPT='$FG[007]$BG[199] %B%n $BG[128] $where $BG[021] %c %{$reset_color%} %(?.$BG[002].$BG[001])  %{$reset_color%} $FG[003]%#%b '
elif [[ `uname` == 'Darwin' ]] ; then
		# Emoji-based exit status prompt for Mac
		PROMPT='$FG[007]$BG[199] %B%n $BG[128] $where $BG[021] %c %{$reset_color%} %(?.✨ .💀 ) $FG[003]%#%b '
fi

RPROMPT='%{$fg[magenta]%}$(git_prompt_info)%{$reset_color%} $(git_prompt_status)%{$reset_color%} $BG[141]  $BG[255]  $BG[070]  %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} ✈"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} ✭"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✗"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} ➦"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} ✂"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%} ✱"
