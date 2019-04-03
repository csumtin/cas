#!/bin/bash
# Print all encrypted passwords for backup
set -eu

source cas.sh

find_results=$( get_all_unencrypted_files )

if [[ -z "$find_results" ]]; then
    print_algo_details
    get_all_encrypted_files_and_dump_contents
else
    echo "Error: You have some unencrypted files"
    echo "$find_results"
    exit 1
fi
