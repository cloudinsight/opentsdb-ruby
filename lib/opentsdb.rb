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

require 'logger'
require 'net/http'
require 'opentsdb/version'
require 'opentsdb/client'
require 'opentsdb/faraday'
require 'opentsdb/query_parser'
require 'opentsdb/query_param'
require 'forwardable'
