#!/bin/bash
# Edit the encypted input file
set -eu

source cas.sh

input=$(sanitize_input $1)
check_top_level_directory $input
check_file $input
check_encrypted_file $input
check_not_validate_file $input

read -s -p "Enter passphrase: " passphrase
gpg_decrypt_with_passphrase "$input" "$passphrase"
nano "${input:: -4}"
gpg_encrypt_replace_with_passphrase "${input:: -4}" "$passphrase"
rm "${input:: -4}"
passphrase=""
