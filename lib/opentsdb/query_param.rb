module Opentsdb
  # :nodoc:
  class QueryParam
    attr_accessor :aggregator, :rate, :metric, :tags, :interval, :downsample, :rate_options, :group
    attr_accessor :start_time, :end_time

    def initialize(options = {})
      @aggregator   = options[:aggregator]
      @rate         = options[:rate] || false
      @metric       = options[:metric]
      @tags         = options[:tags] || {}
      @rate_options = options[:rate_options]
      @group        = options[:group] || []
      @start_time   = 0
      @end_time     = 0
    end

    def start_time
      @start_time > 0 ? to_ms(@start_time) : (end_time - 3_600_000) # 1 hour ago
    end

    def end_time
      @end_time > 0 ? to_ms(@end_time) : to_ms(Time.now)
    end

    def to_json
      {}.tap do |h|
        h[:start]   = start_time
        h[:end]     = end_time
        h[:queries] = [queries]
      end.to_json
    end

    def to_query_tags
      {}.tap do |qtags|
        tags.each do |tagk, tagv|
          qtags[tagk] = tagv.to_a.compact.join('|') if tagv.is_a?(Array) || tagv.is_a?(Set)
          qtags[tagk] = '*' if tagv.nil? || tagv.empty?
        end
      end
    end

    def downsample
      "#{interval}s-#{aggregator_for}" if interval
    end

    private

    def to_ms(time = Time.now)
      time = time.is_a?(Fixnum) ? time : time.to_i
      time.to_s.ljust(13, '0').to_i # ms.to_size == 13
    end

    def queries
      {}.tap do |qh|
        qh[:aggregator] = aggregator
        qh[:rate]       = rate
        qh[:metric]     = metric
        qh[:tags]       = to_query_tags
        qh[:downsample] = downsample if downsample
      end
    end

    def aggregator_for
      case aggregator
      when 'sum', 'avg' then 'avg'
      when 'min'        then 'mimmin'
      when 'max'        then 'mimmax'
      else 'avg'
      end
    end
  end
end
