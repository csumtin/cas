#!/bin/bash
# Copy the last line of input file to clipboard
set -eu

source cas.sh

input=$(sanitize_input $1)
check_top_level_directory $input
check_file $input
check_encrypted_file $input
check_not_validate_file $input

last_passphrase=$( gpg_decrypt_no_output "$input" | tail -1 )
(echo -n "$last_passphrase" | xclip -selection c && sleep 30 && echo | xclip -selection c) &
last_passphrase=""
