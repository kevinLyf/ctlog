#!/bin/bash

config_file="config.txt"

if [ -f "$config_file" ]; then
  source "$config_file"
fi

if [ -z "$folder_path" ] || [ -z "$folder_name" ]; then
  echo "folder_path and folder_name are required, the config.txt needs the folder_path and folder_name"
  exit 1
fi

if [ ! -d "$folder_path" ]; then
  echo "Invalid folder_path"
  exit 1
fi

if [ ! -d "$folder_name" ]; then
  mkdir -p "$folder_path/$folder_name"
  echo "$folder_name was sucessfully created"
fi

if [[ "$1" == "-f" ]]; then
  shift
  while getopts ":f:" opt; do
    case $opt in
      f)
        old_folder_name="$folder_name"
        folder_name="$OPTARG"

        if [ -d "$folder_path/$folder_name" ]; then
          echo "$folder_name already exists"
          exit 1
        fi

        sed -i "s/^folder_name=.*/folder_name=\"$folder_name\"/" config.txt

        if mv "$folder_path/$old_folder_name" "$folder_name"; then
          echo "$old_folder_name has been successfully renamed to $folder_name"
          exit 1
        else
          echo "An error occurred while renaming the folder"
          exit 1
        fi
        ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
      :)
        echo "The option -$OPTARG required a argument" >&2
        exit 1
        ;;
    esac
  done
else
  if [ -f "$folder_path/$folder_name/${flag_name}${current_number}.txt" ]; then
    echo "$flag_name already exists"
    ((current_number++))  # Incremento de current_number
    sed -i "s/current_number=$((current_number-1))/current_number=$current_number/" "$config_file"
    exit 1
  fi

  if [ -n "$1" ]; then
    touch "$folder_path/$folder_name/${flag_name}${current_number}.txt"
    echo "$1" >> "$folder_path/$folder_name/${flag_name}${current_number}.txt"
    echo "Flag successfully created"
    ((current_number++))  # Incremento de current_number
    sed -i "s/current_number=$((current_number-1))/current_number=$current_number/" "$config_file"
  fi

fi


