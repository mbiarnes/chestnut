#!/bin/bash -e

echo "target :" $target
echo "release branch :" $releaseBranch

# clone the build-bootstrap that contains the other build scripts
if [ "$target" == "community" ]; then
   git clone git@github.com:kiegroup/droolsjbpm-build-bootstrap.git --branch $releaseBranch
else
   git clone ssh://jb-ip-tooling-jenkins@code.engineering.redhat.com/kiegroup/droolsjbpm-build-bootstrap --branch $releaseBranch
fi

# clone rest of the repos and checkout to this branch
./droolsjbpm-build-bootstrap/script/git-clone-others.sh --branch $releaseBranch