docker rm -f nginx_test
docker run -d \
  --name nginx_test \
  --network inception_net \
  -v $PWD/wordpress_data:/var/www/html \
  -p 443:443 \
  -e DOMAIN_NAME=zed.42.fr \
  nginxtest
#403 problem
docker exec -it nginx_test sh
ls -l /var/www/html
