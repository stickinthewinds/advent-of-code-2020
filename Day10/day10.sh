#!/usr/bin/env bash

main()
{
    input="${@}"
    values=()

    while IFS= read -r line
    do
        values+=( $line )
        #echo "$line"
    done < "$input"
    sorted=($( printf "%s\n" "${values[@]}" | sort -n ))
    builtin=$((${sorted[@]: -1: 1} + 3))
    sorted+=( $builtin )
    part1
}

part1()
{
    adapter=0
    ones=0
    threes=0
    for value in ${sorted[@]}; do
        #echo "Adapter: $adapter        Value: $value"
        diff=$(($value - $adapter))
        if (($diff <= 3 && $diff > 0)); then
            if (($diff == 1)); then
                ones=$(($ones + 1))
            elif (($diff == 3)); then
                threes=$(($threes + 1))
            fi
            adapter=$value
        fi
    done
    answer=$(($ones * $threes))
    echo "$ones * $threes = $answer"
}

main "$@"