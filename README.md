# dotfiles
Dotfiles for my Void desktop.


Use config (see the gadd, gcom, and gpush aliases in your .bashrc) instead of git for typical git operations.

STRAIGHT FROM Derek Taylor's YouTube video (https://www.youtube.com/watch?v=tBoLDpTWVOM)

Using git bare repositories, there is no more moving files into an initialized git repository and then creating symlinks.  Now, I just add, commit and then push.  Done.

Want to make your own git bare repository?  First, make a directory for your new git bare repository (I created one called "dotfiles" but you can name it whatever).

-------------------
Then I entered the following in the terminal:

git init --bare $HOME/dotfiles

alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME' (add this alias to .bashrc)

exec bash

config config --local status.showUntrackedFiles no

-------------------
Basic usage example:

gstat

gadd /path/to/file

gcom "A short message"

gpush

WHAT'S THE REASON FOR THE GIT BARE REPO?
-------------------

By using the git bare repo, you can have nested git repos in your home directory and there will not be any issue with keeping things straight.   That is the reason for the git bare repo and having an alias ("config").
