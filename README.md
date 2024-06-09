## Bash scripts

My Bash scripts.

<!-- MarkdownTOC -->

- [lorem-ipsum](#lorem-ipsum)
- [download-and-verify-archives](#download-and-verify-archives)
- [temporary-file](#temporary-file)
- [copy-files-with-rclone](#copy-files-with-rclone)

<!-- /MarkdownTOC -->

### lorem-ipsum

Lorem ipsum generator. Prints Lorem ipsum text to `./lorem-ipsum.txt` specified number of times:

``` sh
$ ./lorem-ipsum.sh -n 999
```

### download-and-verify-archives

Downloads archives from links provided in a file using `cURL` and verifies their contents against "blueprints" (*text files with contents expected to be inside each archive*) using `diff`:

``` sh
$ ./download-and-verify-archives.sh -t "ACCESS-TOKEN-HERE"
```

### temporary-file

Based on <https://stackoverflow.com/a/66070270/1688203>.

Creates a temporary file, performs some checks and sets a trap for deleting it afterwards:

``` sh
$ ./temporary-file.sh
$ less ./some.log
```

This is supposed to be used as a part of actual scripts for "batched" logging, when several process might be writing to the same log file, so you'd need to ensure that their logs rows are not mixed together.

### copy-files-with-rclone

Copies files with [rclone](https://rclone.org) from a remote server on cron schedule:

``` sh
$ mkdir ~/scripts ~/logs

$ crontab -e
```
``` sh
20 * * * * ~/scripts/copy-files-with-rclone.sh >> ~/logs/copy-files-with-rclone.log 2>&1
```
