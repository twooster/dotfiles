#!/bin/bash

. settings.sh
# Set inner-field-seperator (IFS) to blank
# read using:
#   -r    raw mode, ignoring backslashes
./refresh.sh

while IFS= read -r file; do
    # get basename by trimming longest */ at beginning
    base="${file##*/}" 
    # get directory name by trimming basename
    dir="${file%"$base"}"
    # trim trailing slash for pretties
    dir="${dir%/}"
	dirto="$HOME/$dir"
	if [[ ! -d "$dirto" ]]; then
            echo Making directory $dirto...
	    mkdir -p "$dirto"
	fi
        if [[ "$HOME/$file" -nt "$prefix/$file" ]]; then
            echo "Destination file appears to be newer, please confirm copy:"
            cp -ip "$prefix/$file" "$HOME/$file"
        else
            echo Copying to $HOME/$file
            cp -p "$prefix/$file" "$HOME/$file"
        fi
done < "$manifest"
