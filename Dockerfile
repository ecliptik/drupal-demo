FROM nginx:1.11.1-alpine

# Install drupal 7.50 - https://github.com/docker-library/drupal/blob/41970d6f598cf64fe90aa63651ba52cdc384c002/7/fpm/Dockerfile
# This is required so static assets work
WORKDIR /var/www/html

# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 7.50
ENV DRUPAL_MD5 f23905b0248d76f0fc8316692cd64753

#Install curl
RUN apk --no-cache add curl tar

#Download and install drupal
RUN apk --no-cache add --virtual build-dependencies curl tar \
    && curl -fSL "http://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
	&& echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
	&& tar -xz --strip-components=1 -f drupal.tar.gz \
	&& rm drupal.tar.gz \
    && apk del build-dependencies

#Add nginx configuration
ADD ./default.conf /etc/nginx/conf.d/
