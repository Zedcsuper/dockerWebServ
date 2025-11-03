#!/usr/bin/env bash
set -e

# Base path for your project
REQ_PATH=~/inception007/inception/srcs/requirements
VOLUME_PATH=~/volume

# Create the volume folders if missing
mkdir -p "$VOLUME_PATH/mariadb" "$VOLUME_PATH/wordpress"

echo "🧹 Cleaning old containers/images..."
docker stop $(docker ps -q) 2>/dev/null || true
docker rm $(docker ps -a -q) 2>/dev/null || true
docker rmi $(docker images -q) 2>/dev/null || true

echo "🌐 Ensuring network exists..."
docker network create inception_network 2>/dev/null || true

echo "🐬 Building and running MariaDB..."
cd "$REQ_PATH/mariadb"
docker build -t mdbtest .
docker run -d \
  --name mariadb_test \
  --network inception_network \
  -p 3306:3306 \
  -v "$VOLUME_PATH/mariadb":/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=123 \
  -e MYSQL_DATABASE=wpdb \
  -e MYSQL_USER=wpuser \
  -e MYSQL_PASSWORD=123 \
  mdbtest

sleep 7

echo "🪄 Building and running WordPress..."
cd "$REQ_PATH/wordpress"
docker build -t wordpress-manual .
docker run -d \
  --name wordpress_manual \
  --network inception_network \
  -v "$VOLUME_PATH/wordpress":/var/www/html \
  -e MYSQL_DATABASE=wpdb \
  -e MYSQL_USER=wpuser \
  -e MYSQL_PASSWORD=123 \
  -e MYSQL_HOST=mariadb_test \
  -e WORDPRESS_URL=https://localhost \
  -e WORDPRESS_TITLE="My Test Site" \
  -e WORDPRESS_ADMIN_USER=admin \
  -e WORDPRESS_ADMIN_PASSWORD=admin123 \
  -e WORDPRESS_ADMIN_EMAIL=admin@example.com \
  -p 9000:9000 \
  wordpress-manual

sleep 5

echo "🌍 Building and running Nginx..."
cd "$REQ_PATH/nginx"
docker build -t nginx-wp .
docker run -d \
  --name nginx_test \
  --network inception_network \
  -p 443:443 \
  -v "$VOLUME_PATH/wordpress":/var/www/html \
  nginx-wp

echo "✅ All containers are up and running!"
docker ps
