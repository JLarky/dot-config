#!/usr/bin/env bash

cd -- "${0%/*}"

docker build -f Dockerfile -t jlarky/openconnect .
