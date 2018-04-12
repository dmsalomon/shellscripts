#!/bin/bash

for last; do true; done # get last arg
mv "$@" && [ -d $last ] && cd $last && ls --color=auto
