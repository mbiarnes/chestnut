#!/bin/bash -e

echo "kie version :"  $releaseVersion
echo "uberfire version :" $uberfireVersion
echo "errai version :" $erraiVersion
echo "target :" $target

# upgrades the version to the release/tag version
./droolsjbpm-build-bootstrap/script/release/update-version-all.sh $releaseVersion $uberfireVersion $target


# change properties via sed as they don't update automatically
#appformer
cd appformer
sed -i \
-e "$!N;s/<version.org.kie>.*.<\/version.org.kie>/<version.org.kie>$releaseVersion<\/version.org.kie>/;" \
-e "s/<version.org.jboss.errai>.*.<\/version.org.jboss.errai>/<version.org.jboss.errai>$erraiVersion<\/version.org.jboss.errai>/;P;D" \
pom.xml
cd ..

#droolsjbpm-build-bootstrap
cd droolsjbpm-build-bootstrap/
sed -i \
-e "$!N;s/<version.org.uberfire>.*.<\/version.org.uberfire>/<version.org.uberfire>$uberfireVersion<\/version.org.uberfire>/;" \
-e "s/<version.org.kie>.*.<\/version.org.kie>/<version.org.kie>$releaseVersion<\/version.org.kie>/;" \
-e "s/<version.org.jboss.errai>.*.<\/version.org.jboss.errai>/<version.org.jboss.errai>$erraiVersion<\/version.org.jboss.errai>/;" \
-e "s/<latestReleasedVersionFromThisBranch>.*.<\/latestReleasedVersionFromThisBranch>/<latestReleasedVersionFromThisBranch>$releaseVersion<\/latestReleasedVersionFromThisBranch>/;P;D" \
pom.xml
cd ..

# git add and commit the version update changes
./droolsjbpm-build-bootstrap/script/git-all.sh add .
commitMsg="Upgraded versions for release $releaseVersion"
./droolsjbpm-build-bootstrap/script/git-all.sh commit -m "$commitMsg"
