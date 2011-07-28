#!/bin/bash
# Common functions for hmln
testAndLink()
{
    if [ ! -z ${1} ]; then
      if [ -h "${HOME}/.${1}" ]; then
        echo -ne "\tFound a symbolic link, deleting.\n"
        rm "${HOME}/.${1}"
      elif [ -f "${HOME}/.${1}" ]; then
        echo -ne "\tFound an existing config, moving.\n"
        mkdir -p "${BACKUP_DIR}/${prefix}"
        mv "${HOME}/.${1}" "${BACKUP_DIR}/${prefix}${1}"
      fi
      ln -s "${DOTFILES_DIR}/${prefix}${1}" "${HOME}/.${1}"
    else
      echo "hmln: testAndLink called without argument" 1>&2
    fi
}

testAndLinkPrefix()
{
  if [ ! ${prefix} = '' ]; then
    if [ -h $(echo "${HOME}/.${prefix}" | sed s/.$//) ]; then
      echo -ne "\tFound a symbolic link for a directory, deleting.\n"
      rm $(echo "${HOME}/.${prefix}" | sed s/.$//)
      mkdir "${BACKUP_DIR}/${prefix}" 2>&1 > /dev/null
    elif [ -d "${HOME}/.${prefix}" ]; then
      mv $(echo "${HOME}/.${prefix}" | sed s/.$//) $(echo "${BACKUP_DIR}/${prefix}" | sed s/.$//)
    fi
    ln -s $(echo "${DOTFILES_DIR}/${prefix}" | sed s/.$//) $(echo "${HOME}/.${prefix}" | sed s/.$//)
  else
    echo "hmln: testAndLinkPrefix called on an empty prefix" 1>&2
  fi
}

createFile()
{
  if [ ! -z ${1} ]; then
    if [ -f "${HOME}/.${1}" ]; then
      if [ $(echo "${1}" | grep .local | wc -l) = "1" ]; then
        echo -ne "\tFound an existing .local config, copying to backup.\n<<<<<<<<\n"
        cp "${HOME}/.${1}" "${BACKUP_DIR}/${1}" 2>&1 > /dev/null
        read -n 1 -p "Should I remove the existing config? y/[n] " input
        echo -ne "\n>>>>>>>>\n"
        if [ "${input}" = '' ] || [ "${input}" = "n" ]; then
          return
        fi
      fi
      mv "${HOME}/.${1}" "${BACKUP_DIR}/${1}"
    fi
    touch "${HOME}/.${1}"
    echo -ne "\t~/.${1} has been created.\n<<<<<<<<\t"
    read -n 1 -p "Would you like to edit .${1}? [y]/n " input
    if [ "${input}" = '' ] || [ "${input}" = "y" ]; then
      ${EDITOR} "${HOME}/.${1}"
    fi
    echo -ne "\n>>>>>>>>\n"
  else
    echo "hmln: createFile called without an argument" 1>&2
  fi
}

createFileInPrefix()
{
  if [ ! -z ${1} ]; then
    if [ -f "${HOME}/.${prefix}${1}" ]; then
      if [ $(echo "${1}" | grep .local | wc -l) = "1" ]; then
        echo -ne "\tFound an existing .local config, copying to backup.\n<<<<<<<<\n"
        cp "${HOME}/.${prefix}${1}" "${BACKUP_DIR}/${prefix}${1}" 2>&1 > /dev/null
        read -n 1 -p "Should I remove the existing config? y/[n] " input
        echo -ne "\n>>>>>>>>\n"
        if [ "${input}" = '' ] || [ "${input}" = "n" ]; then
          return
        fi
      fi
      mv "${HOME}/.${prefix}${1}" "${BACKUP_DIR}/${prefix}${1}"
    fi
    touch "${HOME}/.${prefix}${1}"
    echo -ne "\t~/.${prefix}${1} has been created.\n<<<<<<<<\n\t"
    read -n 1 -p "Would you like to edit ${1}? [y]/n " input
    if [ "${input}" = '' ] || [ "${input}" = "y" ]; then
      ${EDITOR} "${HOME}/.${prefix}${1}"
    fi
    echo -ne "\n>>>>>>>>\n"
  else
    echo "hmln: createFileInPrefix called without an argument" 1>&2
  fi
}

createDir()
{
  if [ ! -z ${1} ]; then
    if [ ! -d ${HOME}/.${prefix}${1} ]; then
      mkdir ${HOME}/.${prefix}${1}
    else
      echo -ne "\tTried to create directory ${HOME}/.${prefix}${1}, but it already exists.\n"
    fi
  else
    echo "hmln: createDir called without an argument" 1>&2
  fi
}

createSymlink()
{
  if [ ! -z ${1} ] && [ ! -z ${2} ]; then
    echo -ne "<<<<<<<<\nSelect the file you want ${1} to be symlinked to.\n"
    select input in $(echo "${prefix}${2}"); do
      if [ -h "${prefix}${1}" ]; then
        echo -ne "\tFound existing symbolic link, recreating.\n"
        rm "${prefix}${1}"
      fi
      ln -s "${prefix}${input}" "${prefix}${1}"
      echo -ne ">>>>>>>>\n"
      break
    done
  else
    echo "hmln: createSymlink called with improper arguments" 1>&2
  fi
}
