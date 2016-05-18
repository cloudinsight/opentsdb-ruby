require 'net/http'
require 'benchmark'
module CloudInsight
  module Opentsdb
    # :nodoc:
    class HttpClient
      def post(uri, body)
        send_http(uri) do |http|
          req = Net::HTTP::Post.new(uri, headers)
          Opentsdb.logger.debug "Http post body: #{body}"
          req.body = body
          http.request(req)
        end
      end

      private

      def headers
        { 'Content-Type' => 'application/json; charset=UTF-8' }
      end

      def send_http(uri)
        Opentsdb.logger.info "Http request uri: #{uri}"
        http = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https')
        res = nil
        time = Benchmark.realtime do
          res = yield(http)
        end
        Opentsdb.logger.info "Response: #{res.code} consume: #{time} s"
        res
      rescue Timeout::Error, Errno::ECONNRESET, Net::HTTPBadResponse,
             Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        Opentsdb.logger.error "Http request error: #{e}"
        false
      end
    end
  end
end
