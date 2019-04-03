#!/bin/bash
# Encrypt input file
set -eu

source cas.sh

input=$(sanitize_input $1)
top_level_directory=$(get_top_level_directory $input)
check_top_level_directory $input
check_file $input
check_unencrypted_file $input

# check if we are doing initialisation
if [[ "$input" == *"/validate" ]]; then
    gpg_encrypt "$input"
    rm "$input"
else
    read -s -p "Enter passphrase: " passphrase
    check_validate $top_level_directory $passphrase
    gpg_encrypt_with_passphrase "$input" "$passphrase"
    rm "$input"
    passphrase=""
fi
