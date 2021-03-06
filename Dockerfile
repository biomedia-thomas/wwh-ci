FROM alpine:3.13

RUN adduser -D -s /bin/bash worker && \
 apk --no-cache add \
 git rsync curl bash jq openssl openssh-client zip unzip \ 
 php php-intl php-openssl php-soap php-gmp php-phar php-pdo_mysql php-sodium php-mysqli php-ctype php-mbstring php-pdo \
 php-json php-fileinfo php-curl php-opcache php-exif php-zip php-gd php-xml php-xmlreader php-simplexml php-iconv php-posix php-ftp \
 php-session php-tokenizer php-xmlwriter php-dom \
 composer nodejs npm

RUN npm i -g npm && echo 'memory_limit=2G' > /etc/php7/conf.d/99_custom.ini
RUN curl -s https://api.github.com/repos/fabpot/local-php-security-checker/releases/latest | \
    jq -r '.assets[] | select(.name | contains("linux_amd64")) | .browser_download_url' | xargs wget -O /usr/local/bin/local-php-security-checker \
    && chmod +x /usr/local/bin/local-php-security-checker

USER worker

RUN composer global require deployer/deployer ^6.0 deployer/recipes ^6.0

COPY --chown=worker:worker ssh-wrap /home/worker/bin/
RUN echo 'export PATH=$PATH:$HOME/bin:$HOME/.composer/vendor/bin' >> ~/.bashrc && \
    chmod +x /home/worker/bin/*
CMD ["bash"]

