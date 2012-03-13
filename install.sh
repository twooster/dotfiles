#!/bin/bash

. settings.sh
# Set inner-field-seperator (IFS) to blank
# read using:
#   -r    raw mode, ignoring backslashes
./refresh.sh

while IFS= read -r file <&3; do
    # get basename by trimming longest */ at beginning
    base="${file##*/}" 
    # get directory name by trimming basename
    dir="${file%"$base"}"
    # trim trailing slash for pretties
    dir="${dir%/}"
    dirto="$HOME/$dir"
    docopy=0
    if [[ ! -d "$dirto" ]]; then
        echo Making directory $dirto...
        mkdir -p "$dirto"
    fi
    if [[ "$HOME/$file" -nt "$prefix/$file" ]]; then
        read -p "Overwrite newer file $file? [yN] " yn
        case $yn in
            [Yy]* ) docopy=1;;
            * ) echo "Skipping.";;
        esac
    else
        docopy=1
    fi

    if [ $docopy -eq 1 ]; then
        echo Copying to $HOME/$file
        cp -p "$prefix/$file" "$HOME/$file"
    fi
done 3< "$manifest"
