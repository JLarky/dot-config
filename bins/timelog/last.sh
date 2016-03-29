#!/bin/bash
cd -- "${0%/*}"

OUT=out/`date +"%Y-%m"`
cd $OUT
gwenview "`ls *.jpeg -t | head -1`"
