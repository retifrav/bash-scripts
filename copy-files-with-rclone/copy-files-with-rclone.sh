#!/bin/bash

echo '---'
echo ''

echo "[$(date '+%Y-%m-%d %H:%M:%S')] started"
echo ''

username='vasya'

PATH="/local/path/to/home/$username/.local/bin:$PATH"

someServerPath="someServer:/remote/path/to/somewhere"
localPath="/local/path/to/elsewhere/output-vulcan-flares"

lockingFile="/local/path/to/home/$username/scripts/copy-vulcan-output.working"
if [[ -f "$lockingFile" ]]; then
    echo "Looks like previous run hasn't finished yet, because $lockingFile still exists"
    echo ''
else
    # set the lock
    touch "$lockingFile"

    echo 'Files in vulcan-flares-first (listing only *.vul):'
    rclone lsf "${someServerPath}/vulcan-flares-first/output" --include "*.vul"
    echo '- copying...'
    rclone copy "${someServerPath}/vulcan-flares-first/output" --include "*.vul" "${localPath}/output-first" --dry-run

    echo 'Files in vulcan-flares-second (listing only *.vul):'
    rclone lsf "${someServerPath}/vulcan-flares-second/output" --include "*.vul"
    echo '- copying...'
    rclone copy "${someServerPath}/vulcan-flares-second/output" --include "*.vul" "${localPath}/output-second" --dry-run

    # remove the lock
    rm "$lockingFile"
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] finished"
echo ''
