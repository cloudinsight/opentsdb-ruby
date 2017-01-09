require 'test_helper'

class TestFarday < Minitest::Test
  def setup
    @options = { timeout: 10, open_timeout: 4 }
    faraday = ::Faraday::Connection.new do |builder|
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post('/') { |_| [200, {}, 'query data'] }
      end
    end
    Opentsdb::Faraday.any_instance.stubs(:connection).returns(faraday)
  end

  def test_post
    @faraday = Opentsdb::Faraday.new 'http://test.com', @options
    resp = @faraday.post('body')
    assert_equal 'query data', resp.body
    assert_equal 10, resp.env.request.timeout
    assert_equal 4, resp.env.request.open_timeout
  end
end
