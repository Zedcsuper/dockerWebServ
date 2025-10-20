#include <iostream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <cstring>

int main() {
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket");
        return 1;
    }

    sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(5000);

    if (bind(sockfd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
        perror("bind");
        return 1;
    }

    listen(sockfd, 1);
    std::cout << "Server listening on port 5000..." << std::endl;

    sockaddr_in client;
    socklen_t len = sizeof(client);
    int conn = accept(sockfd, (struct sockaddr*)&client, &len);
    if (conn < 0) {
        perror("accept");
        return 1;
    }

    char buffer[256];
    int n = read(conn, buffer, 255);
    if (n > 0) {
        buffer[n] = '\0';
        std::cout << "Received: " << buffer << std::endl;
        std::string reply = "Hi from server!";
        write(conn, reply.c_str(), reply.size());
    }

    close(conn);
    close(sockfd);
    return 0;
}
