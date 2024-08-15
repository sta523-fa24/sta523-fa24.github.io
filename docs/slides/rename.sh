#!/bin/bash

# Get a list of files in the current directory containing a two-digit number
files=$(ls *[0-9][0-9]* 2>/dev/null)

# Check if there are any matching files
if [ -z "$files" ]; then
    echo "No files found."
    exit 1
fi

# Sort the files by their numeric part in descending order
sorted_files=$(echo "$files" | sort -t 'c' -k 1.4nr)

# Rename the files by incrementing the number
count=1
for file in $sorted_files; do
    # Extract the numeric part from the filename
    number=$(echo "$file" | grep -o '[0-9][0-9]')
    new_number=$((number + 1))  # Increment the number
    new_name=$(echo "$file" | sed "s/$number/$new_number/")
    mv "$file" "$new_name"
    echo "Renamed $file to $new_name"
    ((count++))
done
