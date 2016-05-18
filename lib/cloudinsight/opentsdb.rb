module CloudInsight
  # :nodoc:
  module Opentsdb
    #:nodoc:
    class << self
      attr_accessor :host, :port

      def configure
        yield self
      end

      def host
        @host || 'localhost'
      end

      def port
        @port || 4242
      end

      def reset
        @host = nil
        @port = nil
      end

      def logger
        @logger ||= begin
          Logger.new(STDOUT).tap { |logger| logger.datetime_format = '%Y-%m-%d %H:%M:%S' }
        end
      end
    end
  end
end
require 'logger'
require 'net/http'
require 'cloudinsight/opentsdb/version'
require 'cloudinsight/opentsdb/client'
require 'cloudinsight/opentsdb/query_parser'
require 'cloudinsight/opentsdb/query_param'
require 'cloudinsight/opentsdb/railtie' if defined?(::Rails)
require 'forwardable'
