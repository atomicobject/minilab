require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"

class AnalogIoTest < Test::Unit::TestCase
  def setup
    mox = create_mocks(:minilab_wrapper)
    @target = AnalogIo.new(mox)
  end

  should "read analog data" do
    @minilab_wrapper.expects.read_analog(2).returns 5.7
    assert_equal 5.7, @target.read_analog(2)
  end

  should "raise an exception when analog input channel is out of range" do
    # The minilab device has 8 analog inputs (when used in straight
    # input mode, not differential). We expect that exceptions
    # should be thrown for channels that are out of bounds.
    assert_raise(RuntimeError) { @target.read_analog(-1) }
    0.upto(7) do |channel|
      @minilab_wrapper.expects.read_analog(channel).returns(1.0)
      assert_nothing_raised { @target.read_analog(channel) }
    end
    assert_raise(RuntimeError) { @target.read_analog(8) }
  end

  should "write analog data" do
    @minilab_wrapper.expects.write_analog(1, 4.5)
    @target.write_analog(1, 4.5)
  end

  should "raise an error when analog output voltage is out of range" do
    assert_raise(RuntimeError) { @target.write_analog(0, -0.1) }

    @minilab_wrapper.expects.write_analog(0, 0.0)
    @minilab_wrapper.expects.write_analog(0, 2.1)
    @minilab_wrapper.expects.write_analog(0, 5.0)
    assert_nothing_raised { @target.write_analog(0, 0.0) }
    assert_nothing_raised { @target.write_analog(0, 2.1) }
    assert_nothing_raised { @target.write_analog(0, 5.0) }

    assert_raise(RuntimeError) { @target.write_analog(0, 5.1) }
  end
  
  should "raise an error when analog output channel is out of range" do
    assert_raise(RuntimeError) { @target.write_analog(-1, 0.0) }

    @minilab_wrapper.expects.write_analog(0, 0.0)
    @minilab_wrapper.expects.write_analog(1, 0.0)
    assert_nothing_raised { @target.write_analog(0, 0.0) }
    assert_nothing_raised { @target.write_analog(1, 0.0) }

    assert_raise(RuntimeError) { @target.write_analog(2, 0.0) }
  end
end
