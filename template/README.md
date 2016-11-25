# Grape API on Rack

A [Grape](http://github.com/ruby-grape/grape) API mounted on [Rack](https://github.com/rack/rack), as starting point for API development with Grape. It also includes [grape-swagger](http://github.com/ruby-grape/grape-swagger) for documentation generating.

## Why?

TODO: describe the reasons and benefits of this gem …


## Usage

#### Setup

```
$ git clone git@github.com:LeFnord/grape-starter.git
$ cd grape-starter
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

#### OpenApi Documentation and Validation

-> see [`grape-swagger` Rake Tasks](https://github.com/ruby-grape/grape-swagger#rake-tasks)


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/<name>/<repo>.


## License

The gem is available as open source under the terms of the [MIT License](LICENSE).
