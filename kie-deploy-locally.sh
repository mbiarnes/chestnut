#!/bin/bash -e


# removing KIE artifacts from local maven repo (basically all possible SNAPSHOTs)
echo $MAVEN_REPO_LOCAL "="

if [ -d $MAVEN_REPO_LOCAL ]; then
    rm -rf $MAVEN_REPO_LOCAL/org/jboss/dashboard-builder/
    rm -rf $MAVEN_REPO_LOCAL/org/kie/
    rm -rf $MAVEN_REPO_LOCAL/org/drools/
    rm -rf $MAVEN_REPO_LOCAL/org/jbpm/
    rm -rf $MAVEN_REPO_LOCAL/org/optaplanner/
    rm -rf $MAVEN_REPO_LOCAL/org/uberfire/

fi

# removes kie.properties if it exists
file="kie.properties"
if [ -f "$file" ]; then
   echo "$file found."
   rm $file
fi

# fetch the <version.org.kie> from kie-parent-metadata pom.xml and set it on parameter KIE_VERSION
kieVersion=$(sed -e 's/^[ \t]*//' -e 's/[ \t]*$//' -n -e 's/<version.org.kie>\(.*\)<\/version.org.kie>/\1/p' droolsjbpm-build-bootstrap/pom.xml)

# creates a properties file to pass variables and moves it to the root directory
echo kieVersion=$kieVersion > kie.properties
echo target=$target >> kie.properties

# build release branches
if [ "$target" == "community" ]; then
   deployDir=$WORKSPACE/community-deploy-dir
   # do a full build, but deploy only into local dir
   # we will deploy into remote staging repo only once the whole build passed (to save time and bandwith)
   ./droolsjbpm-build-bootstrap/script/mvn-all.sh -B -e -U clean deploy -Dfull -Drelease -T2 -DaltDeploymentRepository=local::default::file://$deployDir -Dmaven.test.failure.ignore=true -Dgwt.memory.settings="-Xmx10g -Xms1g -Xss1M" -Dgwt.compiler.localWorkers=2

elif [ "$target" == "daily" ]; then
   deployDir=$WORKSPACE/daily-deploy-dir
   # do a full build, but deploy only into local dir
   # we will deploy into remote staging repo only once the whole build passed (to save time and bandwith)
   ./droolsjbpm-build-bootstrap/script/mvn-all.sh -B -e -U clean deploy -Dfull -Drelease -T2 -DaltDeploymentRepository=local::default::file://$deployDir -Dmaven.test.failure.ignore=true -Dgwt.memory.settings="-Xmx10g -Xms1g -Xss1M" -Dgwt.compiler.localWorkers=2

elif [ "$target" == "productized" ]; then
   deployDir=$WORKSPACE/prod-deploy-dir
   # do a full build with prod look & feel (-Dproductized), but deploy only into local dir
   # we will deploy into remote staging repo only once the whole build passed (to save time and bandwith)
   ./droolsjbpm-build-bootstrap/script/mvn-all.sh -B -e -U clean deploy -Dfull -Dproductized -Drelease -T2 -DaltDeploymentRepository=local::default::file://$deployDir -Dmaven.test.failure.ignore=true -Dgwt.memory.settings="-Xmx10g -Xms1g -Xss1M" -Dgwt.compiler.localWorkers=2
fi