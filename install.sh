#!/bin/bash

cd home
# Christ, this is arcane:
# Cribbed in part from:
# http://stackoverflow.com/questions/1116992/capturing-output-of-find-print0-into-a-bash-array
while IFS= read -r -u3 -d $'\0' file; do
    dir="${file%/*}" # trim the file
    file="${file#./}" 
	dirto="$HOME/$dir"
	if [[ ! -d "$dirto" ]]; then
		echo Making directory $dirto...
	    mkdir -p "$dirto"
	fi
	echo Copying to $HOME/$file
	cp "$file" "$HOME/$file"
done 3< <(find . -mindepth 1 -type f ! \( -name "*.swp" -or -name "*.un~" \) -print0)
