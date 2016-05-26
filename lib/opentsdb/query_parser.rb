module Opentsdb
  # :nodoc:
  class QueryParser
    class << self
      def parse(q_string)
        parts = split_for(q_string, ':')
        return nil if parts.size < 2 || parts.size > 3
        metric_query = {}
        metric_query[:aggregator] = parts[0]
        metric_query[:rate] = false
        metic = parts[1]
        if parts.size == 3
          if metic.start_with?('rate')
            metric_query[:rate] = true
            metric_query[:rate_options] = parse_rate(metic) if temp.index('{')
          end
          metic = parts[2]
        end
        QueryParam.new metric_query.merge(parse_metric(metic))
      end

      private

      def parse_metric(metric)
        start_index = metric.index('{')
        return { metric: metric } unless start_index
        {}.tap do |h|
          h[:metric] = metric[0...start_index]
          end_index = metric.index('}')
          h[:tags] = parse_tags metric[(start_index + 1)...end_index].strip
          groups_str = metric[(end_index + 1)..-1]
          if groups_str.size > 5 # length of by{} is 4
            h[:group] = parse_groups groups_str
            h[:group].each { |group| h[:tags][group] ||= ['*'] }
          end
        end
      end

      def parse_rate(spec)
        return QueryRateOptions.default if spec.size == 4
        raise QueryErrors::InvalidRateOptionError, "invalid specification: #{spec}" if spec.size < 6
        parts = split_for(spec[5..-1], ',')
        if parts.empty? || parts.size > 3
          raise QueryErrors::InvalidRateOptionError, "Incrrenct numbers of values: #{spec}"
        end
        is_counter = parts[0] == 'counter'
        max = parts[1].nil? ? 9_999_999_999 : parts[1].to_i
        reset = parts[2].nil? ? 0 : parts[2].to_i
        QueryRateOptions.new is_counter, max, reset
      end

      def parse_tags(tags)
        return if tags.nil?
        Hash.new { |h, k| h[k] = [] }.tap do |rtags|
          split_for(tags, ',').each do |tag|
            tagk, tagv = split_for(tag, '=')
            next if tagk.nil? || tagv.nil?
            rtags[tagk] ||= []
            rtags[tagk].concat tagv.split('|').uniq
          end
        end
      end

      def parse_groups(groups_str)
        start_index = groups_str.index('{')
        end_index = groups_str.index('}')
        groups = groups_str[(start_index + 1)...end_index].strip
        return [] if groups.empty?
        split_for(groups, ',').map(&:strip)
      end

      def split_for(string, token = ':')
        result = []
        index = start = pos = 0
        is_in_bracket = false
        string.each_char do |char|
          if char == '{'
            is_in_bracket = true
          elsif char == '}'
            is_in_bracket = false
          elsif char == token && !is_in_bracket
            result[index] = string[start...pos]
            index += 1
            start = pos + 1
          end
          pos += 1
        end
        result[index] = string[start...pos]
        result.map(&:strip)
      end
    end
  end
end
