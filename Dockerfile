FROM ruby:2.4.2-alpine3.6

RUN \
  apk update && \
  apk upgrade

RUN mkdir /app
WORKDIR /app

RUN mkdir /sky
RUN chown 1000:1000 /sky

ADD Gemfile .
ADD Gemfile.lock .
ADD black_sky.gemspec .
ADD lib/black_sky/version.rb lib/black_sky/version.rb

# ENV BUILD_DEPS "g++ make libffi-dev"
ENV BUILD_DEPS "g++ make musl-dev"

RUN \
  apk add --update --no-cache --virtual build-dependencies $BUILD_DEPS && \
  gem install bundler --no-document && \
  bundle install --jobs 4 --without development test && \
  apk del build-dependencies

ADD . .
