RELEASING
=========
Table of content
----------------

* **[Introduction](#introduction)**
* **[Pre release actions](#pre-release-actions)**
    * **[Zanata pulls](#zanata-pulls)**
        * **[Pull Zanata translation changes](#zanata-pulls)**
        * **[Push Zanata translation changes](#zanata-pulls)**
    * **[Remove old Uberfire & Ubefire-extensions release branches](#remove-old-branches)**
    * **[Remove old Dashbuilder release branches](#remove-old-branches)**
    * **[Remove old KIE release branches](#remove-old-branches)**
    * **[Close release on JIRA](#close-release-on-jira)**
    * **[Mail to the bsig team](#mail-to-bsig-team)**
    
* **[Releasing third party repositories](#releasing-third-party-repositories)**
    * **[Releasing_Uberfire & Uberfire-extensions](#releasing-uberfire-uberfire-extensions)**
    * **[Releasing_Dashbuilder](#releasing-dashbuilder)**
                    
* **[KIE releases](#kie-releases)**
    * **[Push KIE release branches](#push-kie-release-branch)**
    * **[Deploy locally KIE release artifacts](#deploy-locally-kie)**
    * **[Cherry-picking](#cherry-picking)**
    * **[Copy deployed KIE binaries to Nexus](#copy-deployed-kie-to-nexus)**
        * *[jbpm_test_coverage](#jbpm-test-coverage)*
        * *[kie-api-backwards-compat-check](#kie-api-backwards-compatible-check)*
        * *[kie-server-matrix](#kie-server-martix)*
        * *[kie-wb-smoke-tests-matrix](#kie-workbench-smoke-tests-matrix)*
        
* **[post-release actions](#post-release-actions)**
    * **[Push tags to droolsjbpm/jboss-integration](#push-tags)**
        * *[Push Uberfire & Uberfire-extensions tag](#push-uberfire-tag)*
        * *[Push Dashbuilder tag](#push-dashbuilder-tag)*
        * *[Push KIE tags](#push-kie-tags)*
    * **[Release repositories on Nexus](#release-repositories-on-nexus)**
    * **[Updating to next development version](#update-to-next-development-version)**
        * *[Update Uberfire & Uberfire-extensions](#update-uberfire)*
        * *[Update Dashbuilder](#update-dashbuilder)*
        * *[Update KIE ](#update-kie)*

        
        
Introduction
============
Historically the releases for droolsjbpm (kie) were done manually following this document [README](https://github.com/droolsjbpm/droolsjbpm-build-bootstrap/blob/master/RELEASE-README.md).<br>
Nowerdays kie team use the [Jenkins CI](https://kie-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/) with all its views and scripts to release.<br>
When kie-team has to do a release it has two main reasons:

* a realease + tag for community (i.e. 6.4.0.Final) based on an community branch or a community tag + some cherry-picks
* a tag for productization (i.e. sync-6.4.x-2016.04.21) based on a community branch, a community tag or previous product tag + some cherry-picks

All this possibilities are covered with the different scripts.

The main views for releasing in Jenkins CI are:

* **[Zanata](https://kie-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/view/Zanata)**
* **[uf-releases-0.7.x](https://kie-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/view/uf-releases-0.7.x)**
* **[uf-releases-0.8.x](https://kie-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/view/uf-releases-0.8.x)**
* **[dashbuilder-releases](https://kie-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/view/dashbuilder-releases/)**
* **[kie-releases-6.3.x](https://kie-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/view/kie-releases-6.3.x/)**
* **[kie-releases-6.4.x](https://kie-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/view/kie-releases-6.4.x/)**

In future time there will be created new views and old views, that no longer are supported will dissapear.<br>
Right now (April 2016) the master branch of droolsjbpm is 7.0.0-SNAPSHOT. There will be created a new 7.0.x branch soon and so created a new view and new scripts on Jenkins, also 
it will be removed some day the 6.2.x view.


Pre release actions
===================
Before releasing kie we have first to pull latest Zanata translation changes from Zanata server and remove temporary branches used for previous releases for Uberfire, Uberfire-extensions, dashbuilder and
and kie.
Zanata pulls
------------
There are two main scripts for pushing or pulling Zanata modules. *pull-Zanata-translation-changes-\<branch\>* and *push-Zanata-translation-changes-\<branch\>* available on the view 
[Zanata](https://kie-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/view/Zanata/) of Jenkins CI.<br>
**push-Zanata-translation-changes-\<branch\>** pushes the new words in i18n files for beeing translated from droolsjbpm to Zanata-server.<br>
**pull-Zanata-translation-changes-\<branch\>** is executed before a release (+/-two days).<br>
What this script does is basically:

    mvn -B zanata:pull-module (pulls all Zanata trabslations from Zanata server)
    mvn replacer:replace -N (replaces basically apostrophe "'" by double apostrophe "''" - needed in french translations)
    mvn native2ascii=native2ascii (only in repositories where this is needed)
    git adds and commits (if there are changes)
    raises a PR (pull request) to the repositories on github

The main repositories affected by Zanata changes are:

    uberfire
    uberire-extensions
    dashbuilder
    kie-uberfire-extensions
    guvnor
    kie-wb-common
    jbpm_form_modeler
    drools-wb
    jbpm-designer
    cd jbpm-designer-api
    jbpm-console-ng
    dashboard-builder
    optaplanner-wb
    jbpm-dashboard
    kie-wb-distributions
    
Remove old branches
-------------------
Before pushing new "release" branches to github/jboss-integration is is important to remove old branches from previous builds to avoid collencting these temporally branches.<br>
Therefore there are three scripts to remove this branches.<br>

**012.Releasing_Uberfire_Ubefire-extensions_remove-release-branches-\<branch\>** \[removes uberfire and uberfire-extensions branches\]<br>
**022.Releasing_Dashbuilder_remove-release-branches** \[removes dashbuilder branches\]<br>
**034.Releasing_KIE_remove-release-branches-\<branch\>** \[removes kie branches\]<br>
All scripts have this parameters when building (Build with parameters):

    the user has to select if it is a community (droolsjbpm) or a product (jboss-integration) branch
    the exact branch name has to be edited here 
        (r\<tag name\> for community i.e r6.4.0.Final)
        (bsync-\<branch\>-yyyy.mm.dd for productization  i.e. bsync-6.4.x-2016.04.21)

Close release on JIRA
---------------------
When a community release is upcoming there is a time period where people don't push anymore to the branch that serves as base for the release. In this time period developers
can continue i.e working on JIRAs. When they select the version they can assign it to the recent version whereas this version is already building. So these JIRAs will be assigned to the recent
version but will not be in this release. Therefore it is good to close the release on JIRA **without** a date, so all not yet fixed JIRAs will be migrated to the next version.<br>
Once the release is done the date will be edited.<br>
**<font color="red">IMPORTANT</font>:** this only is required for community releases!

Mail to bsig team
-----------------
Before starting the release procedure (two days before) it is important to altert the team about this.
When releasing for community a mail to <font color="blue">bsig@redhat.com</font> or <font color="blue">bsig-all@redhat.com</font> should be send announcing the new release.
 
    EXAMPLE MAIL:
    Next week on Tuesday, 5th of April, we are going to branch the 6.4.x
    for releasing the community 6.4.0.CR3.
    It is supposed that we have the tag for it on Tuesday EOD so we can
    do the prod tag 6.3.0.ER3 on Wednesday.
    I hope you will have everything prepared for Tuesday.
    Have in mind that we still can cherry-pick something that has to be
    in the CR3. The same procedure as every time, a mail to me and in CC Edson and Kris with
    the commits to cherry pick.

It is important that everyone who could not finish his task until the announced day should send a mail to the release engineer (<font color="blue">mbiarnes@redhat.com</font>) and to Edson (<font color="blue">etirelli@redhat.com</font>) 
and Kris (<font color="blue">kverlaen@redhat.com</font>).<br>
There can also be changed the subject on the XChat to inform the team about the status of the release.

Releasing third party repositories
==================================
Once all steps specified in this doc until here are closed and before beginning to release the KIE repositories,<br>
Uberfire<br>
Uberfire-extenbsions (only versions 0.7.x and 0.8.x)<br>
and Dashbuilder<br>
have to be released.
 

Releasing Uberfire-Uberfire-extensions
--------------------------------------
For Uberfire and Uberfire-extensions there exist different views on [Jenkins CI](https://kie-jenkins.rhev-ci-vms.eng.rdu2.redhat.com) depending on the branch we want to release:

0.7.x : [uf-releases-0.7.x](https://kie-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/view/uf-releases-0.7.x)<br>
0.8.x : [uf-releases-0.8.x](https://kie-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/view/uf-releases-0.8.x)<br>
master : [uf-releases-master](https://kie-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/view/uf-releases-master)<br>

Each view has different jobs, for releasing this job should be run:<br><br>
**010.Releasing_Uberfire_Uberfire-extensions_deploy_\<branch\>**<br>

Basically this job<br>
- clones the repository<br>
- creates a release branch<br>
- changes version on this release branch<br>
- builds & deploys the repository locally<br>
- uploads the binaries to Nexus<br><br>
- pushes this release branches to droolsjbpm (community) or jboss-integration (product)<br>

This job is named *`010.Releasing_Uberfire_Uberfire-extensions_deploy_<branch>`* for 0.7.x and 0.8.x, for master it is named *`010.Releasing_Uberfire_deploy-master`*.<br>

This job runs parametrized.<br><br>
**TARGET**: community or productized<br>
**RELEASE_BRANCH**: name of the release branch that should be created<br>
**oldVersion**: the version the module has before changing the version (only available in 0.7.x and 0.8.x)<br>
**newVersion**: the version the poms will be upgraded to after the version change<br>
In job *`010.Releasing_Uberfire_deploy-master`* the parameter **`oldVersion`** was removed.

Releasing Dashbuilder
---------------------
1<br>
2<br>
3<br>

KIE releases
=============
1<br>
2<br>
3<br>

Push KIE release branches
-------------------------
1<br>
2<br>
3<br>

Deploy locally kie
------------------
1<br>
2<br>
3<br>

Cherry-picking
--------------
1<br>
2<br>
3<br>

Copy deployed KIE binaries to Nexus
-----------------------------------
1<br>
2<br>
3<br>

Additional test coverage
------------------------
1<br>
2<br>
3<br>

jbpm-test-coverage
------------------
1<br>
2<br>
3<br>

kie api backwards compatible check
----------------------------------
1<br>
2<br>
3<br>

KIE server martix
-----------------
1<br>
2<br>
3<br>

KIE workbench smoke tests matrix
--------------------------------
1<br>
2<br>
3<br>

Post release actions
====================
1<br>
2<br>
3<br>

Push tags
---------
1<br>
2<br>
3<br>

Push Uberfire tag
-----------------
1<br>
2<br>
3<br>

Push Dashbuilder tag
--------------------
1<br>
2<br>
3<br>

Push KIE tags
-------------
1<br>
2<br>
3<br>

Release repositories on Nexus
-----------------------------
1<br>
2<br>
3<br>

Update to next development version
---------------------------------
1<br>
2<br>
3<br>

Update Uberfire
--------------
1<br>
2<br>
3<br>

Update Dashbuilder
-----------------
1<br>
2<br>
3<br>

Update KIE
----------
1<br>
2<br>
3<br>
  


 


