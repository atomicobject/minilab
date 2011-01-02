require_relative "../spec_helper.rb"

describe ConnectionState do
  def setup
    @target = ConnectionState.new
  end

  it "default to an unconnected state" do
    assert_equal false, subject.connected?
  end

  it "allow the connection state to be changed" do
    subject.connected = true
    assert_equal true, subject.connected?
    subject.connected = false
    assert_equal false, subject.connected?
  end
end
