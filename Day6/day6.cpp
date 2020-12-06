#include <algorithm>
#include <iostream>
#include <fstream>
#include <map>
#include <sstream>
#include <string>
#include <vector>

int getGroupAnswered(std::string group, int numPeople);
int processGroups(std::multimap<int, std::string> groups, int part);

int main(int argc, char *argv[])
{
    if (argc != 2 && argc != 3)
    {
        // If argv[2] is 1 or empty then do part 1 of advent of code
        // Part 1 involves all unique answers for a group
        // If argv[2] is 2 then do part 2 of advent of code
        // Part 2 is unique answers where every member answered them
        std::cout << "Incorrect number of arguments. "
                  << "Must be the program and a file name." << std::endl
                  << "May also include a number for the part of advent";
        return 1;
    }

    std::ifstream file(argv[1]);
    if (file.is_open())
    {
        int part = 1;
        if (argc == 3 && atoi(argv[2]) == 2)
        {
            part = 2;
        }

        // Map for number of people in a group and the string for that group
        std::multimap<int, std::string> groups;
        int total = 0, people = 0;
        std::string currGroup = "";
        std::string line;
        while (std::getline(file, line))
        {
            std::istringstream iss(line);
            if (line.length() == 0)
            {
                std::cout << "Number of people: " << people
                          << std::endl
                          << "Group string: " << currGroup
                          << std::endl;
                groups.insert(std::pair<int, std::string>(people, currGroup));
                currGroup = "";
                people = 0;
            }
            else
            {
                currGroup += line;
                people += 1;
            }
        }

        if (!currGroup.empty())
        {
            std::cout << "Number of people: " << people
                      << std::endl
                      << "Group string: " << currGroup
                      << std::endl;
            groups.insert(std::pair<int, std::string>(people, currGroup));
        }

        if (groups.size() > 0)
        {
            total = processGroups(groups, part);
        }
        std::cout << "Total answers: " << total << std::endl;
    }
    else
    {
        std::cout << "Failed to open file: " << argv[1] << std::endl;
        return 1;
    }

    return 0;
}

/**
 * Get the number of unique answers from each group
 * or the number of people answers that every person
 * in the group did based on the numPeople import
 * */
int getGroupAnswered(std::string group, int numPeople)
{
    std::map<char, int> answered;
    int answers = 0;

    for (char c : group)
    {
        std::map<char, int>::iterator it = answered.find(c);
        if (it != answered.end())
        {
            it->second += 1;
        }
        else
        {
            answered.insert(std::pair<char, int>(c, 1));
        }
    }

    for (std::map<char, int>::iterator it = answered.begin(); it != answered.end(); ++it)
    {
        // Greater than in the event of part 1
        if (it->second >= numPeople)
        {
            answers += 1;
        }
    }
    std::cout << "Group answered "
              << answers
              << " questions." << std::endl;
    return answers;
}

/**
 * Go through each group to get the total sum of answers
 * */
int processGroups(std::multimap<int, std::string> groups, int part)
{
    int total = 0;

    for (std::map<int, std::string>::iterator it = groups.begin(); it != groups.end(); ++it)
    {
        if (part == 1)
        {
            total += getGroupAnswered(it->second, 1);
        }
        else
        {
            total += getGroupAnswered(it->second, it->first);
        }
        
        std::cout << it->first << ":" << it->second << std::endl;
    }
    return total;
}