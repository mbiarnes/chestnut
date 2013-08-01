# ------------------------------------------------------------------------------------------
# Script to build EAP 6.1 deployment structure for BPMS
#
# TODO
# - Dashboard builder
# - Optaplanner
# - Generate zip file with modules and WARS
# - Uberfire with specific dependencies
# - Clean dependencies
# - 
# ------------------------------------------------------------------------------------------
EAP_DIR=/home/mbiarnes/Development/Software/jboss-eap-6.1
DEPLOY_DIR=$EAP_DIR/modules
BASE_DIR=/home/mbiarnes/Development/modules

# Setup modules locations
MODULE_LIB=$BASE_DIR/system/layers/bpms/org/kie/lib
MODULE_KIE=$BASE_DIR/system/layers/bpms/org/kie
MODULE_JBPM=$BASE_DIR/system/layers/bpms/org/jbpm
MODULE_DROOLS=$BASE_DIR/system/layers/bpms/org/drools
# create modules 3rd party * kie-commons
MODULE_CAMEL=$BASE_DIR/system/layers/bpms/org/apache/camel
MODULE_COMMONS_MATH=$BASE_DIR/system/layers/bpms/org/apache/commons/math
MODULE_HELIX=$BASE_DIR/system/layers/bpms/org/apache/helix
MODULE_LUCENE=$BASE_DIR/system/layers/bpms/org/apache/lucene
MODULE_JGIT=$BASE_DIR/system/layers/bpms/org/eclipse/jgit
MODULE_ZOOKEEPER=$BASE_DIR/system/layers/bpms/org/apache/zookeeper
# create modules 3rd party * drools
MODULE_AETHER=$BASE_DIR/system/layers/bpms/org/sonatype/aether 
MODULE_ANT=$BASE_DIR/system/layers/bpms/org/apache/ant 
MODULE_MAVEN=$BASE_DIR/system/layers/bpms/org/apache/maven
MODULE_WAGON=$BASE_DIR/system/layers/bpms/org/apache/maven/wagon
MODULE_MVEL=$BASE_DIR/system/layers/bpms/org/mvel 
MODULE_sonPLEXUS=$BASE_DIR/system/layers/bpms/org/sonatype/plexus 
MODULE_codePLEXUS=$BASE_DIR/system/layers/bpms/org/codehouse/plexus 
MODULE_POI=$BASE_DIR/system/layers/bpms/org/apache/poi 
MODULE_PROTOBUF=$BASE_DIR/system/layers/bpms/com/google/protobuf 
MODULE_SISU=$BASE_DIR/system/layers/bpms/org/sonatype/sisu
MODULE_sonaMAVEN=$BASE_DIR/system/layers/bpms/org/sonatype/maven
# create modules 3rd party * jbpm
MODULE_COMPRESS=$BASE_DIR/system/layers/bpms/org/apache/commons/compress
MODULE_EXEC=$BASE_DIR/system/layers/bpms/org/apache/commons/exec
MODULE_NET=$BASE_DIR/system/layers/bpms/org/apache/commons/net
MODULE_VFS=$BASE_DIR/system/layers/bpms/org/apache/commons/vfs
MODULE_SOLDER=$BASE_DIR/system/layers/bpms/org/jboss/solder

rm -rf $BASE_DIR/system

# Create structure
mkdir  -p $MODULE_LIB/main
mkdir  -p $MODULE_KIE/main
mkdir  -p $MODULE_JBPM/main
mkdir  -p $MODULE_DROOLS/main
mkdir  -p $MODULE_CAMEL/main
mkdir  -p $MODULE_COMMONS_MATH/main
mkdir  -p $MODULE_HELIX/main
mkdir  -p $MODULE_LUCENE/main
mkdir  -p $MODULE_JGIT/main
mkdir  -p $MODULE_ZOOKEEPER/main
mkdir  -p $MODULE_AETHER/main
mkdir  -p $MODULE_ANT/main
mkdir  -p $MODULE_MAVEN/main
mkdir  -p $MODULE_MVEL/main
mkdir  -p $MODULE_sonPLEXUS/main
mkdir  -p $MODULE_codePLEXUS/main
mkdir  -p $MODULE_POI/main
mkdir  -p $MODULE_PROTOBUF/main 
mkdir  -p $MODULE_SISU/main
mkdir  -p $MODULE_sonaMAVEN/main
mkdir  -p $MODULE_WAGON/main
mkdir  -p $MODULE_COMPRESS/main
mkdir  -p $MODULE_EXEC/main
mkdir  -p $MODULE_NET/main
mkdir  -p $MODULE_VFS/main
mkdir  -p $MODULE_SOLDER/main



#
# Unzip original kie-wb
#
rm -rf kie-wb
mkdir kie-wb
cd kie-wb
jar xvf ../kie-wb.war
cd ..


#
# Clean unrequired libs
#

rm $BASE_DIR/kie-wb/WEB-INF/lib/jsp-api*.jar
echo $BASEDIR"/kie-wb/WEB-INF/lib/jsp-api*.jar deleted"
rm $BASE_DIR/kie-wb/WEB-INF/lib/commons-bean*.jar
echo $BASE_DIR"/kie-wb/WEB-INF/lib/commons-bean*.jar deleted"
rm $BASE_DIR/kie-wb/WEB-INF/lib/commons-logging*.jar
echo $BASE_DIR"/kie-wb/WEB-INF/lib/commons-logging*.jar deleted"
rm $BASE_DIR/kie-wb/WEB-INF/lib/jaxb*.jar
echo $BASE_DIR"/kie-wb/WEB-INF/lib/jaxb*.jar deleted"
rm $BASE_DIR/kie-wb/WEB-INF/lib/jaxrs-api-*.jar
echo $BASE_DIR"/kie-wb/WEB-INF/lib/jaxrs-api-*.jar deleted"
rm $BASE_DIR/kie-wb/WEB-INF/lib/jboss-intercepto*.jar
echo $BASE_DIR"/kie-wb/WEB-INF/lib/jboss-intercepto*.jar deleted"
rm $BASE_DIR/kie-wb/WEB-INF/lib/jta*.jar
echo $BASE_DIR"/kie-wb/WEB-INF/lib/jta*.jar deleted"
rm $BASE_DIR/kie-wb/WEB-INF/lib/log4j*.jar
echo $BASE_DIR"/kie-wb/WEB-INF/lib/log4j*.jar deleted"
rm $BASE_DIR/kie-wb/WEB-INF/lib/xmlschema-core*.jar
echo $BASE_DIR"/kie-wb/WEB-INF/lib/xmlschema-core*.jar deleted"
rm $BASE_DIR/kie-wb/WEB-INF/lib/stax-api*.jar
echo $BASE_DIR"/kie-wb/WEB-INF/lib/stax-api*.jar deleted"
## Duplicated!!!
rm $BASE_DIR/kie-wb/WEB-INF/lib/freemarker-2.3.8.jar
echo $BASE_DIR"/kie-wb/WEB-INF/lib/freemarker-2.3.8.jar deleted"


# ------------------------------------------------------------------------------------------
# Move jars around
# ------------------------------------------------------------------------------------------

mv $BASE_DIR/kie-wb/WEB-INF/lib/*.jar $MODULE_LIB/main

# KIE WORKBENCH (WEB-INF/lib)
mv $MODULE_LIB/main/kie-wb*.jar            $BASE_DIR/kie-wb/WEB-INF/lib
mv $MODULE_LIB/main/drools-wb*.jar         $BASE_DIR/kie-wb/WEB-INF/lib
mv $MODULE_LIB/main/drools-workbench*.jar  $BASE_DIR/kie-wb/WEB-INF/lib
mv $MODULE_LIB/main/jbpm-console*.jar      $BASE_DIR/kie-wb/WEB-INF/lib
mv $MODULE_LIB/main/jbpm-designer*.jar     $BASE_DIR/kie-wb/WEB-INF/lib
mv $MODULE_LIB/main/jbpm-form-modeler*.jar $BASE_DIR/kie-wb/WEB-INF/lib
mv $MODULE_LIB/main/uberfire-*.jar         $BASE_DIR/kie-wb/WEB-INF/lib
mv $MODULE_LIB/main/guvnor-*.jar           $BASE_DIR/kie-wb/WEB-INF/lib
mv $MODULE_LIB/main/errai-*.jar            $BASE_DIR/kie-wb/WEB-INF/lib
mv $MODULE_LIB/main/taglib*.jar            $BASE_DIR/kie-wb/WEB-INF/lib


# Override non aligned deps by using 
#mv $MODULE_LIB/main/commons-codec-*.jar    $BASE_DIR/kie-wb/WEB-INF/lib


# KIE / JBPM / DROOLS
mv $MODULE_LIB/main/kie-*.jar              $MODULE_KIE/main
mv $MODULE_LIB/main/kieora*.jar            $MODULE_KIE/main
mv $MODULE_LIB/main/jbpm-*.jar             $MODULE_JBPM/main
mv $MODULE_LIB/main/drools-*.jar           $MODULE_DROOLS/main

# new modules KIE dependencies

mv $MODULE_LIB/main/camel-core-*.jar               $MODULE_CAMEL/main
mv $MODULE_LIB/main/camel-josql-*.jar              $MODULE_CAMEL/main
mv $MODULE_LIB/main/commons-math-*.jar             $MODULE_COMMONS_MATH/main
mv $MODULE_LIB/main/helix-core-*-incubating.jar    $MODULE_HELIX/main
mv $MODULE_LIB/main/lucene-analyzers-common-*.jar  $MODULE_LUCENE/main
mv $MODULE_LIB/main/lucene-codecs-*.jar            $MODULE_LUCENE/main
mv $MODULE_LIB/main/lucene-core-*.jar              $MODULE_LUCENE/main
mv $MODULE_LIB/main/lucene-queries-*.jar           $MODULE_LUCENE/main
mv $MODULE_LIB/main/lucene-queryparser-*.jar       $MODULE_LUCENE/main
mv $MODULE_LIB/main/lucene-sandbox-*.jar           $MODULE_LUCENE/main
mv $MODULE_LIB/main/org.eclipse.jgit-*.jar         $MODULE_JGIT/main
mv $MODULE_LIB/main/zookeeper-*.jar                $MODULE_ZOOKEEPER/main

# new modules DROOLS dependencies

mv $MODULE_LIB/main/aether-api-1.13.1.jar             $MODULE_AETHER/main
mv $MODULE_LIB/main/aether-connector-file-1.13.1.jar  $MODULE_AETHER/main
mv $MODULE_LIB/main/aether-connector-wagon-1.13.1.jar $MODULE_AETHER/main
mv $MODULE_LIB/main/aether-impl-1.13.1.jar            $MODULE_AETHER/main
mv $MODULE_LIB/main/aether-spi-1.13.1.jar             $MODULE_AETHER/main
mv $MODULE_LIB/main/aether-util-1.13.1.jar            $MODULE_AETHER/main
mv $MODULE_LIB/main/ant-1.8.2.jar                     $MODULE_ANT/main
mv $MODULE_LIB/main/ant-launcher-1.8.2.jar            $MODULE_ANT/main
mv $MODULE_LIB/main/maven-aether-provider-3.0.3.jar   $MODULE_MAVEN/main
mv $MODULE_LIB/main/maven-artifact-3.0.3.jar          $MODULE_MAVEN/main
mv $MODULE_LIB/main/maven-compat-3.0.3.jar            $MODULE_MAVEN/main
mv $MODULE_LIB/main/maven-core-3.0.3.jar              $MODULE_MAVEN/main  
mv $MODULE_LIB/main/maven-model-3.0.3.jar             $MODULE_MAVEN/main   
mv $MODULE_LIB/main/maven-model-builder-3.0.3.jar     $MODULE_MAVEN/main
mv $MODULE_LIB/main/maven-plugin-api-3.0.3.jar        $MODULE_MAVEN/main 
mv $MODULE_LIB/main/maven-repository-metadata-3.0.3.jar $MODULE_MAVEN/main
mv $MODULE_LIB/main/maven-settings-3.0.3.jar          $MODULE_MAVEN/main
mv $MODULE_LIB/main/maven-settings-builder-3.0.3.jar  $MODULE_MAVEN/main
mv $MODULE_LIB/main/mvel2-2.1.6.Final.jar             $MODULE_MVEL/main
mv $MODULE_LIB/main/plexus-cipher-1.4.jar             $MODULE_sonPLEXUS/main
mv $MODULE_LIB/main/plexus-classworlds-2.4.jar        $MODULE_codePLEXUS/main
mv $MODULE_LIB/main/plexus-component-annotations-1.5.5.jar $MODULE_codePLEXUS/main
mv $MODULE_LIB/main/plexus-interpolation-1.14.jar     $MODULE_codePLEXUS/main
mv $MODULE_LIB/main/plexus-utils-3.0.7.jar            $MODULE_codePLEXUS/main
mv $MODULE_LIB/main/poi-3.9.jar                       $MODULE_POI/main 
mv $MODULE_LIB/main/poi-ooxml-3.9.jar                 $MODULE_POI/main
mv $MODULE_LIB/main/poi-ooxml-schemas-3.9.jar         $MODULE_POI/main 
mv $MODULE_LIB/main/protobuf-java-2.5.0.jar           $MODULE_PROTOBUF/main
mv $MODULE_LIB/main/sisu-guice-3.0.3-no_aop.jar       $MODULE_SISU/main
mv $MODULE_LIB/main/sisu-inject-bean-2.2.3.jar        $MODULE_SISU/main
mv $MODULE_LIB/main/wagon-provider-api-1.0.jar        $MODULE_WAGON/main
mv $MODULE_LIB/main/wagon-ahc-1.2.1.jar               $MODULE_sonaMAVEN/main

# new modules JBPM dependencies

mv $MODULE_LIB/main/commons-compress-1.0.jar          $MODULE_COMPRESS/main
mv $MODULE_LIB/main/commons-exec-1.0.1.jar            $MODULE_EXEC/main
mv $MODULE_LIB/main/commons-net-2.0.jar               $MODULE_NET/main
mv $MODULE_LIB/main/commons-vfs-1.0.jar               $MODULE_VFS/main
mv $MODULE_LIB/main/sisu-inject-plexus-2.2.3.jar      $MODULE_SISU/main
mv $MODULE_LIB/main/solder-api-3.2.0.Final.jar        $MODULE_SOLDER/main
mv $MODULE_LIB/main/solder-impl-3.2.0.Final.jar       $MODULE_SOLDER/main 
mv $MODULE_LIB/main/solder-logging-3.2.0.Final.jar    $MODULE_SOLDER/main


# ------------------------------------------------------------------------------------------
# Generate modules.xml
# ------------------------------------------------------------------------------------------

# 
# Generate library module for lib
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_LIB/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org.kie.lib">' >> $MODULE_LIB/main/module.xml
echo "  <resources>" >> $MODULE_LIB/main/module.xml
find $MODULE_LIB/main/*.jar -type f -printf '    <resource-root path="%f"/>\n' >> $MODULE_LIB/main/module.xml
echo "  </resources>">> $MODULE_LIB/main/module.xml
echo "  <dependencies>">> $MODULE_LIB/main/module.xml
cat  ./eap-deps.list >> $MODULE_LIB/main/module.xml
echo "  </dependencies>">> $MODULE_LIB/main/module.xml
echo "</module>">> $MODULE_LIB/main/module.xml


#
# Generate library module for kie
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_KIE/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org.kie">' >> $MODULE_KIE/main/module.xml
echo "  <resources>" >> $MODULE_KIE/main/module.xml
find $MODULE_KIE/main/*.jar -type f -printf '    <resource-root path="%f"/>\n' >> $MODULE_KIE/main/module.xml
echo "  </resources>">> $MODULE_KIE/main/module.xml
echo "  <dependencies>">> $MODULE_KIE/main/module.xml
echo '    <module name="org.kie.lib" export="true"/>'>> $MODULE_KIE/main/module.xml
echo '    <module name="org.jbpm"    export="true"/>'>> $MODULE_KIE/main/module.xml
echo '    <module name="org.drools"  export="true"/>'>> $MODULE_KIE/main/module.xml
cat kie.dependencies  >> $MODULE_KIE/main/module.xml
echo >> $MODULE_KIE/main/module.xml
echo "  </dependencies>">> $MODULE_KIE/main/module.xml
echo "</module>">> $MODULE_KIE/main/module.xml


#
# Generate library module for drools
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_DROOLS/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org.drools">' >> $MODULE_DROOLS/main/module.xml
echo "  <resources>" >> $MODULE_DROOLS/main/module.xml
find $MODULE_DROOLS/main/*.jar -type f -printf '    <resource-root path="%f"/>\n' >> $MODULE_DROOLS/main/module.xml
echo "  </resources>">> $MODULE_DROOLS/main/module.xml
echo "  <dependencies>">> $MODULE_DROOLS/main/module.xml
echo '    <module name="org.kie.lib" export="true"/>'>> $MODULE_DROOLS/main/module.xml
echo '    <module name="org.kie" export="true"/>'>> $MODULE_DROOLS/main/module.xml
echo '    <module name="org.hibernate" export="true"/>'>> $MODULE_DROOLS/main/module.xml
echo '    <module name="org.javassist" export="true"/>'>> $MODULE_DROOLS/main/module.xml
cat drools.dependencies  >> $MODULE_DROOLS/main/module.xml
echo >> $MODULE_DROOLS/main/module.xml
echo "  </dependencies>">> $MODULE_DROOLS/main/module.xml
echo "</module>">> $MODULE_DROOLS/main/module.xml


#
# Generate library module for jbpm
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_JBPM/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org.jbpm">' >> $MODULE_JBPM/main/module.xml
echo "  <resources>" >> $MODULE_JBPM/main/module.xml
find $MODULE_JBPM/main/*.jar -type f -printf '    <resource-root path="%f"/>\n' >> $MODULE_JBPM/main/module.xml
echo "  </resources>">> $MODULE_JBPM/main/module.xml
echo "  <dependencies>">> $MODULE_JBPM/main/module.xml
echo '    <module name="org.kie.lib" export="true"/>'>> $MODULE_JBPM/main/module.xml
echo '    <module name="org.drools" export="true"/>'>> $MODULE_JBPM/main/module.xml
echo '    <module name="org.hibernate" export="true"/>'>> $MODULE_JBPM/main/module.xml
echo '    <module name="org.javassist" export="true"/>'>> $MODULE_JBPM/main/module.xml
echo '    <module name="org.jboss.weld.api" export="true"/>'>> $MODULE_JBPM/main/module.xml
echo '    <module name="javax.persistence.api" export="true"/>'>> $MODULE_JBPM/main/module.xml
echo '    <module name="org.jboss.weld.core" export="true" />' >> $MODULE_JBPM/main/module.xml 
echo '    <module name="org.jboss.weld.spi" export="true" />' >> $MODULE_JBPM/main/module.xml
cat jbpm.dependencies  >> $MODULE_JBPM/main/module.xml
echo >> $MODULE_JBPM/main/module.xml
echo "  </dependencies>">> $MODULE_JBPM/main/module.xml
echo "</module>">> $MODULE_JBPM/main/module.xml


#
# Generate library module for camel
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_CAMEL/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org.apache.camel">' >> $MODULE_CAMEL/main/module.xml
echo "  <resources>" >> $MODULE_CAMEL/main/module.xml
find $MODULE_CAMEL/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_CAMEL/main/module.xml
echo "  </resources>">> $MODULE_CAMEL/main/module.xml
echo "</module>">> $MODULE_CAMEL/main/module.xml


#
# Generate library module for commons-math
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_COMMONS_MATH/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/apache/commons/math">' >> $MODULE_COMMONS_MATH/main/module.xml
echo "  <resources>" >> $MODULE_COMMONS_MATH/main/module.xml
find $MODULE_COMMONS_MATH/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_COMMONS_MATH/main/module.xml
echo "  </resources>">> $MODULE_COMMONS_MATH/main/module.xml
echo "</module>">> $MODULE_COMMONS_MATH/main/module.xml


#
# Generate library module for helix
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_HELIX/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/apache/helix">' >> $MODULE_HELIX/main/module.xml
echo "  <resources>" >> $MODULE_HELIX/main/module.xml
find $MODULE_HELIX/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_HELIX/main/module.xml
echo "  </resources>">> $MODULE_HELIX/main/module.xml
echo "</module>">> $MODULE_HELIX/main/module.xml


#
# Generate library module for lucene
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_LUCENE/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/apache/lucene">' >> $MODULE_LUCENE/main/module.xml
echo "  <resources>" >> $MODULE_LUCENE/main/module.xml
find $MODULE_LUCENE/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_LUCENE/main/module.xml
echo "  </resources>">> $MODULE_LUCENE/main/module.xml
echo "</module>">> $MODULE_LUCENE/main/module.xml


#
# Generate library module for jgit
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_JGIT/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/eclipse/jgit">' >> $MODULE_JGIT/main/module.xml
echo "  <resources>" >> $MODULE_JGIT/main/module.xml
find $MODULE_JGIT/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_JGIT/main/module.xml
echo "  </resources>">> $MODULE_JGIT/main/module.xml
echo "</module>">> $MODULE_JGIT/main/module.xml


#
# Generate library module for wagon
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_WAGON/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/apache/maven/wagon">' >> $MODULE_WAGON/main/module.xml
echo "  <resources>" >> $MODULE_WAGON/main/module.xml
find $MODULE_WAGON/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_WAGON/main/module.xml
echo "  </resources>">> $MODULE_WAGON/main/module.xml
echo "</module>">> $MODULE_WAGON/main/module.xml

#
# Generate library module for zookeeper
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_ZOOKEEPER/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/apache/zookeeper">' >> $MODULE_ZOOKEEPER/main/module.xml
echo "  <resources>" >> $MODULE_ZOOKEEPER/main/module.xml
find $MODULE_ZOOKEEPER/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_ZOOKEEPER/main/module.xml
echo "  </resources>">> $MODULE_ZOOKEEPER/main/module.xml
echo "</module>">> $MODULE_ZOOKEEPER/main/module.xml


#
# Generate library module for aether
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_AETHER/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org.sonatype.aether">' >> $MODULE_AETHER/main/module.xml
echo "  <resources>" >> $MODULE_AETHER/main/module.xml
find $MODULE_AETHER/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_AETHER/main/module.xml
echo "  </resources>">> $MODULE_AETHER/main/module.xml
echo "</module>">> $MODULE_AETHER/main/module.xml


#
# Generate library module for ant
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_ANT/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/apache/ant">' >> $MODULE_ANT/main/module.xml
echo "  <resources>" >> $MODULE_ANT/main/module.xml
find $MODULE_ANT/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_ANT/main/module.xml
echo "  </resources>">> $MODULE_ANT/main/module.xml
echo "</module>">> $MODULE_ANT/main/module.xml


#
# Generate library module for maven
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_MAVEN/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org.apache.maven">' >> $MODULE_MAVEN/main/module.xml
echo "  <resources>" >> $MODULE_MAVEN/main/module.xml
find $MODULE_MAVEN/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_MAVEN/main/module.xml
echo "  </resources>">> $MODULE_MAVEN/main/module.xml
echo "</module>">> $MODULE_MAVEN/main/module.xml


#
# Generate library module for mvel
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_MVEL/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/mvel">' >> $MODULE_MVEL/main/module.xml
echo "  <resources>" >> $MODULE_MVEL/main/module.xml
find $MODULE_MVEL/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_MVEL/main/module.xml
echo "  </resources>">> $MODULE_MVEL/main/module.xml
echo "</module>">> $MODULE_MVEL/main/module.xml


#
# Generate library module for sonatype/plexus
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_sonPLEXUS/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/sonatype/plexus">' >> $MODULE_sonPLEXUS/main/module.xml
echo "  <resources>" >> $MODULE_sonPLEXUS/main/module.xml
find $MODULE_sonPLEXUS/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_sonPLEXUS/main/module.xml
echo "  </resources>">> $MODULE_sonPLEXUS/main/module.xml
echo "</module>">> $MODULE_sonPLEXUS/main/module.xml


#
# Generate library module for codehouse/plexus
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_codePLEXUS/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/codehouse/plexus">' >> $MODULE_codePLEXUS/main/module.xml
echo "  <resources>" >> $MODULE_codePLEXUS/main/module.xml
find $MODULE_codePLEXUS/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_codePLEXUS/main/module.xml
echo "  </resources>">> $MODULE_codePLEXUS/main/module.xml
echo "</module>">> $MODULE_codePLEXUS/main/module.xml


#
# Generate library module for poi
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_POI/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/apache/poi">' >> $MODULE_POI/main/module.xml
echo "  <resources>" >> $MODULE_POI/main/module.xml
find $MODULE_POI/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_POI/main/module.xml
echo "  </resources>">> $MODULE_POI/main/module.xml
echo "</module>">> $MODULE_POI/main/module.xml


#
# Generate library module for protobuf
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_PROTOBUF/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="com.google.protobuf">' >> $MODULE_PROTOBUF/main/module.xml
echo "  <resources>" >> $MODULE_PROTOBUF/main/module.xml
find $MODULE_PROTOBUF/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_PROTOBUF/main/module.xml
echo "  </resources>">> $MODULE_PROTOBUF/main/module.xml
echo "</module>">> $MODULE_PROTOBUF/main/module.xml


#
# Generate library module for sisu
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_SISU/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/sonatype/sisu">' >> $MODULE_SISU/main/module.xml
echo "  <resources>" >> $MODULE_SISU/main/module.xml
find $MODULE_SISU/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_SISU/main/module.xml
echo "  </resources>">> $MODULE_SISU/main/module.xml
echo "</module>">> $MODULE_SISU/main/module.xml


#
# Generate library module for sonatype/maven
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_sonaMAVEN/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/sonatype/maven">' >> $MODULE_sonaMAVEN/main/module.xml
echo "  <resources>" >> $MODULE_sonaMAVEN/main/module.xml
find $MODULE_sonaMAVEN/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_sonaMAVEN/main/module.xml
echo "  </resources>">> $MODULE_sonaMAVEN/main/module.xml
echo "</module>">> $MODULE_sonaMAVEN/main/module.xml


#
# Generate library module for compress
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_COMPRESS/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/apache/commons/compress">' >> $MODULE_COMPRESS/main/module.xml
echo "  <resources>" >> $MODULE_COMPRESS/main/module.xml
find $MODULE_COMPRESS/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_COMPRESS/main/module.xml
echo "  </resources>">> $MODULE_COMPRESS/main/module.xml
echo "</module>">> $MODULE_COMPRESS/main/module.xml


#
# Generate library module for exec
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_EXEC/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/apache/commons/exec">' >> $MODULE_EXEC/main/module.xml
echo "  <resources>" >> $MODULE_EXEC/main/module.xml
find $MODULE_EXEC/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_EXEC/main/module.xml
echo "  </resources>">> $MODULE_EXEC/main/module.xml
echo "</module>">> $MODULE_EXEC/main/module.xml


#
# Generate library module for net
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_NET/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/apache/commons/net">' >> $MODULE_NET/main/module.xml
echo "  <resources>" >> $MODULE_NET/main/module.xml
find $MODULE_NET/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_NET/main/module.xml
echo "  </resources>">> $MODULE_NET/main/module.xml
echo "</module>">> $MODULE_NET/main/module.xml


#
# Generate library module for vfs
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_VFS/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/apache/commons/vfs">' >> $MODULE_VFS/main/module.xml
echo "  <resources>" >> $MODULE_VFS/main/module.xml
find $MODULE_VFS/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_VFS/main/module.xml
echo "  </resources>">> $MODULE_VFS/main/module.xml
echo "</module>">> $MODULE_VFS/main/module.xml


#
# Generate library module for solder
#
echo '<?xml version="1.0" encoding="UTF-8"?>' > $MODULE_SOLDER/main/module.xml
echo '<module xmlns="urn:jboss:module:1.0" name="org/jboss/solder">' >> $MODULE_SOLDER/main/module.xml
echo "  <resources>" >> $MODULE_SOLDER/main/module.xml
find $MODULE_SOLDER/main/*.jar -type f -printf '      <resource-root path="%f"/>\n' >> $MODULE_SOLDER/main/module.xml
echo "  </resources>">> $MODULE_SOLDER/main/module.xml
echo "</module>">> $MODULE_SOLDER/main/module.xml


echo -n "Prepared for copy? (Hit control-c if is not): "
read ok

# ------------------------------------------------------------------------------------------
# Deploy on EAP
# ------------------------------------------------------------------------------------------
echo 'Deploying layer on EAP 6.1 at $DEPLOY_DIR....'

rm -rf $DEPLOY_DIR/system/layers/bpms
echo $DEPLOY_DIR"/system/layers/bpms removed"

cp -R  $BASE_DIR/system $DEPLOY_DIR
echo $DEPLOY_DIR"/system copied to "$DEPLOY_DIR

cp layers.conf $DEPLOY_DIR

echo -n "Are the modules copied? (Hit control-c if is not): "
read ok

#
# Create new WAR with dependencies to created modules
echo 'Generating new WAR....'
cd $BASE_DIR/kie-wb

cp $BASE_DIR/jboss-deployment-structure.xml $BASE_DIR/kie-wb/WEB-INF

jar cvf $BASE_DIR/kie-wb-modules.war *

#
# Workaround until solder problem is solved
#

mkdir $BASE_DIR/kie-wb/META-INF/services

cp $BASE_DIR/workaroundSolderFiles/javax.enterprise.inject.spi.Extension $BASE_DIR/kie-wb/META-INF/services
cp $BASE_DIR/workaroundSolderFiles/org.jboss.solder.beanManager.BeanManagerProvider $BASE_DIR/kie-wb/META-INF/services
cp $BASE_DIR/workaroundSolderFiles/org.jboss.solder.config.xml.bootstrap.XmlDocumentProvider $BASE_DIR/kie-wb/META-INF/services
cp $BASE_DIR/workaroundSolderFiles/org.jboss.solder.resourceLoader.ResourceLoader $BASE_DIR/kie-wb/META-INF/services
cp $BASE_DIR/workaroundSolderFiles/org.jboss.solder.servlet.resource.WebResourceLocationProvider $BASE_DIR/kie-wb/META-INF/services
cp $BASE_DIR/workaroundSolderFiles/org.jboss.solder.servlet.webxml.WebXmlLocator $BASE_DIR/kie-wb/META-INF/services



jar cvf $BASE_DIR/kie-wb-modules.war *

# 
# Deploy WAR on EAP 6.1
#
cp $BASE_DIR/kie-wb-modules.war $EAP_DIR/standalone/deployments/kie-wb.war




