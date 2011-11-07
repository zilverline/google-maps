require 'net/http'
require 'uri'
require 'json'
require 'hashie/mash'

module Google
  module Maps
    
    class InvalidResponseException < Exception; end
        
    class API
      
      STATUS_OK = "OK"
      
      class << self
        def query(args = {})
          args[:sensor] = false
          result = Hashie::Mash.new response(url(args))
          raise InvalidResponseException.new("Google returned an error status: #{result.status}") if result.status != STATUS_OK
          result
        end
      
        private
        
        def response(url)
          response = Net::HTTP.get_response(url)
          response.error! unless response.kind_of?(Net::HTTPSuccess)
          JSON.parse(response.body)
        rescue Net::HTTPServerException => error
          raise InvalidResponseException.new(error.message)
        rescue Exception => error
          raise InvalidResponseException.new("unknown error: #{error.message}")
        end
        
        def url(args = {})
          URI.parse("#{Google::Maps.end_point}#{query_string(args)}")
        end
        
        def query_string(args = {})
          '?' + args.map { |k,v| "%s=%s" % [URI.encode(k.to_s), URI.encode(v.to_s)] }.join('&') unless args.size <= 0
        end
      end
    end
    
  end
end