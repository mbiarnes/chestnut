def date = new Date().format( 'yyyyMMdd-hhMMss' )
def kieVersionPre = "7.7.0."
def appformerVersionPre = "2.4.0."
def erraiVersionNewPre = "4.2.0."
def sourceProductTag = ""
def targetProductBuild = ""

return [kieVersion:kieVersionPre + date, appformerVersion:appformerVersionPre + date, erraiVersionNew:erraiVersionNewPre +date,  cutOffDate:date, reportDate:date,  sourceProductTag:sourceProductTag, targetProductBuild:targetProductBuild]  

