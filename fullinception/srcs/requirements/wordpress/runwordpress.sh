docker run -d \
  --name wordpress_test \
  -p 9000:9000 \
  -e PHP_MEMORY_LIMIT=512M \
  -e MYSQL_HOST=172.17.0.2 \
  -e MYSQL_DATABASE=wpdb \
  -e MYSQL_USER=wpuser \
  -e MYSQL_PASSWORD=123 \
  -e WORDPRESS_URL=http://localhost \
  -e WORDPRESS_TITLE="Test Site" \
  -e WORDPRESS_ADMIN_USER=admin \
  -e WORDPRESS_ADMIN_PASSWORD=admin123 \
  -e WORDPRESS_ADMIN_EMAIL=admin@example.com \
  wordpress
