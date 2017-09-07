#!/bin/bash -e

# clone rest of the repos
./droolsjbpm-build-bootstrap/script/git-clone-others.sh --branch $baseBranch --depth 10

# git checkout to $baseBranch
./droolsjbpm-build-bootstrap/script/git-all.sh checkout $baseBranch
