module Opentsdb
  # :nodoc:
  class QueryRateOptions
    attr_accessor :counter, :counter_max, :reset_value

    def initialize(counter, counter_max, reset_value)
      @counter = counter
      @counter_max = counter_max
      @reset_value = reset_value
    end

    def self.default
      new(false, 9_999_999_999, 0)
    end
  end
end
