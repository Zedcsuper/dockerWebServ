#!/bin/bash

docker rm -f wordpress_test
docker run -d \
  --name wordpress_test \
  --network inception_net \
  -v $PWD/wordpress:/var/www/html \
  -p 9000:9000 \
  -e MYSQL_HOST=mariadb_test \
  -e MYSQL_DATABASE=wpdb \
  -e MYSQL_USER=wpuser \
  -e MYSQL_PASSWORD=123 \
  -e WORDPRESS_URL=http://localhost \
  -e WORDPRESS_TITLE="Test Site" \
  -e WORDPRESS_ADMIN_USER=admin \
  -e WORDPRESS_ADMIN_PASSWORD=admin123 \
  -e WORDPRESS_ADMIN_EMAIL=admin@example.com \
  wordpress








docker run -d \
  --name wordpress_test \
  --network inception_net \
  -p 9000:9000 \
  -e MYSQL_HOST=mariadb_test \
  -e MYSQL_DATABASE=wpdb \
  -e MYSQL_USER=wpuser \
  -e MYSQL_PASSWORD=123 \
  -e WORDPRESS_URL=http://localhost \
  -e WORDPRESS_TITLE="Test Site" \
  -e WORDPRESS_ADMIN_USER=admin \
  -e WORDPRESS_ADMIN_PASSWORD=admin123 \
  -e WORDPRESS_ADMIN_EMAIL=admin@example.com \
  wordpress


  ##### testing #############
mysql -h mariadb_test -u wpuser -p123 -e "SHOW DATABASES;"
docker exec -it wordpress_test bash
ps aux | grep php-fpm ## in outer bash not container
wp core is-installed --allow-root --quiet && echo "✅ Installed" || echo "❌ Not installed"
### wp core installed
wp core install \
  --url="http://localhost" \
  --title="Test Site" \
  --admin_user=admin \
  --admin_password=admin123 \
  --admin_email=admin@example.com \
  --allow-root
