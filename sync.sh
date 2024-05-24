#!/bin/bash

# After forking a repo, set the upstream to the original repo the fork was made from to allow for syncing down from that original
# git remote add upstream git@github.com:zylon-ai/private-gpt.git
# git remote -v

# Use git cli to fetch upstream and merge with forked repo/branch
# git fetch upstream
# git checkout main
# git merge upstream/main

# Use Github CLI to accomplish the same thing, with one command
gh repo sync surfernv/private-gpt -b main

