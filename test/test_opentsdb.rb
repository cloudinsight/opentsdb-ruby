require 'test_helper'

class TestOpentsdb < Minitest::Test
  def setup
    Opentsdb.configure do |config|
      config.host = '127.0.0.1'
      config.port = 8090
    end
  end

  def test_configuire
    assert_equal '127.0.0.1', Opentsdb.host
    assert_equal 8090, Opentsdb.port
  end
end
