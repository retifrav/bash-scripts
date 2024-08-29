#!/bin/bash

vcpkgInfoPath=""
ignoringRegEx=""

while getopts ":p:r:" opt; do
  case $opt in
    p) vcpkgInfoPath="$OPTARG"
    ;;
    r) ignoringRegEx="$OPTARG"
    ;;
    \?)
        echo "Unknown option -$OPTARG" >&2
        exit 1
    ;;
  esac
done

if [ -z "$vcpkgInfoPath" ]; then
    echo "[ERROR] You need to provide path to the vcpkg info folder (-p)"
    exit 2
fi

if [ -z $ignoringRegEx ]; then
    ignoringRegEx="^(some-|vcpkg-)"
fi

for i in $vcpkgInfoPath/*; do
    d=$(basename $i | sed 's/_[^_]*\.list$//')
    if [[ $d =~ $ignoringRegEx ]];
    then
        echo "Ignoring $d..."
    else
        echo $d >> ./3rd-party.txt
    fi
done

sort --unique ./3rd-party.txt -o ./3rd-party.txt
