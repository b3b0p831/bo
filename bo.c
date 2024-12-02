#include <stdio.h>
#include <stdlib.h>
#include <winsock2.h>
#include <io.h>

// Need to link with Ws2_32.lib
#pragma comment(lib, "Ws2_32.lib")


void helper(){
    // Using inline assembly 
    __asm__("jmp *%esp");
}

void vuln(const char *src){
    char dest[16];
    memcpy(dest, src, 512);    
}

SOCKET establish_server(char *ip, int port){


    WSADATA wsaData;
    SOCKET server_fd = INVALID_SOCKET;
    struct sockaddr_in address;

    // Initialize Winsock
    if (WSAStartup(MAKEWORD(2,2), &wsaData) != 0) {
        printf("WSAStartup failed\n");
        exit(EXIT_FAILURE);
    }

    //Create socket
    server_fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (server_fd == INVALID_SOCKET){
        printf("Socket creation failed with error: %d\n", WSAGetLastError());
        WSACleanup();
        exit(EXIT_FAILURE);
    }

    // Set up address structure
    memset(&address, 0, sizeof(address));
    address.sin_family = AF_INET;
    address.sin_port = htons(port);
    address.sin_addr.s_addr = inet_addr(ip);


    // Bind socket to ip:port
    if (bind(server_fd, (struct sockaddr*)&address, sizeof(address)) == SOCKET_ERROR){
        printf("Bind failed with error: %d\n", WSAGetLastError());
        closesocket(server_fd);
        WSACleanup();
    }
    


    // Listen for n connections
    int n = 1;
    if (listen(server_fd, n) == SOCKET_ERROR){
        printf("Listen failed with error: %d\n", WSAGetLastError());
        closesocket(server_fd);
        WSACleanup();
        exit(EXIT_FAILURE);
    }

    printf("Server listening on %s:%d\n", ip, port);
    return server_fd;
}


int main(int argc, char **argv){
    char buf[512];
    int port = atoi(argv[2]);
    SOCKET server_fd = establish_server(argv[1], port);
    SOCKET client_fd = INVALID_SOCKET;
    struct sockaddr_in client_addr;
    int client_addr_len = sizeof(client_addr);
    

    // Accept and handle connections
    
    client_fd = accept(server_fd, (struct sockaddr*)&client_addr, &client_addr_len);
    if (client_fd == INVALID_SOCKET) {
        printf("Accept failed with error: %d\n", WSAGetLastError());
        exit(EXIT_FAILURE);
    }
    
    // Get client IP using inet_ntoa instead of inet_ntop
    printf("New connection from %s:%d\n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));
    int bytes_read = recv(client_fd, buf, sizeof(buf), 0);
    printf("Received: %s from %s\n", buf, inet_ntoa(client_addr.sin_addr));

    vuln(buf);
    return 0;
}