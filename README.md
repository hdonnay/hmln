hmln v2
====

hmln v2 is a complete re-write of hmln in perl and utilzing git
submodules, instead of bash and git branches.

This re-thinking of hmln uses individual git repos for specific configs
for programs. For example, one for vim, and one for zsh.

The largest changes are that the configs are stored in one file and
the link command now performs git actions for you, minimizing the need to
manually interact with git.

Instructions
------------

Required perl modules:

 * FindBin
 * Config::GitLike
 * File::Copy

The install process should go something like this:

    % mkdir .dotfiles && cd .dotfiles
    % git init .
    % git remote add hmln https://hdonnay@github.com/hdonnay/hmln.git
    % git remote add origin git@git-host:me/dotfiles.git
    % git pull hmln master
    # Note: 'master' is always the current stable version
    % ./link add git@git-host:me/vim.git
    % git commit -am "Initial commit"
    % git push origin master

The process is much simpler to install an existing hmln repo on a new
machine:

    % git clone git@git-host:me/dotfiles.git .dotfiles
    % cd .dotfiles
    % ./link init
    # Note: 'init' isn't implemented yet. 'update' should have the desired
    # effect, assuming your git submodules are in order.

To update hmln, just pull from the hmln repo:

    # If not already added:
    % git remote add hmln https://hdonnay@github.com/hdonnay/hmln.git
    % git pull hmln master
    # Push to your personal repo:
    % git push origin master

hmln v1
-------

To fetch the old version, or grab a v1 tarball:

    % wget https://github.com/hdonnay/hmln/tarball/v1
