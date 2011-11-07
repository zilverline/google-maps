# require 'net/http'
require 'httpclient'
require 'uri'
require 'json'
require 'hashie/mash'

module Google
  module Maps
    
    class InvalidResponseException < Exception; end
        
    class API
      
      STATUS_OK = "OK"
      
      class << self
        def query(service, args = {})
          args[:sensor] = false
          result = Hashie::Mash.new response(url(service, args))
          raise InvalidResponseException.new("Google returned an error status: #{result.status}") if result.status != STATUS_OK
          result
        end
      
        private
        
        def response(url)
          JSON.parse(HTTPClient.new.get_content(url))
        rescue Exception => error
          raise InvalidResponseException.new("unknown error: #{error.message}")
        end
        
        def url(service, args = {})
          URI.parse("#{Google::Maps.end_point}#{Google::Maps.send(service)}/#{Google::Maps.format}#{query_string(args)}")
        end
        
        def query_string(args = {})
          '?' + args.map { |k,v| "%s=%s" % [URI.encode(k.to_s), URI.encode(v.to_s)] }.join('&') unless args.size <= 0
        end
      end
    end
    
  end
end