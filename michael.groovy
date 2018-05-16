//Define Variables

def kieVersion="master"
def javadk="jdk1.8"
def jaydekay="JDK1_8"
def mvnToolEnv="APACHE_MAVEN_3_3_9"
def mvnVersion="apache-maven-3.3.9"
def mvnHome="${mvnToolEnv}_HOME"
def mvnOpts="-Xms2g -Xmx3g"
def mainBranch="master"
def organization="mbiarnes"
def mainRepo="chestnut"
def tag="kunnigunde"
def baseBranch="master"    
def releaseBranch="r8.8.0.Final"
def uberfireVersion="2.4.1"
def releaseVersion="8.8.0.Final"

def createReleaseBranches="""
sh \$WORKSPACE/chestnut/releasing-KIE--push-release-branches.sh
"""

// **************************************************************************

job("mbiarnes-test-by-dsl") {

    description("test test test")
    parameters{
        stringParam("tag", "${tag}", "This will be usually set automatically by the parent trigger job. ")
        stringParam("uberfireVersion", "${uberfireVersion}", "This will be usually set automatically by the parent trigger job. ")
        stringParam("releaseVersion", "${releaseVersion}", "This will be usually set automatically by the parent trigger job. ")
        stringParam("releaseBranch", "${releaseBranch}", "This will be usually set automatically by the parent trigger job. ")
        stringParam("baseBranch", "${baseBranch}", "This will be usually set automatically by the parent trigger job. ")
   }
    scm {
        git {
            remote {
                github("${organization}/${mainRepo}")
            }
            branch ("${kieMainBranch}")
            extensions {
                relativeTargetDirectory("${mainRepo}")
                localBranch {
                   localBranch("${mainBranch}")
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
