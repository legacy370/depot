# Build Base image
FROM ruby:2.6.6 as base

LABEL maintainer="n.snyder@shalomcloud.com"

# Environment Variables
ENV DOCKERIZE_VERSION v0.6.1
# In Beanstalk Bundler version 2.2.32, in /opt/rubies/ruby-2.6.9/bin/bundler
# Yet my Gemfile.lock in production says 1.17.2
ENV BUNDLER_VERSION 2.3.8

# Install Postgres
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  wget \
  libpq-dev \
  postgresql-client \
  postgresql-contrib

# Install latest Long Term Support node
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

#Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# Add dockerize
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN apt-get update --allow-releaseinfo-change -yqq && \
  apt-get install -yqq --no-install-recommends \
  cmake \
  cron \
#  imagemagick \
#  libvips \
#  libvips-dev \
#  libvips-tools \
  netcat \
  shared-mime-info \
  vim

# Install wkhtmltopdf
RUN curl -sSL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb -o wkhtmltox_0.12.6-1.buster_amd64.deb
RUN dpkg -x wkhtmltox_0.12.6-1.buster_amd64.deb .

# Install bundler
RUN gem install bundler -v $BUNDLER_VERSION

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG APP_NAME
ENV APP_PATH /var/www/depot
RUN mkdir -p $APP_PATH

COPY Gemfile* /var/www/depot/
WORKDIR /var/www/depot
RUN bundle install

# Build Development image
COPY . /var/www/depot/

WORKDIR $APP_PATH
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
