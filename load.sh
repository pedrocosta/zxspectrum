#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Falta o nome do ficheiro a compilar e carregar"
    exit 1
fi

fullname="$1"
extension="${fullname##*.}"
filename="${fullname%.*}"

if [[ "$extension" == "asm" ]]; then
    pasmo --tapbas "$filename.asm" "$filename.tap"
elif [[ "$extension" == "bas" ]]; then
    zmakebas -o "$filename.tap" "$filename.bas"
elif [[ "$extension" != "tap" ]]; then
    echo "O ficheiro tem de ser .bas, .asm ou .tap"
    exit 1
fi

fuse --auto-load --tape "$filename.tap"
