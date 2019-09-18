FROM alpine:3.10

RUN adduser -D -s /bin/bash worker && \
 apk --no-cache add \
 git rsync curl bash openssl openssh-client zip unzip \ 
 php php-intl php-openssl php-soap php-gmp php-phar php-pdo_mysql php-sodium php-mysqli php-ctype php-mbstring php-pdo \
 php-json php-fileinfo php-curl php-opcache php-exif php-zip php-gd php-xml php-simplexml php-iconv php-posix php-ftp \
 php-session php-tokenizer php-xmlwriter php-dom \
 composer nodejs npm

USER worker

RUN composer global require sensiolabs/security-checker ^6.0 deployer/deployer ^6.0 deployer/recipes ^6.0 hirak/prestissimo

COPY --chown=worker:worker ssh-wrap /home/worker/bin/
RUN echo 'export PATH=$PATH:$HOME/bin:$HOME/.composer/vendor/bin' >> ~/.bashrc && \
    chmod +x /home/worker/bin/*
CMD ["bash"]

