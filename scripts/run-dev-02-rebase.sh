#!/bin/bash

# Rebases all branches named remotes/dev/* onto their respective base branch
# Base branch infered from the prefic, eg: `master-` or `v12-`, see `branches` below

folders=("vendor/odoo/cc/.git" "vendor/odoo/ee/.git")
branches=("master" "11.0")
owndev="dev"
prefix="remotes/"

candidate_branches="remotes/${owndev}"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

for folder in "${folders[@]}"; do
    echo -e "\n\n${RED}Rebasing ${folder}${NC}\n\n"
    gitcmd="git --git-dir ${folder}"
    HEAD=$(eval "${gitcmd} rev-parse --abbrev-ref HEAD")
    candidates=($(eval "$gitcmd branch -a | grep '${candidate_branches}'"))

    for candidate in "${candidates[@]}"; do
        candidate=${candidate#"$prefix"}
        isbase=
        for base in "${branches[@]}"; do
            if [[ "${candidate}" == "${owndev}/${base}" ]]; then
                isbase=yes
            fi
        done
        if [[ "${isbase}" != "yes" ]]; then
            for base in "${branches[@]}"; do
                if [[ "${candidate}" == "${owndev}/${base}-"* ]]; then
                    echo -e "\n${GREEN}Rebasing ${candidate} on ${base}${NC}\n"

                    branch=${candidate#"$owndev/"}
                    if eval "${gitcmd} checkout -b ${branch} ${candidate}"; then
                        if eval "${gitcmd} rebase ${base}"; then
                            eval "${gitcmd} push -f ${owndev}"
                            eval "${gitcmd} checkout ${base}"
                            eval "${gitcmd} branch -D ${branch}"
                        else
                            exit 1
                        fi
                    else
                        echo -e "  Could not checkout ${candidate}\n"
                        break
                    fi
                fi
            done
        fi
    done
    eval "${gitcmd} checkout ${HEAD}"
done
