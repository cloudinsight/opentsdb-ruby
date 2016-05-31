require 'test_helper'

class TestQueryParam < Minitest::Test
  def setup
    @params = { begin: Time.now, q: 'avg:system.load.1{host=*}', interval: 720 }
  end

  def test_query_time
    qparam = Opentsdb::QueryParam.new
    refute qparam.start_time.nil?
    refute qparam.end_time.nil?
    duration = qparam.end_time - qparam.start_time
    assert (duration < 3_610_000), 'should be smaller 1 hour ms'
  end

  def test_query_time_with_fixnum_time
    qparam = Opentsdb::QueryParam.new
    qparam.end_time = 1_464_624_000_00
    assert_equal 1_464_624_000_000, qparam.end_time
  end
end
