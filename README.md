# Security Setup

## GPG
* use gpg to encrypt data using aes256, s2k-mode 3(iterated and salted), s2k-digest-algo sha512 and s2k-count 65011712
* use --armor option so encrypted output is in ASCII format
* use --batch so we don't get prompted for user passphrase

## Steghide
* data in jpeg image

## Pwgen
* pwgen to generate random passwords
* generate passwords of length 20 with numbers and letters

## Custome Password Manager
* all passwords/secrets are stored in 0/ 1/ 2/ 3/ folders
* folder 0/ is the least important
* folder 1/ is in the middle and is for stuff like facebook, gmail etc
* folder 2/ and 3/ is for high secrecy stuff like bank
* therefore we have 3 master passwords, m0, m1 and m2
* each password picked must have at least 80 bits of entropy
* have an everyday password
* have an everyday password for character input, eg input letter 1,4,5

## Pseudonyms
* can create subfolders, group accounts for a user/purpose
* keep a user/pseudonym -> purpose mapping file

## Setup
```
apt-get install git steghide gnupg pwgen xclip
clone repo
./extract.sh
```

* initialise the master passwords for 0/ 1/ 2/ 3/
* each folder should have a different master password!
```
./encrypt.sh 0/validate
./encrypt.sh 1/validate
./encrypt.sh 2/validate
./encrypt.sh 3/validate
```

* change gpg cache timeout to your needs, default is 600seconds
```
~/.gnupg/gpg-agent.conf
default-cache-ttl 60   (1minute)
```

## Workflow Examples

### Encrypt Secret
* `./encrypt.sh {0|1|2|3}/somethingSecret`
* replace unencrypted somethingSecret with encrypted somethingSecret.asc

### Decrypt Secret
* `./decrypt.sh {0|1|2|3}/somethingSecret.asc`
* replace encrypted somethingSecret.asc with unencrypted somethingSecret

### Edit Secret
* `./edit.sh {0|1|2|3}/somethingSecret.asc`
* open secret in nano text editor

### Show Secret
* `./show.sh {0|1|2|3}/somethingSecret.asc`
* print secret to terminal
* if folder is used, it will show all the secrets within that folder, although this is turned off for 2/ and 3/

### Copy Secret To Clipboard
* `./copy_to_clipboard.sh {0|1|2|3}/somethingSecret.asc`
* copy the last line of the secret to clipboard
* clipboard will be wiped after 30seconds
* gpg-agent will be used, password is cached

### Generate/Update Password
* `./generate.sh {0|1|2|3}/somethingSecret(.asc)`
* this will generate a random password of 20 characters and append it to the last line of file
* if file doesn't exist, a text editor will be opened where extra information can be added, eg account name
* as this appends to a file, it can be used to change a password
* this will copy the generated password to clipboard
* clipboard will be wiped after 30seconds
* if folder is used, it will generate new secrets for all the files in it, although this is turned off for 2/ and 3/

### Embed Secrets
* `./embed.sh`
* embed secrets into spaceCo.jpg
* for added security, this will also check you do not have any unencrypted files in any subfolders.

### Extract Secrets
* `./extract.sh`
* extract secrets from spaceCo.jpg

### Backup Secrets
* `./backup.sh`
* this will find all the encrypted files(.asc) in subfolders and print
* laminate and store somewhere safe!
* for added security, this will also check you do not have any unencrypted files in any subfolders

### Check No Unencrypted Secrets
* `./list_all_unencrypted_files.sh`
* makes sure there are no unencrypted files

### Pseudonym
* `./pseudonym.sh`
* print some possible pseudonyms
