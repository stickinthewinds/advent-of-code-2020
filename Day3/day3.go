package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
)

// Traverses through each line based on the slope, counting the
// number of trees encountered
func Traverse(lines []string, slopeRight int, slopeDown int) int {
    position := 0
    treeCount := 0
    for i, line := range lines {
        if i % slopeDown == 0 {
            if string(line[position]) == "#" {
                treeCount++
            }
            position += slopeRight
            if position >= len(line) {
                position -= len(line)
            }
        }
    }

    return treeCount
}

func main() {
    fileName := ""
    var lines []string
    lines = make([]string, 10)
    lineCount := 0

    if len(os.Args) == 2 {
        fileName = os.Args[1]
    }

    file, err := os.Open(fileName)
    if err != nil {
        log.Fatal(err)
    }

    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        if lineCount + 1 > len(lines) {
            newSlice := make([]string, lineCount * 2)
            copy(newSlice, lines)
            lines = newSlice
        }

        lines[lineCount] = scanner.Text()
        lineCount++
    }

    lines = lines[0:lineCount]

    slopes := [][]int{{1, 1},
                     {3, 1}, // Part one
                     {5, 1},
                     {7, 1},
                     {1, 2}}

    results := make([]int, len(slopes))
    for i, slope := range slopes {
        trees := Traverse(lines, slope[0], slope[1])
        fmt.Printf("Trees encountered for slope Right: %d, Down %d:\n%d\n", slope[0], slope[1], trees)
        results[i] = trees
    }

    total := 1
    for _, result := range results {
        total *= result
    }

    fmt.Printf("Total: %d\n", total)

    if err := scanner.Err(); err != nil {
        log.Fatal(err)
    }
}