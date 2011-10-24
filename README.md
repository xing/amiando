# amiando

This is a gem to access the amiando REST API. You can check the original
documentation here:

http://developers.amiando.com/index.php/REST_API

## Basic usage

The gem has been implemented with the idea that requests can be done in
parallel using [Typhoeus](https://github.com/dbalatero/typhoeus).

You can query multiple requests and run then like this:

```ruby
albert = Amiando::User.find(1234)
jorge  = Amiando::User.find(5678)

Amiando.run
```

Both requests will happen in parallel.

All attributes should be used in snake_case format instead of the CamelCase
used in the official documentation. For example, for a user, you should call
first_name instead of firstName.