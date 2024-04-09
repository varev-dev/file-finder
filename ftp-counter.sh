#!bin/bash
grep "OK DOWNLOAD" cdlinux.ftp.log |
    cut -d'"' -f 2,4 |
    sort -u |
    awk -F'"' '{print $NF}' |
    rev |
    cut -d'/' -f 1 |
    rev |
    grep "\.iso" |
    sort | 
    uniq -c 