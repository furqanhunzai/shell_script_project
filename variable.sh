#!/usr/bin/env bash
set -e

declare -a servers=("server1" "server2" "server3")

servers=( "${servers[@]:0:1}" "server1.15" "${servers[@]:1}" )

echo "${servers[@]}"
