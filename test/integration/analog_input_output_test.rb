require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"
require 'integration_test'

class AnalogInputOutputTest < IntegrationTest
  def setup
    super
    build_and_connect_to_minilab
  end

  should "read analog data" do
    for_all_input_channels do |channel|
      @minilab_hardware.expects.read_analog(channel).returns(no_error_and_value(3.22))
    end

    for_all_input_channels do |channel|
      assert_equal 3.22, @minilab.read_analog(channel), "wrong value analog value read"
    end
  end

  should "write analog data" do
    for_all_output_channels do |channel|
      @minilab_hardware.expects.write_analog(channel, 1.78).returns(no_error)
    end

    for_all_output_channels do |channel|
      assert @minilab.write_analog(channel, 1.78)
    end
  end

  private
  def for_all_input_channels
    0.upto(7) do |channel|
      yield channel
    end
  end

  def for_all_output_channels
    0.upto(1) do |channel|
      yield channel
    end
  end
end
