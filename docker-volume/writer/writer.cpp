#include <iostream>
#include <fstream>
#include <ctime>
#include <unistd.h>

int main()
{   
    while (true)
    {
        std::ofstream log("/shared/log.txt", std::ios::app);
        if (log)
        {
            time_t now = time(0);
            log << "log entry at: " << ctime(&now);
            log.close();
            std::cout << "Wrote log entry." << std::endl;
        }
        else
        {
            std::cerr << "Failed to open /shared/log.txt" << std::endl;
        }
        sleep(5);
    }
    return 0;

}