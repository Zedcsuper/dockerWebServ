#include <iostream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <cstring>
#include <netdb.h>

int main() {
    sleep(3); // wait a bit for server to start

    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket");
        return 1;
    }

    // Resolve hostname "server" to IP address
    struct hostent* host = gethostbyname("server");
    if (host == NULL) {
        perror("gethostbyname failed");
        close(sockfd);
        return 1;
    }

    sockaddr_in serv;
    serv.sin_family = AF_INET;
    serv.sin_port = htons(5000);
    serv.sin_addr = *((struct in_addr*)host->h_addr); // Copy resolved IP address

    if (connect(sockfd, (struct sockaddr*)&serv, sizeof(serv)) < 0) {
        perror("connect");
        return 1;
    }

    std::string msg = "Hello from client!";
    write(sockfd, msg.c_str(), msg.size());

    char buffer[256];
    int n = read(sockfd, buffer, 255);
    if (n > 0) {
        buffer[n] = '\0';
        std::cout << "Server replied: " << buffer << std::endl;
    }

    close(sockfd);
    return 0;
}
