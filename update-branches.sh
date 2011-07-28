#!/bin/bash
CURRENT_BRANCH=`git branch | grep '*' | cut -c 3-`
COMMIT=`git rev-parse ${CURRENT_BRANCH}`

#echo "${COMMIT}"
if [ "${CURRENT_BRANCH}" = "master" ]; then
    echo -ne "\nAlready on branch \"master\"\n"
else
    read -n 1 -p "Should this commit be added to master? [y]/n " input
    if [ "${input}" = "n" ] || [ "${input}" != "" ] || [ "${input}" != "y" ]; then
        git checkout master
        eval "git cherry-pick ${COMMIT}"
    fi
fi

for i in `git branch -l | cut -c 3- | grep -v ${CURRENT_BRANCH} | grep -v 'master' | tr '\n' ' '`; do
    echo -ne "\n"
    read -n 1 -p "Would you like to merge master into branch \"${i}\"? [y]/n " input
    echo -ne "\n"
    if [ "${input}" = "" ] || [ "${input}" = "y" ]; then
        eval "git checkout ${i}"
        eval "git merge master"
    else
        read -n 1 -p "Should I cherry-pick the last commit, in that case? [y]/n " input
        if [ "${input}" = "" ] || [ "${input}" = "y" ]; then
            eval "git checkout ${i}"
            eval "git cherry-pick ${COMMIT}"
        fi
    fi
done

eval "git checkout ${CURRENT_BRANCH}"
