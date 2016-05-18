require 'test_helper'

class TestOpentsdb < Minitest::Test
  def setup
    CloudInsight::Opentsdb.configure do |config|
      config.host = 'http://127.0.0.1'
      config.port = 8090
    end
  end

  def test_configuire
    assert_equal 'http://127.0.0.1', CloudInsight::Opentsdb.host
    assert_equal 8090, CloudInsight::Opentsdb.port
  end
end
