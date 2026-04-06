#!/bin/bash

set -eux -o pipefail

mise x chezmoi -- chezmoi init --apply JLarky

echo 'All done'
