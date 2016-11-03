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
        metric = parts[1]
        if parts.size == 3
          if metric.start_with?('rate')
            metric_query[:rate] = true
            metric_query[:rate_options] = parse_rate(metric) if metric.index('{')
          end
          metric = parts[2]
        end
        QueryParam.new metric_query.merge(parse_metric(metric))
      end

      private

      def parse_metric(metric)
        start_index = metric.index('{')
        return { metric: metric } unless start_index
        {}.tap do |h|
          h[:metric] = metric[0...start_index]
          end_index = metric.index('}')
          h[:tags], h[:excluding_tags] = parse_tags metric[(start_index + 1)...end_index].strip
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
        over_tags = Hash.new { |h, k| h[k] = [] }
        excluding_tags = Hash.new { |h, k| h[k] = [] }
        split_for(tags, ',').each do |tag|
          if tag =~ /!=/
            append_tags(excluding_tags, tag, '!=')
          else
            append_tags(over_tags, tag)
          end
        end
        [over_tags, excluding_tags]
      end

      def append_tags(tags, tag, token = '=')
        tagk, tagv = tag.split(token)
        return if tagk.nil? || tagv.nil?
        tags[tagk].concat tagv.split('|').uniq
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
