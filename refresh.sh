#!/bin/bash
. ./settings.sh

cd "$prefix"
git ls-files > ../to-be-installed
echo "Files to be included:"
echo "---------------------"
cat ../to-be-installed
