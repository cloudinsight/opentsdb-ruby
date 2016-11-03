require 'test_helper'

class TestQueryParser < Minitest::Test
  def setup
    @params = { begin: Time.now, q: 'avg:system.load.1{host=*}', interval: 720 }
  end

  def test_parse
    q = 'avg:system.load.1'
    query = Opentsdb::QueryParser.parse(q)
    assert_equal 'avg', query.aggregator
    assert_equal 'system.load.1', query.metric
    assert query.tags.empty?
  end

  def test_parse_with_tags
    q = 'sum:system.load.15{host=machine,k1=v1,host=test-env} by {}'
    query = Opentsdb::QueryParser.parse(q)
    assert_equal 'sum', query.aggregator
    assert_equal 'system.load.15', query.metric
    assert_equal %w(machine test-env), query.tags['host']
    assert_equal 'machine|test-env', query.to_query_tags['host']
  end

  def test_parse_with_excluding_tags
    q = 'sum:system.load.15{host=machine,k1!=v1,host!=test-env} by {}'
    query = Opentsdb::QueryParser.parse(q)
    assert_equal 'sum', query.aggregator
    assert_equal 'system.load.15', query.metric
    assert_equal %w(machine), query.tags['host']
    assert_equal %w(v1 test-env), query.excluding_tags.values.flatten
    assert_equal 'machine', query.to_query_tags['host']
  end

  def test_parse_with_any_value
    q = 'avg:system.disk.total{host=machine}by{device_name}'
    query = Opentsdb::QueryParser.parse(q)
    assert_equal 'avg', query.aggregator
    assert_equal 'system.disk.total', query.metric
    assert_equal %w(machine), query.tags['host']
    assert_equal '*', query.to_query_tags['device_name']
  end
end
