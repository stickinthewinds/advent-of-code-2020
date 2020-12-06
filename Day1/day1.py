#!/usr/bin/env python3

import sys

def part1(lines):
    
    length = len(lines)
    lines.sort()
    i = 0
    j = length - 1
    while i < j:
        left = int(lines[i])
        right = int(lines[j])
        if left + right == 2020:
            print("{} x {} = {}".format(left, right, (left * right)))
            return left, right
        elif left + right < 2020:
            i += 1
        else:
            j -= 1


def part2(lines):
    length = len(lines)
    for i in range(0, length-3):
        for j in range(i+1, length-2):
            for k in range(i+2, length-1):
                num1 = int(lines[i])
                num2 = int(lines[j])
                num3 = int(lines[k])
                if num1 + num2 + num3 == 2020:
                    print("{} x {} x {} = {}".format(num1, num2, num3, (num1 * num2 * num3)))
                    return



def main(args):
    with open("input.txt", "r") as f:
        lines = f.readlines()
        part1(lines)
        part2(lines)


if __name__ == "__main__":
    main(sys.argv[1:])