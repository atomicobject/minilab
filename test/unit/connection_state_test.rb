require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"

class ConnectionStateTest < Test::Unit::TestCase
  def setup
    @target = ConnectionState.new
  end

  should "default to an unconnected state" do
    assert_equal false, @target.connected?
  end

  should "allow the connection state to be changed" do
    @target.connected = true
    assert_equal true, @target.connected?
    @target.connected = false
    assert_equal false, @target.connected?
  end
end
