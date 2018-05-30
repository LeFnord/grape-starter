FROM ruby:2.5

# stes some Environment variables
ENV NODE_ENV='production'
ENV RACK_ENV='production'


# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

ADD . /dummy
WORKDIR /dummy

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

CMD bundle exec thin start -p 9292 -e production --tag API-dummy --threaded
