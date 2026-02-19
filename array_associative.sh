#!/bin/bash
declare -A phonebook
# Populate the phonebook
phonebook=(
  ["Fire Department"]="555-0001"
  ["Police Department"]="555-0002"
  ["Hospital"]="555-0003"
)
while read -p "Enter the department name (or 'stop' to exit): " department; do
  if [[ "${department}" == "stop" ]]; then
    break
  fi
  if [[ ! -n "${phonebook[${department}]}" ]]; then
      echo "No phone number found for ${department}."
  fi
  echo "Phone number for ${department}: ${phonebook[${department}]}"
done
