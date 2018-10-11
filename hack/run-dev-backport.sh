#!/bin/bash

# Backports branch specified by $1 to `branches` from the development head `devbranch`
# Tipp: enable git rerere to record and remember your conflict resolution.      It will make your life easier!


folders=("vendor/odoo/cc/.git" "vendor/odoo/ee/.git")
devbranch="master"
branches=("11.0")
owndev="dev"
prefix="remotes/"
candidate_branches="remotes/${owndev}/${devbranch}-"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

cherry_pick_alert() {
    echo -e "\n${RED}The cherry pick failed (see logs).${NC}"
    echo -e "${RED}Please open another terminal and handle the issue.${NC}"
    read -p "Do you want to continue this script? (Y/n)" -n 1 -r
    echo -e ""
    if ! [[ $REPLY =~ ^[Yy]$ ]]; then
        eval "${gitcmd} cherry-pick --abort"
        eval "${gitcmd} checkout ${HEAD}"
        eval "${gitcmd} branch -D ${newbranch}"
        exit 1
    fi
    cherry_pick_continue
}

cherry_pick_continue () {
    if ! eval "${gitcmd} cherry-pick --continue"; then
        cherry_pick_alert
    fi
}

for folder in "${folders[@]}"; do
    echo -e "\nBackporting patches in ${folder}\n"
    gitcmd="git --git-dir ${folder}"
    HEAD=$(eval "${gitcmd} rev-parse --abbrev-ref HEAD")
    # Use command arguments instead of all detectable branches, if present
    if ! [[ $# -eq 0 ]] ;then
        candidates=()
        detected=($(eval "$gitcmd branch -a | grep '${candidate_branches}'"))
        for arg in "${@}"; do
            if [[ $arg != "${owndev}/${devbranch}-"* ]]; then
                echo -e "${RED}A valid candidate branch would have prefix: '${owndev}/${devbranch}-'. \nGot: '${arg}'.${NC}"
                exit 1
            fi
            for d in "${detected[@]}";do
                if [[ "${d}" == "${arg}" ]]; then
                    canidates+="${arg}"
                fi
            done

        done
        candidates=(${@})
    else
        candidates=($(eval "$gitcmd branch -a | grep '${candidate_branches}'"))
    fi

    for branch in "${branches[@]}"; do
        for candidate in "${candidates[@]}"; do
            candidate=${candidate#"$prefix"}
            echo -e "\n${GREEN}Backporting ${candidate} to ${branch}${NC}\n"
            eval "${gitcmd} checkout ${branch}"
            # Create appropriate name for target branch
            newbranch=${branch}${candidate#"$owndev/$devbranch"}
            eval "${gitcmd} checkout -b ${newbranch}"
            commits=($(eval "${gitcmd} cherry ${owndev}/${devbranch} ${candidate}" | sed 's/^+ //'))
            if ! eval "${gitcmd} cherry-pick" "${commits[@]}"; then
                cherry_pick_alert
            fi
            echo -e "\nPushing ${newbranch} to ${owndev}"
            eval "${gitcmd} push -f ${owndev}"
            eval "${gitcmd} checkout ${branch}"
            eval "${gitcmd} branch -D ${newbranch}"
        done
    done
    eval "${gitcmd} checkout ${HEAD}"
done
