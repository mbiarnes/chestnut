#!/bin/bash -e

echo "kieVersion:" $kieVersion
echo "target" : $target
echo "WORKSPACE :" $WORKSPACE
echo "deployDir :" $deployDir

if [ "$target" == "community" ]; then
   stagingRep=kie-group
   # wget the tar.gz sources
   wget -q https://repository.jboss.org/nexus/content/groups/$stagingRep/org/drools/droolsjbpm-integration/$kieVersion/droolsjbpm-integration-$kieVersion-project-sources.tar.gz -O sources.tar.gz
elif [ "$target" == "productized" ]; then
   stagingRep=kie-internal-group
   # wget the tar.gz sources
   wget -q https://repository.jboss.org/nexus/content/groups/$stagingRep/org/drools/droolsjbpm-integration/$kieVersion/droolsjbpm-integration-$kieVersion-project-sources.tar.gz -O sources.tar.gz
elif [ "$target" == "daily" ]; then
   # unpack zip to QA Nexus
   cd $deployDir
   zip -r kiegroup .
   curl --upload-file kiegroup.zip -u $kieUnpack -v http://bxms-qe.rhev-ci-vms.eng.rdu2.redhat.com:8081/nexus/service/local/repositories/kieAllBuild/content-compressed
   cd ..
fi


tar xzf sources.tar.gz
mv droolsjbpm-integration-$kieVersion/* .
rmdir droolsjbpm-integration-$kieVersion