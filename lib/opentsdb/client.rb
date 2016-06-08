module Opentsdb
  # ruby client for OpenTsdb HTTP API
  class Client
    extend Forwardable

    def_instance_delegators :@faraday, :post

    attr_reader :host, :port
    attr_accessor :query_commads

    def initialize(options = {})
      @host = options.delete(:host) || Opentsdb.host
      @port = options.delete(:port) || Opentsdb.port
      @faraday = Opentsdb::Faraday.new(query_url)
      @query_commads = parse_queries options
    end

    def query
      [].tap do |results|
        query_commads.each do |query_commad|
          res = post query_commad.to_json
          status = res.status.to_i == 200 ? 'ok' : 'error'
          results << { status: status, condition: query_commad, result: res.body }
        end
      end
    end

    def parse_queries(query_options = {})
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

    def query_url
      "http://#{host}:#{port}/api/query"
    end
  end
end
