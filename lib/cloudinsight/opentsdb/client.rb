require_relative 'http_client'
module CloudInsight
  module Opentsdb
    # ruby client for OpenTsdb HTTP API
    class Client
      extend Forwardable

      def_instance_delegators :@http, :post

      attr_reader :host, :port, :query_options

      def initialize(options = {})
        @host = options.delete(:host) || Opentsdb.host
        @port = options.delete(:port) || Opentsdb.port
        @http = HttpClient.new
        @query_options = options
      end

      def query
        [].tap do |data|
          parse_queries.each do |query_commad|
            data << post(query_uri, query_commad.to_json)
          end
        end
      end

      def parse_queries
        [].tap do |qs|
          query_options[:q].split(';').each do |q|
            query = QueryParser.parse(q)
            query.interval   = query_options[:interval]
            query.start_time = query_options[:begin].to_i
            query.end_time   = query_options[:end].to_i
            qs << query
          end
        end
      end

      private

      def query_uri
        URI("http://#{host}:#{port}/api/query")
      end
    end
  end
end
