# require 'net/http'
require 'httpclient'
require 'uri'
require 'json'
require 'hashie/mash'
require 'base64'
require 'hmac'
require 'hmac-sha1'

module Google
  module Maps
    
    class InvalidResponseException < StandardError; end
    class InvalidPremierConfigurationException < StandardError; end
    class ZeroResultsException < InvalidResponseException; end
        
    class API
      
      STATUS_OK = "OK".freeze
      STATUS_ZERO_RESULTS = "ZERO_RESULTS".freeze

      class << self
        def query(service, args = {})
          default_args = {sensor:  false, use_premier_signing: !Google::Maps.premier_client_id.nil?}
          args = default_args.merge(args)
          args = args.merge(Google::Maps.default_params[service]) if Google::Maps.default_params[service]
          use_premier_signing = args.delete :use_premier_signing
          args[:client] = Google::Maps.premier_client_id if use_premier_signing

          url = url(service, args)
          url = premier_signing(url) if use_premier_signing
          result = Hashie::Mash.new response(url)
          raise ZeroResultsException.new("Google did not return any results: #{result.status}") if result.status == STATUS_ZERO_RESULTS
          raise InvalidResponseException.new("Google returned an error status: #{result.status}") if result.status != STATUS_OK
          result
        end
      
        private
        
        def decode_url_safe_base_64(value)
          Base64.decode64(value.tr('-_','+/'))
        end

        def encode_url_safe_base_64(value)
          Base64.encode64(value).tr('+/','-_')
        end

        def premier_signing(url)
          raise InvalidPremierConfigurationException.new("No private key set, set Google::Maps.premier_key") if Google::Maps.premier_key.nil?
          
          parsed_url = url.is_a?(URI) ? url : URI.parse(url)
          url_to_sign = parsed_url.path + '?' + parsed_url.query

          # Decode the private key
          raw_key = decode_url_safe_base_64(Google::Maps.premier_key)

          # create a signature using the private key and the URL
          sha1 = HMAC::SHA1.new(raw_key)
          sha1 << url_to_sign
          raw_sig = sha1.digest

          # encode the signature into base64 for url use form.
          signature =  encode_url_safe_base_64(raw_sig)

          # prepend the server and append the signature.
          "#{parsed_url.scheme}://#{parsed_url.host}#{url_to_sign}&signature=#{signature}".strip
        end
        
        def response(url)
          JSON.parse(HTTPClient.new.get_content(url))
        rescue Exception => error
          Google::Maps.logger.error "#{error.message}"
          raise InvalidResponseException.new("unknown error: #{error.message}")
        end
        
        def url(service, args = {})
          url = URI.parse("#{Google::Maps.end_point}#{Google::Maps.send(service)}/#{Google::Maps.format}#{query_string(args)}")
          Google::Maps.logger.debug("url before possible signing: #{url}")
          url.to_s
        end
        
        def query_string(args = {})
          '?' + args.map { |k,v| "%s=%s" % [URI.encode(k.to_s), URI.encode(v.to_s)] }.join('&') unless args.size <= 0
        end
      end
    end
    
  end
end