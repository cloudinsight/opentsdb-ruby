require 'test_helper'

class TestClient < Minitest::Test
  def setup
    @res = mock('Net::HTTPResponse')
    body = read_test_json 'tsdb_res_200.json'
    @res.stubs(code: 200, body: body, class: Net::HTTPOK)
    CloudInsight::Opentsdb::Client.any_instance.stubs(:post).returns(@res)

    @params = { begin: Time.now, q: 'avg:system.load.1{host=*}', interval: 360 }
    CloudInsight::Opentsdb.reset
  end

  def test_query
    client = CloudInsight::Opentsdb::Client.new(@params)
    result = client.query
    assert_equal 1, result.size
    assert_equal 'localhost', client.host
    assert_equal 4242, client.port
  end

  def test_parse_queries
    @params[:q] = 'sum:system.load.1{host=machine};sum:system.load.15{host=test-env}'
    queries = CloudInsight::Opentsdb::Client.new(@params).parse_queries
    assert_equal 2, queries.size
    assert_equal 'sum', queries.last.aggregator
    assert_equal 'system.load.15', queries.last.metric
    assert_equal 'test-env', queries.last.tags['host']
    assert_equal '360s-avg', queries.last.downsample
  end

  def test_parse_quires_with_no_downsample
    @params.delete(:interval)
    queries = CloudInsight::Opentsdb::Client.new(@params).parse_queries
    assert_equal 1, queries.size
    refute queries.last.downsample, 'downsample should be nil'
  end

  def read_test_json(file_name)
    IO.read(File.join(File.expand_path('../fixtures', __FILE__), file_name))
  end
end
