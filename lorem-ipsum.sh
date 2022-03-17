#!/bin/bash

howManyTimes=10

while getopts ":n:" opt; do
  case $opt in
    n)
        howManyTimes="$OPTARG"
        ;;
    \?)
        echo "Unknown option -$OPTARG" >&2
        exit 1
        ;;
  esac
done

[ -n "$howManyTimes" ] && [ "$howManyTimes" -eq "$howManyTimes" ] 2>/dev/null
if [ $? -ne 0 ]; then
   echo "$howManyTimes is not number"
   exit 1
fi

loremIpsum="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

for ((i=0; i<=$howManyTimes; i++))
do
   printf "$loremIpsum\n\n" >> ./lorem-ipsum.txt
done

printf "TEH END\n" >> ./lorem-ipsum.txt
