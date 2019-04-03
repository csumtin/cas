#!/bin/bash
# Generate some possible pseudonyms
set -eu

source cas.sh

pwgen -A -0 10
