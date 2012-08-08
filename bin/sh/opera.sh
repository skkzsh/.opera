#!/bin/sh
#
# DropboxにあるOpera (Next) の
# 設定Fileを共有させるために
# Symbolic Linkを張る,
# またはCopyする.
#
# Operaの設定をDropboxにBackup
#
# Bookmarkはopera:config (operaprefs.ini) で
# Dropbox内のbookmar.adrを直接指定
#
########################################


### Setup or Backup
mode=setup
# mode=backup

### Opera or Opera Next
color=red
# color=white

### rm, cpのOption
alias rm='rm -i'
alias cp='cp -i'

## lnとcpのList
ln_list='keyboard mouse toolbar'
cp_list='override.ini search.ini'
ln_support_list=''
cp_support_list=''
## BackupのList
backup_list="$cp_list"
backup_support_list=''


### Setting

## DropboxのOperaのDirectory
dropbox=~/Dropbox/setting/.opera

## LocalのOperaのDirectories
case "`uname`" in

    Linux)
        case "$color" in
            red)   dot=~/.opera      ;;
            white) dot=~/.opera-next ;;
            *)     exit 1                  ;;
        esac
        dot_support="$dot"
        ;;

    Darwin)
        case "$color" in
            red)   color_dir=Opera       ;;
            white) color_dir=Opera\ Next ;;
            *)     exit 1                ;;
        esac
        dot=~/Library/$color_dir
        dot_support=~/Library/Application\ Support/$color_dir
        ;;

    *)  exit 1 ;;
esac

for dir in "$dot" "$dot_support"; do
    if [ ! -d "$dir" ]; then
        echo "Error: $dir not exists." >&2
        exit 1
    fi
done


### Symbolic Linkを張る関数の読み込み
. ~/bin/SmartLn.sh

case "$mode" in

    setup)

        ### Symbolic Link
        for file in $ln_list; do
            SmartLn ln "$dropbox/$file" "$dot/$file"
        done

        ### Copy
        for file in $cp_list; do
            SmartLn cp "$dropbox/$file" "$dot/$file"
        done


        ### Mail Signaure
        ## TODO: 配列
        db_sig1="$dropbox/mail/signature1.txt"
        db_sig2="$dropbox/mail/signature2.txt"
        support_sig="$dot_support/mail/signature"

        case "$HOSTNAME" in
            sing* | drive* | leap* | box*)
                SmartLn ln "$db_sig1" "${support_sig}1.txt"
                SmartLn ln "$db_sig2" "${support_sig}2.txt"
                ;;
            *)  ;;
        esac

        ;;

    backup)
        ### Backup
        for file in $backup_list; do
            SmartLn cp "$dot/$file" "$dropbox/$file"
        done
        ;;

    *)
        exit 1
        ;;
esac

exit 0
