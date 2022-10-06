FROM nginx:alpine

RUN apk update

RUN mkdir -p "/var/www/html/static_files/" "/var/www/second" "/etc/letsencrypt"
RUN touch "/var/www/html/static_files/file2.mp3"



COPY test.conf /etc/nginx/conf.d/thef1nansist.conf
COPY index.html /usr/share/nginx/html/index.html
COPY index2.html /var/www/second/index.html
COPY image1.jpg /var/www/html/static_files/image1.jpg
COPY image2.png /var/www/html/static_files/image2.png
COPY fullchain.pem /etc/letsencrypt/fullchain.pem
COPY privkey.pem /etc/letsencrypt/privkey.pem

EXPOSE 80 443   