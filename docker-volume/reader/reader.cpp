#include <iostream>
#include <fstream>
#include <string>
#include <unistd.h>

int main()
{
    while (true)
    {
        std::ifstream log("/shared/log.txt");
        std::string line;
        if (log)
        {
            std::cout << "-----Log content-----" << std::endl;
            while (std::getline(log, line))
            {
                std::cout << line << std::endl;
            }
            std::cout << "------------------" << std::endl;
        }
        else
        {
            std::cerr << "Waiting for log file .." << std::endl;
        }
        sleep (5);
    }
    return (0);
}