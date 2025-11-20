#!/bin/bash
WORDPRESS_ADMIN_PASSWORD=$(cat /run/secrets/admin_password)
WORDPRESS_USER_PASSWORD=$(cat /run/secrets/admin_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
export MYSQL_PASSWORD


set -e

wait_for_mariadb() {
    echo "Waiting for MariaDB..."
    until mysqladmin ping -h "$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
        sleep 2
    done
    echo "MariaDB is up!"
}

cd /var/www/html

wait_for_mariadb

if ! wp core is-installed --allow-root 2>/dev/null; then
    echo "Installing WordPress..."

    if [ ! -f index.php ]; then
        wp core download --allow-root
    fi

    if [ ! -f wp-config.php ]; then
        wp config create \
            --dbname="$MYSQL_DATABASE" \
            --dbuser="$MYSQL_USER" \
            --dbpass="$MYSQL_PASSWORD" \
            --dbhost="$MYSQL_HOST" \
            --allow-root
    fi

    wp core install \
        --url="$WORDPRESS_URL" \
        --title="$WORDPRESS_TITLE" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    if [ -n "$WORDPRESS_USER" ]; then
        wp user create \
            "$WORDPRESS_USER" \
            "$WORDPRESS_USER_EMAIL" \
            --role=author \
            --user_pass="$WORDPRESS_USER_PASSWORD" \
            --allow-root
    fi

    echo "WordPress installation completed!"
else
    echo "WordPress already installed."
fi

echo "Starting PHP-FPM..."
exec "$@"
