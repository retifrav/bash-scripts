#!/bin/bash

archivesLinksFile="archive-links.txt"
docsLink="http://wiki.your.host/archive-contents-verification"

verificationPath="./_verification"

accessToken="[unknown]"

while getopts ":t:v:" opt; do
  case $opt in
    t) accessToken="$OPTARG"
    ;;
    v) verificationPath="$OPTARG"
    ;;
    \?)
        echo "Unknown option -$OPTARG" >&2
        exit 1
    ;;
  esac
done

if [[ "$accessToken" == "[unknown]" ]]; then
    echo "You need to provide an access token (-t) value" >&2
    exit 2
fi

[ -d $verificationPath ] || mkdir $verificationPath

cat $archivesLinksFile | while read link || [[ -n $link ]];
do
    archiveName=$(basename "$link")
    testName="Verifying archive ${archiveName}"
    echo "##teamcity[testStarted name='$testName']"
    echo "Downloading ${link}..."
    downloadStatus=$(curl -s -H "Authorization: Bearer $accessToken" --write-out "%{http_code}" -o $archiveName $link)
    if [ $downloadStatus != 200 ]; then
        echo "Downloading the archive failed. Status code: $downloadStatus" >&2
        echo "##teamcity[testFailed name='$testName']"
        rm $archiveName
    else
        archiveListing=${archiveName%.*}.txt
        archiveListingBlueprint=${archiveName%.*}-blueprint.txt
        unzip -Z1 $archiveName | sort > $archiveListing
        echo "Verifying archive content..."
        diff -U0 --strip-trailing-cr $archiveListing <(cat ./artifacts-blueprints/$archiveListingBlueprint | sort) \
            && {
                echo "OK"
                rm $archiveListing
            } \
            || {
                echo "Archive content verification FAILED. If you need to update the blueprint, read about it here: ${docsLink}"
                echo "##teamcity[testFailed name='$testName']"
                mv $archiveListing $verificationPath/
            }
    fi
    echo "##teamcity[testFinished name='$testName']"
done
