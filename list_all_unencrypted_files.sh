#!/bin/bash
# Show all unencrypted files. There should be no results!
set -eu

source cas.sh

get_all_unencrypted_files
