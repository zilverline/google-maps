[![Gem Version](https://badge.fury.io/rb/google-maps.svg)](http://badge.fury.io/rb/google-maps)
[![Build Status](https://travis-ci.org/zilverline/google-maps.svg?branch=master)](https://travis-ci.org/zilverline/google-maps)
[![Coverage Status](https://coveralls.io/repos/zilverline/google-maps/badge.svg?branch=master)](https://coveralls.io/r/zilverline/google-maps?branch=master)
[![Code Climate](https://codeclimate.com/repos/55671579695680044d01e0ac/badges/8f4d88f30585847e4fcf/gpa.svg)](https://codeclimate.com/repos/55671579695680044d01e0ac/feed)

Google Maps
====================

Installation
------------

`gem install google-maps`
	
Or add the following line to your Gemfile:
	 
`gem 'google-maps'`
	
Configuration
-------------

You can either authenticate with an API key or a digital signature.

API key:

```ruby
Google::Maps.configure do |config|
  config.authentication_mode = Google::Maps::Authentication::API_KEY
  config.api_key = 'xxxxxxxxxxx' 
end
```

Digital signature:

```ruby
Google::Maps.configure do |config|
  config.authentication_mode = Google::Maps::Authentication::DIGITAL_SIGNATURE
  config.client_id = 'xxxxxxxxxxx' 
  config.client_secret = 'xxxxxxxxxxx' 
end
```


Usage Examples
--------------

```ruby
  Google::Maps.distance("Science Park, Amsterdam", "Deventer")
  #=> "104 km"
  Google::Maps.duration("Science Park, Amsterdam", "Deventer")
  #=> "1 hour 12 mins"
  
  route = Google::Maps.route("Science Park, Amsterdam", "Deventer")
  route.distance.text
  #=> "104 km"
  route.duration.text
  #=> "1 hour 12 mins"
  route.distance.value
  #=> 103712
  route.duration.value
  #=> 4337
```

Testing
-------
Run all tests:

```
  rspec spec/
```

Copyright
---------
Copyright (c) 2011-2019 Zilverline.
See [LICENSE](https://github.com/zilverline/google-maps/blob/master/LICENSE.md) for details.

