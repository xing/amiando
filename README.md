# amiando [![Build Status](https://secure.travis-ci.org/xing/amiando.png)](http://travis-ci.org/xing/amiando)

This is a gem to access the amiando REST API. You can check the original
documentation here:

http://developers.amiando.com/index.php/REST_API

## Basic usage

The gem has been implemented with the idea that requests can be done in
parallel using [Typhoeus](https://github.com/dbalatero/typhoeus).

You can query multiple requests and run then like this:

    albert = Amiando::User.find(1234)
    jorge  = Amiando::User.find(5678)

    Amiando.run

Both requests will happen in parallel.

You can also do synchronous requests by prepending 'sync_' to the method name:

    albert = Amiando::User.sync_find(1234)

### Note

All attributes should be used in snake_case format instead of the CamelCase
used in the official documentation. For example, for a user, you should call
first_name instead of firstName.

## Documentation

The full amiando API isn't fully implemented yet, however you can find here the
ones currently available.

* [ApiKey](http://rdoc.info/github/xing/amiando/master/Amiando/ApiKeyt)
* Partner
* [User](http://rdoc.info/github/xing/amiando/master/Amiando/User) (some methods
  still missing)
* [Event](http://rdoc.info/github/xing/amiando/master/Amiando/Event)
* [TicketShop](http://rdoc.info/github/xing/amiando/master/Amiando/TicketShop)
* Ticket
* [TicketCategory](http://rdoc.info/github/xing/amiando/master/Amiando/TicketCategory)
* Payment
* [PaymentType](http://rdoc.info/github/xing/amiando/master/Amiando/PaymentType)
* Data Synchronization
* Email
