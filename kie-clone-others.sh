#!/bin/bash -e

echo "kieBranch :" $baseBranch
echo "kie releaseBranch :" $releaseBranch
echo "tag name :" $tag
echo "source :" $source

# clone rest of the repos
./droolsjbpm-build-bootstrap/script/git-clone-others.sh --branch $baseBranch --depth 70

if [ "$source" == "community-branch" ]; then

   # checkout to local release names
   ./droolsjbpm-build-bootstrap/script/git-all.sh checkout -b $releaseBranch $baseBranch

fi

if [ "$source" == "community-tag" ]; then

   # get the tags of community
   ./droolsjbpm-build-bootstrap/script/git-all.sh fetch --tags origin

   # checkout to local release names
   ./droolsjbpm-build-bootstrap/script/git-all.sh checkout -b $releaseBranch $tag

fi

if [ "$source" == "production-tag" ]; then

   # add new remote pointing to gerrit
   ./droolsjbpm-build-bootstrap/script/git-add-remote-gerrit.sh

   # get the tags of gerrit
   ./droolsjbpm-build-bootstrap/script/git-all.sh fetch --tags gerrit

   # checkout to local release names
   ./droolsjbpm-build-bootstrap/script/git-all.sh checkout -b $releaseBranch $tag

fi


