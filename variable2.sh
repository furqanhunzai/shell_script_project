#!/usr/bin/env bash
set -e

declare -a servers=("server1" "server2" "server3")


#servers=( "${servers[@]:1:3}" "server1.15" )

echo "${servers[@]}"

 #remiving specfic array
 unset servers[2]
 
 echo updated version is : "${servers[@]}"
 
 unset servers
 
 echo removing all elements : "${servers[@]}"

#adding new elements eaisly

servers+=("server4" "server5" "server6")

 echo new elements : "${servers[@]}"
