[ ![Codeship Status for LeFnord/grape-api-starter](https://codeship.com/projects/12350290-4232-0134-4db1-5a9bff506e9c/status?branch=master)](https://codeship.com/projects/168124)

# Grape API on Rack

A [Grape](http://github.com/ruby-grape/grape) API mounted on [Rack](https://github.com/rack/rack), as starting point for API development with Grape. It also includes [grape-swagger](http://github.com/ruby-grape/grape-swagger) for documentation generating.

## Why?

TODO: describe the reasons and benefits of this gem …


## Usage

#### Setup

```
$ git clone git@github.com:LeFnord/grape-api-starter.git
$ cd grape-api-starter
$ ./script/setup
```

#### Test

```
$ ./script/test
```

#### Run

```
$ ./script/server
```

or for production, set `RACK_ENV=production`
```
$ RACK_ENV=production ./script/server
```

#### Update

… dependencies
```
$ ./script/update
```

#### Stop

… would only be used, if server started in production mode
```
$ ./script/stop
```


## Rake Tasks

#### List Routes

```
rake grape:routes
```

#### OpenApi/Swagger Documentation and Validation

-> moved to [`grape-swagger` Rake Tasks](https://github.com/ruby-grape/grape-swagger#rake-tasks)


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/LeFnord/grape-api-starter.



## License

The gem is available as open source under the terms of the [MIT License](LICENSE).
