#!/bin/bash
# Embed
set -eu

source cas.sh

find_results=$( get_all_unencrypted_files )

if [[ -z "$find_results" ]]; then
  cp space.jpg spaceCo.jpg
  tar -cvf backup.tar 0 1 2 3 backup.sh cas.sh copy_to_clipboard.sh decrypt.sh edit.sh embed.sh encrypt.sh generate.sh list_all_unencrypted_files.sh pseudonym.sh README.md show.sh
  steghide embed -e rijndael-256 -cf spaceCo.jpg -ef backup.tar
  rm backup.tar
  rm -r 0 1 2 3
  rm backup.sh cas.sh copy_to_clipboard.sh decrypt.sh edit.sh embed.sh encrypt.sh generate.sh list_all_unencrypted_files.sh pseudonym.sh README.md show.sh
else
  echo "Error: You have some unencrypted files"
  echo "$find_results"
fi



