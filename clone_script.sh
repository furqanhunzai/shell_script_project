#!/bin/bash

######################################
# This script takes a Git repository URL as the first argument and a branch name as the second
#Clones the repository
#Counts and prints the total number of files in the project directory
#
#
####################################


project="${1}"

branch="${2}"

project_dir="$(basename ${project} .git)"

clone_project() {

  if [ ! -d "$HOME/Documents/devops/shell/${project_dir}" ]; then
   cd "$HOME/Documents/devops/shell" || exit 1

   git clone ${project}
  fi
}

git_checkout() {
  cd "${project_dir}"
  git checkout "${branch}"

}




find_files() {
  find . -type f | wc -l
}
clone_project
git_checkout
find_files



