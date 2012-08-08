#!/bin/sh
#
# Opera NextとOperaの設定を
# 共有させるために
# Symbolic Linkを張る,
# またはCopyする.
########################################

### rm, cpのOption
alias rm='rm -i'
alias cp='cp -i'

## lnとcpのList
ln_list='global_history.dat opcacrt6.dat opcert6.dat opssl6.dat typed_history.xml sessions wand.dat'
cp_list=''
ln_support_list='widgets'
cp_support_list=''


### Setting

## OperaとOpera NextのDirecties
case `uname` in

    Linux)
        dot_red=~/.opera
        dot_red_support=$dot_red
        dot_white=~/.opera-next
        dot_white_support=$dot_white
        ;;

    Darwin)

        red=Opera
        white=Opera\ Next
        library=~/Library
        support=~/Library/Application\ Support

        dot_red=$library/$red
        dot_red_support=$support/$red
        dot_white=$library/$white
        dot_white_support=$support/$white

        ;;

    *)  exit 1 ;;
esac

for dir in "$dot_red" "$dot_red_support" "$dot_white" "$dot_white_support"; do
    if [ -d "$dir" ]; then
        :
    else
        echo "Error: $dir not exists." >&2
        exit 1
    fi
done


### Symbolic Linkを張る関数の読み込み
. ~/bin/SmartLn.sh

### Symbolic Link
for file in $ln_list; do
    SmartLn ln "$dot_red/$file" "$dot_white/$file"
done
for file in $ln_support_list; do
    SmartLn ln "$dot_red_support/$file" "$dot_white_support/$file"
done

exit 0
