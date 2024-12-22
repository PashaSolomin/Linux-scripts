#!/bin/bash
args=($@)
i=0
k=0
opt_d=0
opt_h=0
opt_N=0
opt_s=0
opt=0
h=""
minsize="1b"
while [[ opt == 0 ]] && [[ $i < ${#args[*]} ]]; do
        if [[ ${args[$i]} == "-h" ]]; then
                opt_h=1
                h="-h"
        elif [[ ${args[$i]} =~ ^-[0-9]+$ ]]; then
                N=${args[$i]}
        elif [[ ${args[$i]} == "-s" ]]; then
                min_size=$((${args[$(($i+1))]}-1))
                opt_s=1
        elif [[ ${args[$i]} == "--" ]]; then
                opt=1
                st=$(($i+1))
        elif  [[ ${args[$i]} == "/*" ]]; then
                opt_d=1
        elif [[ ${args[$i]} == "--help" ]]; then
                        echo "topsize [--help][-h][-N][-s minsize][--][dir...]"
                        echo "  "
                        echo "Shows N biggest files from given directory and all its subdirectories if the files' size is greater than minsize"
                        echo "  "
                        echo "Displays the file path (starting from the specified directory) and file size"
                        echo "  "
                        echo "Options:"
                        echo "   -h     uses optimal units of measurement"
                        echo "   -N     quontity of files (all files if not stated)"
                        echo "   -s minsize     the required size to be displayed by this script (1b if not stated)"
                        exit 0
        elif [[ ${files[$i]} == -* ]] && [[ ${files[$i]} != "-h" ]] && [[ ${files[$i]} != "-s" ]] && [[ ${files[$i]} != "/*" ]]; then
                        echo "Option ${files[$i]} is not supported" 
                        exit 1
	fi
        i=$(($i+1))
done

if [[ opt_N == 1 ]]; then
        for (( i=0; i<$st; i++ )); do
                if  [[ ${args[$i]} == "/*" ]]; then
                        y=$(find ${args[$i]} -type f -size +$minsize -exec du $h {} + | sort -r | head $N)
                        k=$(($k+1))
                        echo $y
                fi
        done
        for (( i=$st; i<${#args[*]}; i++ )); do
                if  [[ ${args[$i]} == "/*" ]]; then
                        y=$(find ${args[$i]} -type f -size +$minsize -exec du $h {} + | sort -r | head $N)
                        k=$(($k+1))
                        echo $y
                fi
        done
        if [[ k == 0 ]]; then
                y=$(find . -type f -size +$minsize -exec du -h {} + | sort -r | head $N)
                echo $y
        fi
elif [[ opt_N == 0 ]]; then
        for (( i=0; i<$st; i++ )); do
                if  [[ ${args[$i]} == "/*" ]]; then
                        y=$(find ${args[$i]} -type f -size +$minsize -exec du $h {} + | sort -r)
                        k=$(($k+1))
                        echo $y
                fi
        done
        for (( i=$st; i<${#args[*]}; i++ )); do
                if  [[ ${args[$i]} == "/*" ]]; then
                        y=$(find ${args[$i]} -type f -size +$minsize -exec du $h {} + | sort -r)
                        k=$(($k+1))
                        echo $y
                fi
        done
        if [[ k == 0 ]]; then
                y=$(find . -type f -size +$minsize -exec du -h {} + | sort -r)
                echo $y
        fi
fi

