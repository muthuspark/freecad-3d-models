#!/bin/bash

# Set the maximum file size (in bytes)
MAX_FILE_SIZE=$((100 * 1024 * 1024))  # 100 MB

# Get a list of large files in the repository
large_files=$(git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -n 10 | awk '{print$1}')")

# Loop through the large files and remove them
for file in $large_files; do
    file_size=$(git cat-file -s $file)
    if [ $file_size -gt $MAX_FILE_SIZE ]; then
        echo "Removing file: $file (size: $file_size bytes)"
        git rm --cached $file
    fi
done

# Commit the changes
git commit -m "Remove large files from Git history"

# Push the changes
git push
