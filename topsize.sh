#!/bin/bash
args=($@)
i=0
k=0
opt_d=0
opt_N=0
opt_s=0
opt=0
st=1
h=""
minsize=1b
while [[ $opt == 0 ]] && [[ $i < ${#args[*]} ]]; do
        z=${args[$(($i+1))]}
        if [[ ${args[$i]} == "-h" ]]; then
                h="-h"
        elif [[ ${args[$i]} =~ ^-[0-9]+$ ]]; then
                N=${args[$i]}
                opt_N=1
        elif [[ ${args[$i]} == "-s" ]]; then
                z=${args[$(($i+1))]}
                u=${z:0:$((${#z}-1))}
                if [[ ${z:(-1)} =~ [bkMG] ]]; then
                        minsize=$(($u-1))${z:(-1)}
                        opt_s=1
                else
                        echo "invalid argument for [-s minsize]"
                        exit 1
                fi
        elif [[ ${args[$i]} == "--" ]]; then
                opt=1
                st=$(($i+1))
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
        elif [[  ${args[$i]} =~ -* ]] && [[ ${args[$i]} != "-h" ]] && [[ ${args[$i]} != "-s" ]] && [[ ! ${args[$i]} =~ ^-[0-9]+$ ]] && [[ ${args[$(($i-1))]} != "-s" ]]; then
                        echo "Option ${args[$i]} is not supported" 
                        exit 1
        elif [[ ! ${args[$i]} =~ -* ]]; then 
                if [[ ! -d ${args[$i]} ]]; then
                        echo 1  "Directory ${args[$i]} doesn't exist"
                fi
        fi
        i=$(($i+1))
done
if [[ $st > 1 ]]; then
        for (( i=$st; i < ${#args[*]}; i++ )); do
                if [[ ! -d ${args[$i]} ]]; then
                        echo 2 "Directory ${args[$i]} doesn't exist"
                        exit 1
                fi
        done
fi
if [[ ! ${args[0]} =~ -* ]] && [[ $opt_N == 1 ]]; then
        find ${args[0]} -type f -size +$minsize -exec du $h {} +  | sort -r | head $N
elif [[ ! ${args[0]} =~ -* ]] && [[ $opt_N == 0 ]]; then
        find ${args[0]} -type f -size +$minsize -exec du $h {} +  | sort -r
fi
for (( i=1; i<$st; i++ )); do
        if  [[ ! ${args[$i]} =~ -* ]] && [[ $opt_N == 1 ]] && [[ ${args[$(($i-1))]} != "-s" ]]; then
                find ${args[$i]} -type f -size +$minsize -exec du $h {} + | sort -r | head $N
                echo 1 "find ${args[$i]} -type f -size +$minsize -exec du $h {} + | sort -r | head $N"
                k=$(($k+1))
        elif [[ ! ${args[$i]} =~ -* ]] && [[ $opt_N == 0 ]] && [[ ${args[$(($i-1))]} != "-s" ]]; then
                find ${args[$i]} -type f -size +$minsize -exec du $h {} + | sort -r
                echo 2 "find ${args[$i]} -type f -size +$minsize -exec du $h {} + | sort -r" 
                k=$(($k+1))
        fi
done
for (( i=$st; i<${#args[*]}; i++ )); do
        if [[ $st > 1 ]]; then
                if  [[ $opt_N == 1 ]]; then
                        find ${args[$i]} -type f -size +$minsize -exec du $h {} + | sort -r | head $N
                        echo 3 "find ${args[$i]} -type f -size +$minsize -exec du $h {} + | sort -r | head $N"
                        k=$(($k+1))
                else
                        echo 4 "find ${args[$i]} -type f -size +$minsize -exec du $h {} + | sort -r" 
                        find ${args[$i]} -type f -size +$minsize -exec du $h {} + | sort -r
                        k=$(($k+1))
                fi
        else
                if  [[ ${args[$i]} != -* ]] && [[ $opt_N == 1 ]] && [[ ${args[$(($i-1))]} != "-s" ]]; then
                        find ${args[$i]} -type f -size +$minsize -exec du $h {} + | sort -r | head $N
                        echo 5 "find ${args[$i]} -type f -size +$minsize -exec du $h {} + | sort -r | head $N"
                        k=$(($k+1))
                elif [[ ${args[$i]} != -* ]] && [[ $opt_N == 0 ]] && [[ ${args[$(($i-1))]} != "-s" ]]; then
                        find ${args[$i]} -type f -size +$minsize -exec du $h {} + | sort -r
                        echo 6 "find ${args[$i]} -type f -size +$minsize -exec du $h {} + | sort -r" 
                        k=$(($k+1))
                fi
        fi
done
if [[ $k == 0 ]]; then
        if [[ $opt_N == 1 ]]; then
                find . -type f -size +$minsize -exec du $h {} + | sort -r | head $N
                echo 7 "find . -type f -size +$minsize -exec du $h {} + | sort -r | head $N"
        else
                find . -type f -size +$minsize -exec du $h {} + | sort -r
                echo 8 "find . -type f -size +$minsize -exec du $h {} + | sort -r" 
        fi
fi

