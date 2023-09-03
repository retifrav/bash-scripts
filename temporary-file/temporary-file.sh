#!/bin/bash

tmpfile=$(mktemp)

[ "$?" -eq 0 ] ||
{
    printf "[ERROR] mktemp returned non-zero exit code\n" >&2
    exit 1
}

[ -f "$tmpfile" ] ||
{
    printf "[ERROR] temporary file does not exist\n" >&2
    exit 2
}

# set trap to remove temporary file on termination, interrupt or exit
trap 'rm -f "$tmpfile"' SIGTERM SIGINT EXIT

# do the stuff, such as write some operations status/output here and then write
# the whole file contents into an actual log, so it's all logged in together as one batch

# here we just put some text into it
cat > "$tmpfile" << eof

---

The temporary file was successfully created at $tmpfile

It will be removed by a trap function when this script is terminated, interrupted or just exits
eof

# something else happening here

cat >> "$tmpfile" << eof

Some more content
eof

# and then finally write everything collected in the temporary file to the actual log
cat "$tmpfile" >> ./some.log
