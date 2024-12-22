#!/bin/bash
args=($@)
i=0
opt_d=0
opt_h=0
opt_N=0
opt_s=0
opt=0
minsize=1b
while [[ opt == 0 ]] && [[ $i < ${#args[*]} ]]; do
        if [[ ${args[$i]} == "-h" ]]; then
                opt_h=1
        elif [[ ${args[$i]} =~ ^-[0-9]+$ ]]; then
                x=${args[$i]}
                N=${x:1}
        elif [[ ${args[$i]} == "-s" ]]; then
                min_size=$((${args[$(($i+1))]}-1))
                opt_s=1
        elif [[ ${args[$i]} == "--" ]]; then
                opt=1
                st=$(($i+1))
        elif  [[ ${args[$i]} == "/*" ]]; then
                opt_d=1
        fi
        i=$(($i+1))
done
if [[ opt_N == 1 ]]; then
        if [[ opt_h == 1 ]]; then
                for (( i=0; i<$st; i++ )); do
                        if  [[ ${args[$i]} == "/*" ]]; then
                                y=$(find ${args[$i]} -type f -size +$minsize -exec du -h {} + | sort -r | head -$N)
                                echo $y
                        fi
                done
                for (( i=$st; i<${#args[*]}; i++ )); do
                        if  [[ ${args[$i]} == "/*" ]]; then
                                y=$(find ${args[$i]} -type f -size +$minsize -exec du -h {} + | sort -r | head -$N)
                                echo $y
                        fi
                done
        else
                for (( i=0; i<$st; i++ )); do
                        if  [[ ${args[$i]} == "/*" ]]; then
                                y=$(find ${args[$i]} -type f -size +$minsize -exec du -h {} + | sort -r | head -$N)
                                echo $y
                        fi
                done
                for (( i=$st; i<${#args[*]}; i++ )); do
                        if  [[ ${args[$i]} == "/*" ]]; then
                                y=$(find ${args[$i]} -type f -size +$minsize -exec du -h {} + | sort -r | head -$N)
                                echo $y
                        fi
                done
        fi
elif [[ opt_N == 0 ]]; then
        if [[ opt_h == 1 ]]; then
                for (( i=0; i<$st; i++ )); do
                        if  [[ ${args[$i]} == "/*" ]]; then
                                y=$(find ${args[$i]} -type f -size +$minsize -exec du -h {} + | sort -r)
                                echo $y
                        fi
                done
                for (( i=$st; i<${#args[*]}; i++ )); do
                        if  [[ ${args[$i]} == "/*" ]]; then
                                y=$(find ${args[$i]} -type f -size +$minsize -exec du -h {} + | sort -r)
                                echo $y
                        fi
                done
        else
                for (( i=0; i<$st; i++ )); do
                        if  [[ ${args[$i]} == "/*" ]]; then
                                y=$(find ${args[$i]} -type f -size +$minsize -exec du  {} + | sort -r)
                                echo $y
                        fi
                done
                for (( i=$st; i<${#args[*]}; i++ )); do
                        if  [[ ${args[$i]} == "/*" ]]; then
                                y=$(find ${args[$i]} -type f -size +$minsize -exec du  {} + | sort -r)
                                echo $y
                        fi
                done
        fi
