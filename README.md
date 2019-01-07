[![Gem Version](https://badge.fury.io/rb/google-maps.svg)](http://badge.fury.io/rb/google-maps)
[![Build Status](https://travis-ci.org/zilverline/google-maps.svg?branch=master)](https://travis-ci.org/zilverline/google-maps)
[![Coverage Status](https://coveralls.io/repos/zilverline/google-maps/badge.svg?branch=master)](https://coveralls.io/r/zilverline/google-maps?branch=master)
[![Code Climate](https://codeclimate.com/repos/55671579695680044d01e0ac/badges/8f4d88f30585847e4fcf/gpa.svg)](https://codeclimate.com/repos/55671579695680044d01e0ac/feed)

# Google Maps

## Installation

`gem install google-maps`

Or add the following line to your Gemfile:

`gem 'google-maps'`

## Configuration

You can either authenticate with an API key or a digital signature.

API key:

```ruby
Google::Maps.configure do |config|
  config.authentication_mode = Google::Maps::Configuration::API_KEY
  config.api_key = 'xxxxxxxxxxx'
end
```

Digital signature:

```ruby
Google::Maps.configure do |config|
  config.authentication_mode = Google::Maps::Configuration::DIGITAL_SIGNATURE
  config.client_id = 'xxxxxxxxxxx'
  config.client_secret = 'xxxxxxxxxxx'
end
```

### Default language

Set the default language.

```ruby
Google::Maps.configure do |config|
  config.default_language = :nl #dutch
end
```

## Usage Examples

### Distance

```ruby
  Google::Maps.distance("Science Park, Amsterdam", "Deventer")
  #=> "105 km"
  Google::Maps.distance("52.3545543,4.9519029", "Deventer")
  #=> "105 km"
```

### Duration

```ruby
  Google::Maps.duration("Science Park, Amsterdam", "Deventer")
  #=> "1 hour 12 mins"
  Google::Maps.duration("52.3545543,4.9519029", "Deventer")
  #=> "1 hour 12 mins"
```

### Route

```ruby
 route = Google::Maps.route("Science Park, Amsterdam", "Deventer")
 route = Google::Maps.route("52.3545543,4.9519029", "Deventer")
 route.distance.text
 #=> "104 km"
 route.duration.text
 #=> "1 hour 12 mins"
 route.distance.value
 #=> 103712
 route.duration.value
 #=> 4337
 route.steps
 #=> [
   {
            "distance" => {
      "text" => "0,1 km",
     "value" => 125
   },
            "duration" => {
      "text" => "1 min.",
     "value" => 35
   },
        "end_location" => {
     "lat" => 52.3556768,
     "lng" => 4.9545739
   },
   "html_instructions" => "Rijd <b>naar het noordwesten</b>, richting het <b>Science Park</b>",
            "polyline" => {
     "points" => "oqp~Hqpf]?@?@?@KNOVEHA@A?s@wAQ]Q_@We@?A?ADI"
   },
      "start_location" => {
     "lat" => 52.3549602,
     "lng" => 4.9538473
   },
         "travel_mode" => "DRIVING"
 },
 {
            "distance" => {
      "text" => "37 m",
      ........

```

### Options

The distance, duration and route methods allow you to pass an options hash to the Directions API.
All options can also be set as default_params for these services.

```ruby
Google::Maps.configure do |config|
  ...
  config.default_params = {
    directions_service: {
      mode: 'transit',
      transit_routing_preference: 'fewer_transfers'
    }
  }
  ...
end

```

The following options are permitted:

```ruby
{
  mode: 'driving', #default
  transit_mode: 'train', #only used when mode is set to 'transit'
  transit_routing_preference: 'fewer_transfers',
  avoid: 'tolls',
  arrival_time: 1545397430, # In seconds since midnight, January 1, 1970 UTC.
  departure_time: 1545397430, # Cannot be in the past.
}

# NB! You can specify either departure_time or arrival_time, but not both.
TRAVEL_MODES = [
  'driving', #(Default) indicates standard driving directions using the road network.
  'bicycling', #requests bicycling directions via bicycle paths & preferred streets.
  'transit', #requests directions via public transit routes.
  'walking'
]

TRANSIT_MODES = [
  'bus',
  'subway',
  'train',
  'tram',
  'rail' # This is equivalent to transit_mode=train|tram|subway
]

TRANSIT_ROUTING_PREFERENCES = [
  'less_walking', prefer limited amounts of walking.
  'fewer_transfers' prefer a limited number of transfers.
]

AVOID = [
  'tolls',
  'highways',
  'ferries',
  'indoor', # Avoid indoor steps for walking and transit directions.
]

```

### Places

```ruby
 places = Google::Maps.places('Amsterdam')
 places.first.text
 #=> "Amsterdam, Nederland"
 places.first.place_id
 #=> "ChIJVXealLU_xkcRja_At0z9AGY"

 place = Google::Maps.place("ChIJVXealLU_xkcRja_At0z9AGY")

 place.latitude
 #=> "52.3679843"

 place.longitude
 #=> "4.9035614"

 place.address
 #=> "Amsterdam, Nederland"
```

### Geocode

```ruby
  geocodes = Google::Maps.geocode("Science Park, Amsterdam")
  geocodes.first.address = "Science Park, 1012 WX Amsterdam, Nederland"
  geocodes.first.latitude = 52.3545543
  geocodes.first.longitude = 4.9540916
```

## Testing

Run all tests:

```
  rspec spec/
```

## Copyright

Copyright (c) 2011-2019 Zilverline.
See [LICENSE](https://github.com/zilverline/google-maps/blob/master/LICENSE.md) for details.
