require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"

class AnalogIoTest < Test::Unit::TestCase
  def setup
    mox = create_mocks(:minilab_hardware, :result_verifier)
    @target = AnalogIo.new(mox)
  end

  # helpers.
  def expects_read_analog_and_result_verification(channel, value)
    result = { :value => value }
    @minilab_hardware.expects.read_analog(channel).returns(result)
    @result_verifier.expects.verify(result, "read_analog")
  end

  def expects_write_analog_and_result_verification(channel, volts)
    result = { :laptop => "heavy" }
    @minilab_hardware.expects.write_analog(channel, volts).returns(result)
    @result_verifier.expects.verify(result, "write_analog")
  end

  # Input tests
  should "read analog data" do
    expects_read_analog_and_result_verification(2, 5.7)
    assert_equal 5.7, @target.read_analog(2)

    expects_read_analog_and_result_verification(2, 0.0)
    assert_equal 0.0, @target.read_analog(2)

    expects_read_analog_and_result_verification(1, -5.2)
    assert_equal -5.2, @target.read_analog(1)
  end

  should "raise an exception when analog input channel is out of range" do
    # The minilab device has 8 analog inputs (when used in straight
    # input mode, not differential). We expects that exceptions
    # should be thrown for channels that are out of bounds.
    # We expect that the class will access the minilab hardware
    # if the channel *is* in range. Thus, we need to do this
    # in order to make the mock happy...
    8.times do |channel|
      expects_read_analog_and_result_verification(channel, 1.0)
    end

    assert_raise(RuntimeError) { @target.read_analog(-1) }
    0.upto(7) do |channel|
      assert_nothing_raised { @target.read_analog(channel) }
    end
    assert_raise(RuntimeError) { @target.read_analog(8) }
  end

  # Output tests
  should "write analog data" do
    expects_write_analog_and_result_verification(1, 4.5)
    @target.write_analog(1, 4.5)

    expects_write_analog_and_result_verification(1, 2.5)
    @target.write_analog(1, 2.5)

    expects_write_analog_and_result_verification(0, 1.3)
    @target.write_analog(0, 1.3)
  end

  should "raise an error when analog output voltage is out of range" do
    expects_write_analog_and_result_verification(0, 0.0)
    expects_write_analog_and_result_verification(0, 2.1)
    expects_write_analog_and_result_verification(0, 5.0)

    assert_raise(RuntimeError) { @target.write_analog(0, -0.1) }
    assert_nothing_raised { @target.write_analog(0, 0.0) }
    assert_nothing_raised { @target.write_analog(0, 2.1) }
    assert_nothing_raised { @target.write_analog(0, 5.0) }
    assert_raise(RuntimeError) { @target.write_analog(0, 5.1) }
  end
  
  should "raise an error when analog output channel is out of range" do
    2.times do |channel|
      expects_write_analog_and_result_verification(channel, 0.0)
    end

    assert_raise(RuntimeError) { @target.write_analog(-1, 0.0) }
    assert_nothing_raised { @target.write_analog(0, 0.0) }
    assert_nothing_raised { @target.write_analog(1, 0.0) }
    assert_raise(RuntimeError) { @target.write_analog(2, 0.0) }
  end
end
