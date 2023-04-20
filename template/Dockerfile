FROM ruby:3

# stes some Environment variables
ENV NODE_ENV='development'
ENV RACK_ENV='development'

COPY . /dummy
WORKDIR /dummy

COPY Gemfile Gemfile.lock ./
RUN bundle config set --local path 'vendor/bundle'
RUN bundle install

COPY . .

CMD bundle exec puma --tag API-dummy
