<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:0 orderedList:0 -->

- [adept it to your needs](#adept-it-to-your-needs)
  - [Your awesome API](#your-awesome-api)
  - [Usage](#usage)
  - [Rake Tasks](#rake-tasks)
  - [Docker](#docker)
  - [Contributing](#contributing)
  - [License](#license)

<!-- /TOC -->

# adept it to your needs

## Your awesome API

A [Grape](http://github.com/ruby-grape/grape) API mounted on [Rack](https://github.com/rack/rack), starting point for API development with Grape. It also includes [grape-swagger](http://github.com/ruby-grape/grape-swagger) for documentation generating.


## Usage

All following commands can and should be adapted/replaced to your needs.

- [Setup](#setup)
- [Test](#test)
- [Run](#run)
- [Update](#update)
- [Stop](#stop)

#### `Setup`

```
$ ./script/setup
```

#### `Test`

```
$ ./script/test
```

#### `Run`

```
$ ./script/server *port (default: 9292)
```
and go to: [http://localhost:port/doc](http://localhost:9292/doc)
to access the OAPI documentation.

For production, set `RACK_ENV=production`
```
$ RACK_ENV=production ./script/server *port (default: 9292)
```

#### `Update`

… dependencies
```
$ ./script/update
```

#### `Stop`

… would only be used, if server started in production mode
```
$ ./script/stop
```

## Rake Tasks

- [List Routes](#list-routes)
- [OpenApi Documentation and Validation](#openapi-documentation-and-validation)

#### List Routes

```
rake routes
```

#### OpenApi Documentation and Validation

```
rake oapi:fetch
rake oapi:validate
```
comming from: [`grape-swagger` Rake Tasks](https://github.com/ruby-grape/grape-swagger#rake-tasks)

## Docker

- build: `docker build -t awesome_api .`
- run: `docker run -it -p 9292:9292 --rm awesome_api`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/name/repo.


## License

The gem is available as open source under the terms of the [MIT License](LICENSE).
