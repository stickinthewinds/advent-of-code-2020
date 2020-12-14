#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "stretchy_buffer.h"

#define MAX_LEN 100

int part1(char **lines, char *preambleString);
int checkNumber(int preamble, int preambleHistory[], int num);
void part2(int exception, char **lines);
int getSum(int i, int j, char **lines);