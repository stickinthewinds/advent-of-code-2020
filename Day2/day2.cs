using System;
using System.Collections.Generic;

namespace Day2
{
    public class day2
    {
        static int Main(string[] args)
        {
            string[] lines = System.IO.File.ReadAllLines(@"input.txt");

            try
            {
                PartOne(lines);
                PartTwo(lines);
            }
            catch (FormatException e)
            {
                Console.WriteLine(e);
            }

            return 0;
        }

        private static void PartOne(string[] lines)
        {
            int valid = 0;

            foreach (string line in lines)
            {
                string minNum = line.Substring(0, line.IndexOf("-"));
                string maxNum = line.Substring(line.IndexOf("-") + 1,
                    line.IndexOf(" ") - 2);

                if (!int.TryParse(minNum, out int min))
                {
                    throw new FormatException($"Unable to parse '{minNum}'");
                }

                if (!int.TryParse(maxNum, out int max))
                {
                    throw new FormatException($"Unable to parse '{maxNum}'");
                }

                char mustInclude = line[line.IndexOf(":") - 1];
                string value = line.Substring(line.IndexOf(": ") + 2);

                int charCount = 0;
                foreach (char c in value)
                {
                    if (c == mustInclude)
                    {
                        charCount += 1;
                    }
                }

                if (charCount >= min && charCount <= max)
                {
                    valid += 1;
                }
            }

            Console.WriteLine($"Valid passwords: {valid}");
        }

        private static void PartTwo(string[] lines)
        {
            int valid = 0;

            foreach (string line in lines)
            {
                string posOne = line.Substring(0, line.IndexOf("-"));
                string posTwo = line.Substring(line.IndexOf("-") + 1,
                    line.IndexOf(" ") - 2);

                if (!int.TryParse(posOne, out int min))
                {
                    throw new FormatException($"Unable to parse '{posOne}'");
                }

                if (!int.TryParse(posTwo, out int max))
                {
                    throw new FormatException($"Unable to parse '{posTwo}'");
                }

                // Since the advent index starts at 1
                min -= 1;
                max -= 1;

                char mustInclude = line[line.IndexOf(":") - 1];
                string value = line.Substring(line.IndexOf(": ") + 2);

                int charCount = 0;
                int indexCount = 0;
                foreach (char c in value)
                {
                    if ((indexCount == min || indexCount == max) && c == mustInclude)
                    {
                        charCount += 1;
                    }
                    indexCount += 1;
                }

                if (charCount == 1)
                {
                    valid += 1;
                }

                /* Better version to shorten the above foreach and if statement
                // XOR to make sure that EXACTLY one is true
                if (value[min] == mustInclude ^ value[max] == mustInclude)
                {
                    valid += 1;
                }
                //*/
            }

            Console.WriteLine($"Valid passwords: {valid}");
        }
    }
}
