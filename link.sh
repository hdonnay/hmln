#!/bin/bash
#####
# hmln - homelink
#
# Script to link dotfiles into a vcs repository.
#
# Usage:
#       ./link.sh and follow the prompts.
#
#       Or, specify a module name on the command line to run it.
#
#       Assumes rules are in .hmln files in ./.hmln/
#####
# Basic config variables
# assumes we're running from the repo
DOTFILES_DIR=`pwd`
BACKUP_DIR="${DOTFILES_DIR}.backup"
HMLN_DIR="${DOTFILES_DIR}/.hmln"

#Basic status info
echo -ne "hmln v1.2\n>>>>>>>>\n\tExisting files will be moved to ${BACKUP_DIR}\n"

if [ ! -d "${BACKUP_DIR}" ]; then
  mkdir "${BACKUP_DIR}"
fi

# Common functions
# Placed separately so you can see them when writing .hmln rules
source "${HMLN_DIR}/hmln_functions.sh"

if [ $1 ] && [ -r "${HMLN_DIR}/$1.hmln" ]; then
    echo -ne ">>>>>>>>\n\tReading module ${1}...\n"
    source "${HMLN_DIR}/${1}.hmln"
    echo -ne "\t========\n\tLinking ${1}...\n"
    eval "hmln_${1}"
    echo -ne "\tDone.\n"
else
    # Look for modules
    HMLN_MODULES=( $( cd ${HMLN_DIR} && /bin/ls -1 *.hmln | tr '\n' ' ' | sed s/\.hmln//g ) )
    # Loop through them, asking if we want to use them.
    for i in "${HMLN_MODULES[@]}"; do
      echo -ne "<<<<<<<<\n"
      read -n 1 -p "Link ${i}? [y]/n " input
      echo -ne "\n"
      if [ "$input" = "" ] || [ "$input" = "y" ]; then
        echo -ne ">>>>>>>>\n\tReading module ${i}...\n"
        source "${HMLN_DIR}/${i}.hmln"
        echo -ne "\t========\n\tLinking ${i}...\n"
        eval "hmln_${i}"
        echo -ne "\tDone.\n"
      fi
    done
fi
echo -ne ">>>>>>>>\n\tUpdate your VCS in `pwd` to update, no need to run this script every time.\n"
exit 0
