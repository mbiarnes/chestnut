//Define Variables

def kieVersion="master"
def javadk="jdk1.8"
def jaydekay="JDK1_8"
def mvnToolEnv="APACHE_MAVEN_3_3_9"
def mvnVersion="apache-maven-3.3.9"
def mvnHome="${mvnToolEnv}_HOME"
def mvnOpts="-Xms2g -Xmx3g"
def kieMainBranch="master"
def organization="kiegroup"


def createReleaseBranches="""
sh \$WORKSPACE/droolsjbpm-build-bootstrap/script/release/kie-createReleaseBranches.sh
"""

// **************************************************************************

job("mbiarnes-test-by-dsl") {

    description("test test test")

    scm {
        git {
            remote {
                github("${organization}/droolsjbpm-build-bootstrap")
            }
            branch ("${kieMainBranch}")
            extensions {
                relativeTargetDirectory("droolsjbpm-build-bootstrap")
                localBranch {
                   localBranch("${kieMainBranch}")
                } 
            }
        }
    }
    label("kie-releases")

    logRotator {
        numToKeep(10)
    }

    jdk("${javadk}")

    wrappers {
        timestamps()
        colorizeOutput()
        toolenv("${mvnToolEnv}", "${jaydekay}")
        preBuildCleanup()
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
        shell(createReleaseBranches)
    }
}
