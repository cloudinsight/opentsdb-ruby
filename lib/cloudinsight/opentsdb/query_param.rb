module CloudInsight
  # :nodoc:
  class QueryParam
    attr_accessor :aggregator, :rate, :metric, :tags, :downsample, :interval
    attr_accessor :start_time, :end_time, :queries

    def initialize(options = {})
      @aggregator = options[:aggregator]
      @rate       = options[:rate] || false
      @metric     = options[:metric]
      @tags       = options[:tags] || {}
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
        h[:queries] = queries
      end.to_json
    end

    def tags
      @tags.each do |tagk, tagv|
        @tags[tagk] = tagv.to_a.compact.join('|') if tagv.is_a?(Array) || tagv.is_a?(Set)
      end
    end

    def downsample
      "#{interval}s-#{aggregator_for}" if interval
    end

    private

    def to_ms(time = Time.now)
      (time.to_f * 1000).to_i
    end

    def queries
      [{}.tap do |qh|
        qh[:aggregator] = aggregator
        qh[:rate]       = rate
        qh[:metric]     = metric
        qh[:tags]       = tags
        qh[:downsample] = downsample if downsample
      end]
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
