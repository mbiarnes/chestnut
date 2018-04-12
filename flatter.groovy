def erraiVersionOld = params["erraiVersionOld"]
def kieMainBranch =params["kieMainBranch"]
def erraiBranch=params["erraiBranch"]
def organization=params["organization"]

erraiVersionNew = build.environment.get("erraiVersionNew")
appformerVersion = build.environment.get("appformerVersion")
kieVersion = build.environment.get("kieVersion")

ignore(UNSTABLE) {
    build("errai-kieAllBuild-${kieMainBranch}", erraiVersionNew: "$erraiVersionNew", erraiVersionOld: "$erraiVersionOld", erraiBranch: "$erraiBranch")
}
ignore(UNSTABLE) {
    build("kieAllBuild-${kieMainBranch}", kieVersion: "$kieVersion", appformerVersion: "$appformerVersion", erraiVersionNew: "$erraiVersionNew", kieMainBranch: "$kieMainBranch")
}


parallel (
        {
            build("jbpmTestCoverageMatrix-kieAllBuild-${kieMainBranch}", kieVersion: "$kieVersion")
        },
        {
            build("jbpmTestContainerMatrix-kieAllBuild-${kieMainBranch}", kieVersion: "$kieVersion")
        },
        {
            build("kieWbTestsMatrix-kieAllBuild-${kieMainBranch}", kieVersion: "$kieVersion")
        },
        {
            build("kieServerMatrix-kieAllBuild-${kieMainBranch}", kieVersion: "$kieVersion")
        },
                {
            build("kie-docker-ci-images-${kieMainBranch}", kieVersion: "$kieVersion")
        }
)
