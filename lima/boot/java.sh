#!/bin/bash

# Amazon Corretto 21 (OpenJDK distribution) via mise.

set -eux -o pipefail

mise use -g java@corretto-21

echo 'All done.'
