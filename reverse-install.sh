#!/bin/bash

. ./settings.sh

# Set inner-field-seperator (IFS) to blank
# read using:
#   -r    raw mode, ignoring backslashes
while IFS= read -r file; do
    if [[ -f "$HOME/$file" && "$HOME/$file" -nt "$prefix/$file" ]]; then
        echo "Copying newer file: $file"
        cp "$HOME/$file" "$prefix/$file"
    else
        echo "Skipping older file: $file"
    fi
done < to-be-installed
