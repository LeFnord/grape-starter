[![Codeship Status for LeFnord/grape-starter](https://app.codeship.com/projects/91e08e60-9600-0134-5571-4a8607aa1ae3/status?branch=master)](https://app.codeship.com/projects/186901)

# Grape Starter

Is a tool to help you to build up a skeleton for a [Grape](http://github.com/ruby-grape/grape) API mounted on [Rack](https://github.com/rack/rack) ready to run.
[grape-swagger](http://github.com/ruby-grape/grape-swagger) would be used to generate a  [OAPI](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md) compatible documentation.


## Usage

#### Install it
```
$ gem install grape-starter
```

#### Create a new project
```
$ grape-starter new awesome_api
```

This command creates a folder named `awesome_api` containing a ready to run [Grape](http://github.com/ruby-grape/grape) API, mounted on [Rack](https://github.com/rack/rack).

To run it, go into awesome_api folder, set it up and start the server
```
$ cd awesome_api
$ ./script/server
```
the API is now accessible under: [http://localhost:9292/api/v1/root](http://localhost:9292/api/v1/root)

More could be found [README](template/README.md)

#### Add resources
```
$ grape-starter add foo
```
to add CRUD endpoints for resource foo. For more options, see command help.

This adds endpoint and lib file and belonging specs, and a mount entry in base.rb.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/LeFnord/grape-starter.


## License

The gem is available as open source under the terms of the [MIT License](LICENSE).
