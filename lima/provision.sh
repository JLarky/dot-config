#!/bin/bash

set -eux -o pipefail

cd $(dirname $0)

mkdir -p ~/vm
mkdir -p ~/.lima-home
LIMA_HOME=$(cd ~/.lima-home && pwd)

limactl stop mine || true
limactl delete mine || true
limactl start mine.yaml --mount .. --mount ~/vm:w


echo '\n\nlimactl stop mine; limactl stop default; limactl delete default; limactl clone mine default\n\n'
