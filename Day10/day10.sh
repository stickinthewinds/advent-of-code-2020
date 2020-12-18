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
    builtin=$((${sorted[-1]} + 3))
    sorted+=( $builtin )
    part1 "${sorted[@]}"
    part2 "${sorted[@]}"
}

part1()
{
    values=("${@}")
    adapter=0
    ones=0
    threes=0
    for value in ${values[@]}; do
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
    echo "Ones: $ones"
    echo "Threes: $threes"
    echo "$ones * $threes = $answer"
}

part2()
{
    values=("${@}")
    total=0
    arrLen="${#values[@]}"
    arrangements=()

    # very long array of 0s to brute force it
    for ((i=0; i<${values[-1]}; i++)) do
        arrangements+=( 0 )
    done

    # set the start to 1
    arrangements[0]=1

    for value in ${values[@]}; do
        # current amount of paths = sum of paths to the previous 3 values
        newArrangement=$((${arrangements[value - 3]} + ${arrangements[value - 2]} + ${arrangements[value - 1]}))
        arrangements[$value]=$newArrangement
    done
    total=${arrangements[-1]}

    echo "Total number of arrangements: $total"
}

main "$@"