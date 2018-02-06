#!/usr/bin/env bash
cd ../services

# recursively remove all jar files
find . -name "*.jar" -print0 | xargs -0 rm -rf