FROM debian:bookworm

RUN apt-get update && apt-get install -y g++ && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY writer.cpp .
RUN g++ writer.cpp -o writer
CMD ["./writer"]