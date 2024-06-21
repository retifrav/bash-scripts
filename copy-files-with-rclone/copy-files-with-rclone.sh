#!/bin/bash

echo '---'
echo ''

echo "[$(date '+%Y-%m-%d %H:%M:%S')] started"
echo ''

username='vasya'

PATH="/local/path/to/home/$username/.local/bin:$PATH"

someServerPath="someServer:/remote/path/to/somewhere"
localPath="/local/path/to/elsewhere/output-vulcan-flares"

noNewFilesMsg='there are no new *.vul files, nothing to copy'

lockingFile="/local/path/to/home/$username/scripts/copy-vulcan-output.working"
if [[ -f "$lockingFile" ]]; then
    echo "Looks like previous run hasn't finished yet, because $lockingFile still exists"
    echo ''
else
    # set the lock
    touch "$lockingFile"

    echo 'Files in vulcan-flares-first (listing only *.vul):'
    rclone lsf "${someServerPath}/vulcan-flares-first/output" --include "*.vul"
    echo '- checking...'
    rclone check "${someServerPath}/vulcan-flares-first/output" --include "*.vul" "${localPath}/output-first" --one-way
    if [ $? -eq 0 ]; then
        echo "- ${noNewFilesMsg}"
    else
        echo '- copying...'
        rclone copy "${someServerPath}/vulcan-flares-first/output" --include "*.vul" "${localPath}/output-first" --dry-run
    fi

    echo ''

    echo 'Files in vulcan-flares-second (listing only *.vul):'
    rclone lsf "${someServerPath}/vulcan-flares-second/output" --include "*.vul"
    echo '- checking...'
    rclone check "${someServerPath}/vulcan-flares-second/output" --include "*.vul" "${localPath}/output-second" --one-way
    if [ $? -eq 0 ]; then
        echo "- ${noNewFilesMsg}"
    else
        echo '- copying...'
        rclone copy "${someServerPath}/vulcan-flares-second/output" --include "*.vul" "${localPath}/output-second" --dry-run
    fi

    # remove the lock
    rm "$lockingFile"
fi

echo ''
echo "[$(date '+%Y-%m-%d %H:%M:%S')] finished"
echo ''
