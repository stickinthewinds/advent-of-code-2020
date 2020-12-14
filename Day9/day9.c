#include "day9.h"

int main(int argc, char *argv[])
{
    if (argc != 3)
    {
        printf("Must include a text file and a number for preamble.\n");
        return 1;
    }

    FILE *fp;
    char line[MAX_LEN];

    fp = fopen(argv[1], "r");
    if (fp == NULL)
    {
        printf("Failed to read file: %s\n", argv[1]);
        return 1;
    }

    //int numLines = countLines(line, MAX_LEN, fp);
    //printf("%s has %d lines\n", argv[1], numLines);
    char **lines = NULL;
    int current = 0;

    while(fgets(line, MAX_LEN, fp))
    {
        char *newLine = (char*)malloc(sizeof(char) * MAX_LEN);
        strncpy(newLine, line, MAX_LEN);
        sb_push(lines, newLine);
    }

    int numLines = sb_count(lines);
    printf("Number of lines: %d\n", numLines);

    int exception = part1(lines, argv[2]);
    if (exception != 0) // 0 means part 1 failed
    {
        part2(exception, lines);
    }

    fclose(fp);
    sb_free(lines);
    return 0;
}

int part1(char **lines, char *preambleString)
{
    int exception = 0;
    int preamble = atoi(preambleString);

    if (preamble > 0)
    {
        // Set the history of the preamble
        int preambleHistory[preamble];
        for (size_t i = 0; i < preamble; i++)
        {
            preambleHistory[i] = atoi(lines[i]);
        }

        for (size_t i = preamble; i < sb_count(lines); i++)
        {
            int num = atoi(lines[i]);
            int found = checkNumber(preamble, preambleHistory, num);
            if (found == 1)
            {
                printf("Exception: %d\n", num);
                exception = num;
            }

            int nextInHistory = i % preamble;
            preambleHistory[nextInHistory] = num;
        }
    }
    return exception;
}

/* Returns 1 for false and 0 for true */
int checkNumber(int preamble, int preambleHistory[], int num)
{
    int left = 0, right = preamble - 1, found = 1, current;

    for (size_t i = 0; i < preamble - 1; i++)
    {
        for (size_t j = i + 1; j < preamble; j++)
        {
            current = preambleHistory[i] + preambleHistory[j];
            if (current == num)
                found = 0;
        }
    }
    return found;
}

void part2(int exception, char **lines)
{
    printf("Goal: %d\n", exception);
    int low = 0, high = 0;

    for (size_t i = 0; i < sb_count(lines) - 1; i++)
    {
        for (size_t j = i + 1; j < sb_count(lines); j++)
        {
            int sum = getSum(i, j, lines);
            if (sum == exception)
            {
                low = i;
                high = j;
                printf("i: %ld\nj: %ld\n", i, j);
                break;
            }
        }
    }

    int min = atoi(lines[low]), max = atoi(lines[low]);
    printf("Low: %d\nHigh: %d\n", low, high);
    for (size_t k = low; k <= high; k++)
    {
        int num = atoi(lines[k]);
        if (num < min)
            min = num;
        if (num > max)
            max = num;
    }
    printf("Smallest: %d\nLargest: %d\nWeakness: %d\n", min, max, min + max);
}

int getSum(int low, int high, char **lines)
{
    int sum = 0;
    for (size_t i = low; i <= high; i++)
    {
        sum += atoi(lines[i]);
    }
    return sum;
}