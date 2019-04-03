#!/bin/bash
# Extract
set -eu

cd "$(dirname "$0")"

if [[ -f spaceCo.jpg ]]; then
  steghide extract -sf spaceCo.jpg
  tar -xvf backup.tar
  rm backup.tar
  rm spaceCo.jpg
fi
