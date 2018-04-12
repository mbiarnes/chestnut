// definition of kie build  script
def kieUploadToNexus='''#!/bin/bash -e

# where are repos 
deployDir=$WORKSPACE/deploy-dir

# uploads the content to remote staging repo
mvn -B -e org.sonatype.plugins:nexus-staging-maven-plugin:1.6.8:deploy-staged-repository -DnexusUrl=https://repository.jboss.org/nexus -DserverId=jboss-releases-repository\
 -DrepositoryDirectory=$deployDir -s $SETTINGS_XML_FILE -DstagingProfileId=15c3321d12936e -DstagingDescription="kie $kieVersion" -DkeepStagingRepositoryOnCloseRuleFailure=true\
 -DstagingProgressTimeoutMinutes=80
'''

job("kieUploadToNexus-${kieMainBranch}") {
    description("uploads binaries to Nexus")

    parameters{
        stringParam("kieMainBranch", "kieMainBranch", "Branch of build. This will be usually set automatically by the parent trigger job. ")
        stringParam("kieVersion", "kie version", "Version of kie. This will be usually set automatically by the parent trigger job. ")
    }

    label("linux&&rhel7&&mem24g")

    logRotator {
        numToKeep(10)
    }

    jdk("${javadk}")

    wrappers {
        timeout {
            absolute(80)
        }
        timestamps()
        colorizeOutput()
        toolenv("${mvnToolEnv}", "${jaydekay}")
        configFiles {
            mavenSettings("org.jenkinsci.plugins.configfiles.maven.MavenSettingsConfig1434468480404"){
                variable("SETTINGS_XML_FILE")
            }
        }
    }

    customWorkspace("\$HOME/workspace/kieAllBuild-${kieMainBranch}")

    publishers {
        mailer('mbiarnes@redhat.com', false, false)
    }

    configure { project ->
        project / 'buildWrappers' << 'org.jenkinsci.plugins.proccleaner.PreBuildCleanup' {
            cleaner(class: 'org.jenkinsci.plugins.proccleaner.PsCleaner') {
                killerType 'org.jenkinsci.plugins.proccleaner.PsAllKiller'
                killer(class: 'org.jenkinsci.plugins.proccleaner.PsAllKiller')
                username 'jenkins'
            }
        }
    }

    steps {
        environmentVariables {
            envs(MAVEN_OPTS : "${mvnOpts}", MAVEN_HOME : "\$${mvnHome}", MAVEN_REPO_LOCAL : "/home/jenkins/.m2/repository", PATH : "\$${mvnHome}/bin:\$PATH")
        }
        shell(kieUploadToNexus)
    }
}
