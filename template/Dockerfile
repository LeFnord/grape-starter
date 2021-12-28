FROM ruby:3

# stes some Environment variables
ENV NODE_ENV='development'
ENV RACK_ENV='development'

ADD . /dummy
WORKDIR /dummy

COPY Gemfile Gemfile.lock ./
RUN bundle config set --local path 'vendor/bundle'
RUN bundle install

COPY . .

CMD bundle exec thin start -p 9292 -e production --tag API-dummy --threaded
