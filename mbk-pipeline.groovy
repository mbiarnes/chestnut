pipeline {
    agent any
    
    stages {
        stage('parameter') {
            steps {
                script {
                    date = new Date().format('yyyyMMdd-hhMMss')
                    kieVersion = "${kieVersion}.${date}"
                    appformerVersion = "${appformerVersion}.${date}"
                    erraiVersionNew = "${erraiVersionNew}.${date}"
                    sourceProductTag = ""
                    targetProductBuild = ""
                    
                    echo "kieVersion: ${kieVersion}"
                    echo "appformerVersion: ${appformerVersion}"
                    echo "erraiVersionOld: ${erraiVersionOld}"
                    echo "erraiVersionNew: ${erraiVersionNew}"
                    echo "kieMainBranch: ${kieMainBranch}"
                    echo "erraiBranch: ${erraiBranch}"
                    echo "organization: ${organization}"
                    echo "sourceProductTag: ${sourceProductTag}"
                    echo "targetProductBuild: ${targetProductBuild}"
                }
            }
        }
        
        stage("start errai build for 7.5.x") {
            steps {
                build job: "errai-kieAllBuild-${kieMainBranch}", parameters: [[$class: 'StringParameterValue', name: 'erraiVersionOld', value: erraiVersionOld],
                [$class: 'StringParameterValue', name: 'erraiVersionNew', value: erraiVersionNew],[$class: 'StringParameterValue', name: 'erraiBranch', value: erraiBranch]]                    
            }
        }
        
        stage('start kieAllBuild for 7.5.x') {
            steps {
                build job: "kieAllBuild-${kieMainBranch}", parameters: [[$class: 'StringParameterValue', name: 'kieVersion', value: kieVersion],
                [$class: 'StringParameterValue', name: 'erraiVersionNew', value: erraiVersionNew],[$class: 'StringParameterValue', name: 'appformerVersion', value: appformerVersion],
                [$class: 'StringParameterValue', name: 'kieMainBranch', value: kieMainBranch]]                    
            }
        }
        
        stage('additional tests for 7.5.x') {
            steps {
                parallel (
                    "jbpmTestCoverageMatrix" : {
                        build job: "jbpmTestCoverageMatrix-${kieMainBranch}", parameters: [$class: 'StringParameterValue', name: 'kieVersion', value: kieVersion]
                    },
                    "jbpmTestContainerMatrix" : {
                        build job: "jbpmTestContainerMatrix-${kieMainBranch}", parameters: [$class: 'StringParameterValue', name: 'kieVersion', value: kieVersion]
                    },
                    "kieWbTestsMatrix" : {
                        build job: "kieWbTestsMatrix-${kieMainBranch}", parameters: [$class: 'StringParameterValue', name: 'kieVersion', value: kieVersion]
                    },
                    "kieServerMatrix" : {
                        build job: "kieServerMatrix-${kieMainBranch}", parameters: [$class: 'StringParameterValue', name: 'kieVersion', value: kieVersion]
                    },
                    "kie-docker-ci-images" : {
                        build job: "kie-docker-ci-images-${kieMainBranch}", parameters: [$class: 'StringParameterValue', name: 'kieVersion', value: kieVersion]
                    }
                )    
            }
        }    
    }
}
