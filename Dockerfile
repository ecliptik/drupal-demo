FROM nginx:1.10.1

# Install drupal 7.50 - https://github.com/docker-library/drupal/blob/41970d6f598cf64fe90aa63651ba52cdc384c002/7/fpm/Dockerfile
# This is required so static assets work
WORKDIR /var/www/html

# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 7.50
ENV DRUPAL_MD5 f23905b0248d76f0fc8316692cd64753

#Install curl
RUN apt-get update && apt-get install -y curl \
	&& rm -rf /var/lib/apt/lists/*

#Download and install drupal
RUN curl -fSL "http://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
	&& echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
	&& tar -xz --strip-components=1 -f drupal.tar.gz \
	&& rm drupal.tar.gz \
	&& chown -R www-data:www-data sites

#Add nginx configuration
ADD ./default.conf /etc/nginx/conf.d/
