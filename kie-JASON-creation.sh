#!/bin/bash -e


# creates a file (list) of the last commit hash of each repository as handover for production
./droolsjbpm-build-bootstrap/script/git-all.sh log -1 --pretty=oneline >> git-commit-hashes.txt
echo $kieVersion > $WORKSPACE/version.txt
# creates JSON file for prod
# resultant sed extraction files
./droolsjbpm-build-bootstrap/script/git-all.sh log -1 --format=%H  >> sedExtraction_1.txt
sed -e '1d;2d' -e '/Total/d' -e '/====/d' -e 's/Repository: //g' -e 's/^/"/; s/$/"/;' -e '/""/d' sedExtraction_1.txt >> sedExtraction_2.txt
sed -e '0~2 a\' sedExtraction_2.txt >> sedExtraction_3.txt
sed -e '1~2 s/$/,/g' sedExtraction_3.txt >> sedExtraction_4.txt
sed -e '1~2 s/^/"repo": /' sedExtraction_4.txt >> sedExtraction_5.txt
sed -e '2~2 s/^/"commit": /' sedExtraction_5.txt >> sedExtraction_6.txt
sed -e '0~2 s/$/\n },{/g' sedExtraction_6.txt >> sedExtraction_7.txt
sed -e '$d' sedExtraction_7.txt >> sedExtraction_8.txt
cat sedExtraction_8.txt
cutOffDate=$(date +"%m-%d-%Y %H:%M")
reportDate=$(date +"%m-%d-%Y")
fileToWrite=$reportDate.json
commitHash=$(cat sedExtraction_8.txt)
cat <<EOF > int.json
{
   "handover" : {
   "cut_off_date" : "$cutOffDate",
   "report_date": "$reportDate",
   "repos" : [
      {
         $commitHash
      }
    ],
   "source_product_tag":"$sourceProductTag",
   "target_product_build":"$targetProductBuild"
   }
}
EOF
# indent json
python -m json.tool int.json >> $fileToWrite
# remove sed extraction and int files
rm sedExtraction*
rm int.json