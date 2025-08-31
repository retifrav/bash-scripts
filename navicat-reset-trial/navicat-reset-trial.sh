#!/bin/bash

# https://appstorrent.ru/802-navicat-premium.html#findcomment158332

NAVICAT_FOLDER=~/Library/Application\ Support/PremiumSoft\ CyberTech/Navicat\ CC/Navicat\ Premium

# check if the Navicat folder exists before deleting it
if [ -d "$NAVICAT_FOLDER" ]; then
    echo 'Found Navicat folder, deleting it'
    rm -rf "$NAVICAT_FOLDER"
else
    echo 'Navicat folder not found'
    return 1
fi

# find the Navicat preferences file
NAVICAT_FILENAME=$(ls -d ~/Library/Preferences/* | grep -i navicat)

# check if the preferences file exists before using it
if [ -f "$NAVICAT_FILENAME" ]; then
    echo "Found the preferences file: $NAVICAT_FILENAME"
    TRIAL_KEY=$(plutil -p "$NAVICAT_FILENAME" | grep -E "[0-9A-F]{32,32}" | head -n 1 | awk '{print $1}' | tr -d \")

    # check if the TRIAL_KEY is not empty before removing it
    if [ -n "$TRIAL_KEY" ]; then
        echo "Got the trial key: $TRIAL_KEY"
        plutil -remove "$TRIAL_KEY" "$NAVICAT_FILENAME" > /dev/null
    else
        echo 'Trial key not found'
        return 1
    fi
else
    echo 'Navicat preferences file not found'
    return 1
fi
