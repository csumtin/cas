#!/bin/bash
# Decrypt input file
set -eu

source cas.sh

input=$(sanitize_input $1)
check_top_level_directory $input
check_file $input
check_encrypted_file $input
check_not_validate_file $input

gpg_decrypt $input
rm "$input"
