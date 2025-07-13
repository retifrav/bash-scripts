## Bash scripts

My Bash scripts.

<!-- MarkdownTOC -->

- [lorem-ipsum](#lorem-ipsum)
- [download-and-verify-archives](#download-and-verify-archives)
- [temporary-file](#temporary-file)
- [copy-files-with-rclone](#copy-files-with-rclone)
- [generate-dependencies-list-from-vcpkg](#generate-dependencies-list-from-vcpkg)
- [control-raspberry-pi-desktop-with-tv-remote-via-cec](#control-raspberry-pi-desktop-with-tv-remote-via-cec)

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

Don't forget to remove `--dry-run` from `copy` commands.

### generate-dependencies-list-from-vcpkg

Generates a text file with a lazy list of dependencies collected from listings in `vcpkg_installed/vcpkg/info/` folder:

``` sh
ls -L1 /path/to/some/project/build/vcpkg_installed/vcpkg/info/ | head -5
assimp_5.3.1_myvr-arm64-osx.list
brotli_1.1.0_myvr-arm64-osx.list
catch2_3.5.3_myvr-arm64-osx.list
clara_1.1.5_myvr-arm64-osx.list
cpp-base64_2.0.8_myvr-arm64-osx.list

$ ./generate-dependencies-list-from-vcpkg.sh -p /path/to/some/project/build/vcpkg_installed/vcpkg/info/

$ head -5 ./3rd-party.txt
assimp_5.3.1
brotli_1.1.0
catch2_3.5.3
clara_1.1.5
cpp-base64_2.0.8
```

### control-raspberry-pi-desktop-with-tv-remote-via-cec

Controlling Raspberry Pi desktop with TV remote via CEC, more details [here](https://github.com/retifrav/bash-scripts/blob/master/control-raspberry-pi-desktop-with-tv-remote-via-cec/README.md).
