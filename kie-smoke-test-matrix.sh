#!/bin/bash -e

echo "kieVersion:" $kieVersion
echo "target" : $target

if [ "$target" == "community" ]; then
   stagingRep=kie-group
   # wget the tar.gz sources
   wget -q https://repository.jboss.org/nexus/content/groups/$stagingRep/org/kie/kie-wb-distributions/$kieVersion/kie-wb-distributions-$kieVersion-project-sources.tar.gz -O sources.tar.gz
elif [ "$target" == "productized" ]; then
   stagingRep=kie-internal-group
   # wget the tar.gz sources
   wget -q https://repository.jboss.org/nexus/content/groups/$stagingRep/org/kie/kie-wb-distributions/$kieVersion/kie-wb-distributions-$kieVersion-project-sources.tar.gz -O sources.tar.gz
elif [ "$target" == "daily" ]; then
   # wget the tar.gz sources
   wget -q http://bxms-qe.rhev-ci-vms.eng.rdu2.redhat.com:8081/nexus/content/repositories/kieAllBuild/org/kie/kie-wb-distributions/$kieVersion/kie-wb-distributions-$kieVersion-project-sources.tar.gz -O sources.tar.gz
fi

tar xzf sources.tar.gz
mv jbpm-$kieVersion/* .
rmdir jbpm-$kieVersion