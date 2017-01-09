require 'test_helper'

class TestOpentsdb < Minitest::Test
  def setup
    Opentsdb.configure do |config|
      config.host = '127.0.0.1'
      config.port = 8090
      config.options = { timeout: 10 }
    end
  end

  def test_configuire
    assert_equal '127.0.0.1', Opentsdb.host
    assert_equal 8090, Opentsdb.port
    assert_equal 10, Opentsdb.options[:timeout]
  end
end
