hmln
====
The solution to keeping your dotfiles tidy.
----
`hmln` (pronounced "homelink") is a series of scripts and rule modules that, in combination with a git (or any vcs) repo, will keep your dotfiles clean and manageable between machines.

### Usage:
***
`hmln` lives along side your dotfiles in a repo. The default place for them is `~/.dotfiles`.

To install, simply clone this repo, `cd` into it, and run `./install.sh`. This will copy `link.sh`, `update-branches.sh`, and a basic rule module set.
You can then copy in your dotfiles. If there are any modules you won't use (they're stored in `~/.dotfiles/.hmln` by default) you should delete them, as hmln assumes you want to use all modules, and will prompt you for every one it finds.

To link your dotfiles, `cd` into `~/.dotfiles` and run `./link.sh`. This will back up any files that are in the way of the links to be created.
The default place for the backups is `~/.dotfiles.bak`. `link.sh` will prompt you to link every module it finds. If you only want to link one module, you can use `./link.sh <name>`, where <name> is a module name.

### Modules
***
Rule modules are files ending in `.hmln` in `~/.dotfiles/.hmln`. The name of the module is the part before `.hmln`.
Inside a module there should be a bash function called `hmln_<name>`. The name part should be the same as the name of the module, case sensitive.
This function has a needed variable called `prefix` which is used to group files within the `~/.dotfiles` directory. These modules and access some common routines, stored in `~/.dotfiles/.hmln/hmln_functions.sh` by default.
Most of the names should be pretty explanitory, but the functions are (I feel) pretty obvious in what they're doing.

***
## Note:
### The rule modules are just straight sourced, and any valid bash will be evaluated.
***
Why is this?

Because it's an easy way to make the rules extensible. If you'd like to do something more complicated than the given functions provide, simply script it and it will work fine with hmln.

### `update-branches.sh`
***
This is used to maintain machine-specifc configs in separate branches. When run, it prompts you if you'd like to cherry-pick the latest commit into 'master', and then if you'd like to merge 'master' into any local branches.
This way, you can keep 'master' as generic as possible, but also prevent it from becoming outdated.
