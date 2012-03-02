#!/bin/bash
. ./settings.sh

cd "$prefix"
echo "Files to be included:"
echo "---------------------"
git ls-files | tee ../to-be-installed
