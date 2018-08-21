#!/bin/bash


# Creates a syntetic branch for track(s) specified bleow in `branches`
# Merges all branches pertaining to the respectiv basee branch
# Tipp: enable git rerere to record and remember your conflict resolution.      It will make your life easier!

folders=("vendor/odoo/cc/.git" "vendor/odoo/ee/.git")
devbranch="master"
branches=("11.0")
owndev="dev"
prefix="remotes/"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color


merge_alert() {
    echo -e "\n${RED}The merge failed (see logs).${NC}"
    echo -e "${RED}Please open another terminal and handle the issue.${NC}"
    read -p "Do you want to continue this script? (Y/n)" -n 1 -r
    echo -e ""
    if ! [[ $REPLY =~ ^[Yy]$ ]]; then
        eval "${gitcmd} merge --abort"
        eval "${gitcmd} checkout ${HEAD}"
        eval "${gitcmd} branch -D ${newbranch}"
        exit 1
    fi
    merge_continue
}

merge_continue () {
    if ! eval "${gitcmd} merge --continue"; then
        merge_alert
    fi
}

for folder in "${folders[@]}"; do
    echo -e "\nCompile patches for ${folder}\n"
    gitcmd="git --git-dir ${folder}"
    HEAD=$(eval "${gitcmd} rev-parse --abbrev-ref HEAD")

    for branch in "${branches[@]}"; do
        candidate_branches="remotes/${owndev}/${branch}-"
        eval "${gitcmd} checkout ${branch}"
        newbranch="${branch}++compiled"
        eval "${gitcmd} checkout -b ${newbranch}"
        candidates=($(eval "$gitcmd branch -a | grep '${candidate_branches}'"))
        for candidate in "${candidates[@]}";do
            candidate=${candidate#"$prefix"}
            if ! eval "${gitcmd} merge --no-ff ${candidate}"; then
                merge_alert
            fi
        done
        echo -e "\nPushing ${newbranch} to ${owndev}"
        eval "${gitcmd} push -f ${owndev}"
        eval "${gitcmd} checkout ${branch}"
        eval "${gitcmd} branch -D ${newbranch}"
    done
    eval "${gitcmd} checkout ${HEAD}"
done
