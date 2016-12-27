# adept it to your needs

## Your awesome API

A [Grape](http://github.com/ruby-grape/grape) API mounted on [Rack](https://github.com/rack/rack), starting point for API development with Grape. It also includes [grape-swagger](http://github.com/ruby-grape/grape-swagger) for documentation generating.


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
$ ./script/server *port (default: 9292)
```
and go to: [http://localhost:port/](http://localhost:9292/)
to access the OAPI documentation.

For production, set `RACK_ENV=production`
```
$ RACK_ENV=production ./script/server *port (default: 9292)
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
rake routes
```

#### OpenApi Documentation and Validation

```
rake oapi:fetch
rake oapi:validate
```
comming from: [`grape-swagger` Rake Tasks](https://github.com/ruby-grape/grape-swagger#rake-tasks)


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/name/repo.


## License

The gem is available as open source under the terms of the [MIT License](LICENSE).
