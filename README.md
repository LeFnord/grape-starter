[![Build Status](https://travis-ci.org/LeFnord/grape-api-starter.svg?branch=master)](https://travis-ci.org/LeFnord/grape-api-starter)

# Grape API on Rack

A [Grape](http://github.com/ruby-grape/grape) API mounted on [Rack](https://github.com/rack/rack), as starting point for API development with Grape. It also includes [grape-swagger](http://github.com/ruby-grape/grape-swagger) for documentation generating.

## Run

```
$ bundle install
$ rackup
Thin web server (v1.7.0 codename Dunder Mifflin)
Maximum connections set to 1024
Listening on localhost:9292, CTRL+C to stop
```

## Rake Tasks

### List Routes

```
rake grape:routes
```

### OpenApi/Swagger Documentation

```
rake grape:swagger
rake grape:swagger store=true # writes to swagger_doc.json
```
