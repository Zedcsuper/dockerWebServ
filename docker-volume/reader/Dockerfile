FROM debian:bookworm

RUN apt-get update && apt-get install -y g++ && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY reader.cpp .
RUN g++ reader.cpp -o reader
CMD ["./reader"]