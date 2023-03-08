# Bash scripts

My Bash scripts.

<!-- MarkdownTOC -->

- [lorem-ipsum](#lorem-ipsum)
- [download-and-verify-archives](#download-and-verify-archives)

<!-- /MarkdownTOC -->

## lorem-ipsum

Lorem ipsum generator. Prints Lorem ipsum text to `./lorem-ipsum.txt` specified number of times:

``` sh
$ ./lorem-ipsum.sh -n 999
```

## download-and-verify-archives

Downloads archives from links provided in a file using `cURL` and verifies their contents against "blueprints" (*text files with contents expected to be inside each archive*) using `diff`:

``` sh
$ ./download-and-verify-archives.sh -t "ACCESS-TOKEN-HERE"
```
