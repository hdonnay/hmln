#!/bin/bash
DOTFILES_REPO="${HOME}/.dotfiles"

echo -ne "hmln installer v0.8\n\
>>>>>>>>\n\
Any existing versions of 'link.sh' and 'update-branches.sh' at ${DOTFILES_REPO} will be squashed.\n\
An existing modules dir will not be touched.\n\
If this is undesireable, ^c in the next 5 seconds.\n\n"

sleep 5

echo -ne "Doing...\n"

if [ ! -d ${DOTFILES_REPO} ]; then
    eval "mkdir ${DOTFILES_REPO}"
    eval "cd ${DOTFILES_REPO}"
    eval "git init"
fi

eval "cp -f ./link.sh ${DOTFILES_REPO}/link.sh"
eval "cp -f ./update-branches.sh ${DOTFILES_REPO}/update-branches.sh"

if [ ! -d "${DOTFILES_REPO}/.hmln" ]; then
    eval "cp -r ./hmln ${DOTFILES_REPO}/.hmln"
fi

echo -ne "Done.\n\n"
