# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

GRC_ALIASES=true
[[ -s "/etc/profile.d/grc.sh" ]] && source /etc/grc.sh


bind 'set completion-ignore-case on'

# Exports:

export TERMINAL='st'
export BROWSER='firefox'
export EDITOR='nvim'
export XDG_RUNTIME_DIR='/tmp/runtime-dir/'
export PATH="$HOME/.local/bin:$PATH"
export READER='zathura'
#export PATH="/usr/bin:$PATH"

# get current branch in git repo
# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

export PS1="[\[\e[36m\]\w\[\e[m\]\[\e[35m\]\`parse_git_branch\`\[\e[m\]] "
#PS1='[\u@\h \W]\$ '

# XBPS:

alias q='xbps-query -Rs'
alias u='sudo xbps-install -Su'
alias i='sudo xbps-install -S'
alias c='sudo xbps-remove -o && sudo xbps-remove -O'
alias dp='sudo xbps-remove'

# Other:
alias l='lsd -al'
alias ll='lsd -a'
alias ls='lsd --color=auto'
alias lh='lsd -hl'
alias s='source ~/.bashrc'
alias f='ffmpeg'
alias v='vim'
alias n='nvim'
alias sn='sudo nvim'
alias cat='bat --style=plain'
alias e="emacs"
# alias mn="sudo mount /dev/sdc1 Usb/"
# alias um="sudo umount /dev/sdc1"
alias poff='sudo poweroff'
alias rbt='sudo reboot'
alias mci='sudo make clean install'
alias m='mpv'
alias htop='htop -t'
alias d='diff -u'
alias t='tty-clock -cC 5'
alias vim='nvim'
alias neofetch='neofetch --ascii ascii.txt'
alias ufetch='ufetch | lolcat'
alias grep='ugrep'
alias zzz='sudo zzz'
#alias insta='instaloader --login one_to_mini :saved --no-metadata-json --no-video-thumbnail'
# Git Stuff:

alias gclone='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME clone'
alias gstat='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME status'
alias gcom='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME commit -m'
alias gclean='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME clean'
alias grest='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME restore'
alias gadd='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME add'
alias gpush='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME push'
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# Download:

alias yl='yt-dlp -F'
alias y='yt-dlp'
alias ya='yt-dlp -f 140'
alias yb='yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --merge-output-format mp4'
alias yt='yt-dlp yt-dlp --skip-download --write-thumbnail'

# For recording.
#
#alias ff="ffmpeg -framerate 16 -f x11grab -s 1920x1080 -i :0.0+0,0 Output.mkv"
#alias rec="ffmpeg -framerate 24 -f x11grab -video_size 1920x1080 -i :0.0+1366,0 -preset ultrafast -crf 8 ~/Recordings/Output.mkv"
#
#

#[ -f ~/.fzf.bash ] && source ~/.fzf.bash
#figlet -c -f ANSI_Shadow.flf "Void/runit" -t | lolcat
