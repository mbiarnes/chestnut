//Define Variables

def kieMainBranch="master"
def zanataVersion="7.8.0"
def settingsXml="3a44127e-aa4e-4002-b244-35bdb78bc4af"

def organization="kiegroup"
def javaVersion="kie-jdk1.8"
def javaToolEnv="KIE_JDK1_8"
def mvnToolEnv="KIE_MAVEN_3_5_0"
def mvnHome="${mvnToolEnv}_HOME"
def mvnOpts="-Xms2g -Xmx3g"
def m2Dir="/home/jenkins/.m2"

// creation of folder
folder("KIE")
folder("KIE/Zanata")

def folderPath="KIE/Zanata"

def zanataPullModules="""
sh \$WORKSPACE/scripts/droolsjbpm-build-bootstrap/script/zanata/zanata-pullModules.sh
"""

job("${folderPath}/zanataPullModules-${zanataVersion}") {

    description("This job: <br> pushes the i18n files to https://vendors.zanata.redhat.com<br>IMPORTANT: Created automatically by Jenkins job DSL plugin. Do not edit manually! The changes will get lost next time the job is generated.")

    parameters {
        stringParam("kieMainBranch", "${kieMainBranch}", "please edit the name of the release branch <br> ******************************************************** <br> ")
    };

    scm {
        git {
            remote {
                github("${organization}/droolsjbpm-build-bootstrap")
            }
            branch ("${kieMainBranch}")
            extensions {
                relativeTargetDirectory("scripts/droolsjbpm-build-bootstrap")
            }

        }
    }

    label("kie-releases")

    logRotator {
        numToKeep(10)
    }

    jdk("${javaVersion}")

    wrappers {
        timeout {
            absolute(60)
        }
        timestamps()
        preBuildCleanup()
        colorizeOutput()
        toolenv("${mvnToolEnv}", "${javaToolEnv}")
        configFiles {
            mavenSettings("${settingsXml}") {
                variable("ZANATA")
            }
        }
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

    publishers {
        mailer('mbiarnes@redhat.com', false, false)
    }

    steps {
        environmentVariables {
            envs(MAVEN_OPTS : "${mvnOpts}", MAVEN_HOME : "\$${mvnHome}", MAVEN_REPO_LOCAL : "${m2Dir}", PATH : "\$${mvnHome}/bin:\$PATH")
        }
        shell(zanataPullModules)
    }
}
