RELEASING
=========
Table of content
----------------

* **[Introduction](#introduction)**
* **[Pre release actions](#pre-release-actions)**
    * **[Zanata pulls](#zanata-pulls)**
        * **[pull-Zanata-translation-changes-\<branch\>](#zanata-pulls)**
        * **[push-Zanata-translation-changes-\<branch\>](#zanata-pulls)**
    * **[012.Releasing_Uberfire_Ubefire-extensions_remove-release-branches-\<branch\>](#remove-old-branches)**
    * **[022.Releasing_Dashbuilder_remove-release-branches](#remove-old-branches)**
    * **[034.Releasing_KIE_remove-release-branches-\<branch\>](#remove-old-branches)**
    * **[update JIRA to th next release](#close-relese-on-jira)**
    * **[mail to the bsig team about the upcoming release](#mail_to_bsig)**
    
* **[Uberfire, Uberfire-extensions, dasbhuilder "internal" releases](#uf_dash_releases)**
    * **[010.Releasing_Uberfire_Uberfire-extensions_deploy-\<branch\>](#010)**
    * **[020.Releasing_Dashbuilder_deploy](#020)**
                    
* **[KIE releases](#kie_releases)**
    * **[030.Releasing_KIE_push-branches-\<branch\>](#030)**
    * **[031.Releasing_KIE_deploy_locally-\<branch\>](#031)**
    * **[cherry-picks](#cherry-picking)**
    * **[032.Releasing_KIE_copy_deployed_directory_to_Nexus-\<branch\>](#032)**
        * *[032a.Releasing_KIE_kie_all_jbpm_test_coverage-\<branch\>](#032a)*
        * *[032b.Releasing_KIE_kie-all-kie-api-backwards-compat-check-\<branch\>](#032b)*
        * *[032c.Releasing_KIE_kie-all-kie-server-matrix-\<branch\>](#032c)*
        * *[032d.Releasing_KIE_kie-all-kie-wb-smoke-tests-matrix-\<branch\>](#032d)*
        
* **[post-release actions](#post-release)**
    * **[Push tags to droolsjbpm/jboss-integration](#push_tags)**
        * *[011.Releasing_Uberfire_Uberfire-extensions_push-tag-\<branch\>](#011)*
        * *[021.Releasing_Dashbuilder_push-tag](#021)*
        * *[033.Releasing_KIE_push-tags-\<branch\>](#033)*
    
    * **[Updating to next development version](#next_development_version)**
        * *[013.Releasing_Uberfire_Uberfire-extensions_update-next-development-version-\<branch\>](#013)*
        * *[023.Releasing_Dashbuilder_update-next-development-version](#023)*
        * *[035.Releasing_KIE_update-next-develop-version-\<branch\>](#035)*

        
        
Introduction
============
Historically the releases for droolsjbpm (kie) were done manually following this document [README](https://github.com/droolsjbpm/droolsjbpm-build-bootstrap/blob/master/RELEASE-README.md).<br>
Nowerdays kie team use the [Jenkins CI](https://kie-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/) with all its views and scripts to release.<br>
When kie-team has to do a release it has two main reasons:

* a realease + tag for community (i.e. 6.4.0.Final) based on an community branch or a community tag + some cherry-picks
* a tag for productization (i.e. sync-6.4.x-2016.04.21) based on a community branch, a community tag or previous product tag + some cherry-picks

All this possibilities are covered with the different scripts.

The main views for releasing in Jenkins CI are:

* **[Zanata](https://kie-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/view/Zanata/)**
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


   

    


 


