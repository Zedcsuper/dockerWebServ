FROM debian:bookworm

RUN apt-get update && apt-get install -y g++ && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY main.cpp .
RUN g++ main.cpp -o server

EXPOSE 5000
CMD ["./server"]
