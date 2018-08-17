#!/bin/bash

# This script starts your daily routine by
# 	1. fetching all upstreams with --prune flag
#	2. merging from remote tracking branches for `branches` (see below)
#	3. push those to remote named `dev` (see below)

# Prerequisite: for odoo into your organization, set this as `dev` remote

folders=("vendor/odoo/cc/.git" "vendor/odoo/ee/.git")
branches=("master" "11.0")
owndev="dev"


for folder in "${folders[@]}"; do
    echo -e "\n\nFetching ${folder}\n"
    gitcmd="git --git-dir ${folder}"
    eval "${gitcmd} fetch --all --prune"
    for branch in "${branches[@]}"; do
        echo -e "\n\nUpdating ${branch}\n"
        eval "${gitcmd} checkout ${branch}"
        eval "${gitcmd} merge"
        echo -e "\nPushing ${branch} to ${owndev}"
        eval "${gitcmd} push ${owndev}"
    done
done
