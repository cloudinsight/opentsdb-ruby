require 'faraday'
module Opentsdb
  # :nodoc:
  class Faraday
    attr_reader :url

    def initialize(url, options = {})
      @url = url
      @options = options
    end

    def post(body)
      connection.post do |req|
        req.headers         = headers
        req.body            = body
        req.options.timeout = 5
      end
    end

    private

    def headers
      { 'Content-Type' => 'application/json; charset=UTF-8' }
    end

    def connection
      @connection ||= begin
        ::Faraday.new(url: url) do |faraday|
          faraday.request :url_encoded        # form-encode POST params
          faraday.response :logger            # log requests to STDOUT
          faraday.adapter auto_detect_adapter
        end
      end
    end

    def auto_detect_adapter
      if defined?(::Patron)
        :partron
      elsif defined?(::Excon) && defined?(::Excon::VERSION)
        :excon
      elsif defined?(::Typhoeus)
        :typhoeus
      elsif defined?(::HTTPClient)
        :httpclient
      elsif defined?(::Net::HTTP::Persistent)
        :net_http_persistent
      else
        ::Faraday.default_adapter
      end
    end
  end
end
