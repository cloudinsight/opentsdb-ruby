require 'test_helper'

class TestClient < Minitest::Test
  def setup
    @res = mock('Net::HTTPResponse')
    @body = read_test_json 'tsdb_res_200.json'
    @res.stubs(code: 200, body: @body, class: Net::HTTPOK)
    Opentsdb::Client.any_instance.stubs(:post).returns(@res)

    @params = { begin: Time.now, q: 'avg:system.load.1{host=*}', interval: 360 }
    Opentsdb.reset
  end

  def test_query
    client = Opentsdb::Client.new @params
    result = client.query
    assert_equal 1, result.size
    assert_equal 'localhost', client.host
    assert_equal 4242, client.port
    assert_equal [:status, :condition, :result], result.last.keys
    assert_equal @body, result.last[:result]
  end

  def test_parse_queries
    @params[:q] = 'sum:system.load.1{host=machine, host=machine2};sum:system.load.15{host=test-env}'
    client = Opentsdb::Client.new(@params)
    query_commads = client.query_commads
    assert_equal 2, query_commads.size
    assert_equal %w(machine machine2), query_commads.first.tags['host']
    assert_equal 'sum', query_commads.last.aggregator
    assert_equal 'system.load.15', query_commads.last.metric
    assert_equal %w(test-env), query_commads.last.tags['host']
    assert_equal '360s-avg', query_commads.last.downsample
  end

  def test_parse_quires_with_no_downsample
    @params.delete(:interval)
    query_commads = Opentsdb::Client.new(@params).query_commads
    assert_equal 1, query_commads.size
    refute query_commads.last.downsample, 'downsample should be nil'
  end

  def read_test_json(file_name)
    IO.read(File.join(File.expand_path('../fixtures', __FILE__), file_name))
  end
end
