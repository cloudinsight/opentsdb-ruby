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
    assert_equal 'machine|test-env', query.tags['host']
  end
end
