#!/bin/bash

git_url="https://github.com/jcroyoaun/kodekloud-lab-sample-nodejs/blob/master/app.js"


raw_url_step1="${git_url/github.com/raw.githubusercontent.com}"

printf "\n"

echo "${raw_url_step1}"
printf "\n \n"

echo "prefix remove start here and we are left with suffix"
suffix="${raw_url_step1##*blob/}"
echo "${suffix}"

printf "\n \n"
echo "suffix remove start here and we are left with prefix"

printf "\n"

prefix="${raw_url_step1%%blob*}"
echo "${prefix}"

exit 0





