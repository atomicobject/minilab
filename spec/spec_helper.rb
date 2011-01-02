require_relative "../lib/minilab"
require "steak"

module MinilabUnitSpecHelpers
  def create_mocks(*mox)
    mox.inject({}) do |bag, name|
      the_mock = Object.new
      self.instance_variable_set("@#{name}", mock(the_mock))
      bag[name] = the_mock
      bag
    end
  end
end

module MinilabAcceptanceSpecHelpers
  GOOD_DELTA = 0.12
  VALID_PORTS = [:porta, :portb, :portcl, :portch]
  VALID_PINS = (30..37).to_a + (3..10).to_a + (26..29).to_a + (22..25).to_a

  # Analog input methods
  0.upto(7) do |channel|
    define_method("analog_input_#{channel}_should_be_about") do |value|
      input = @minilab.read_analog(channel)
      assert_in_delta(value, input, GOOD_DELTA, "Input voltage was not ~#{value} volts")
    end

    define_method("analog_input_#{channel}_should_be_greater_than") do |value|
      volts = @minilab.read_analog(channel)
      assert volts > (value + GOOD_DELTA)
    end
  end

  # Analog output methods
  [0, 1].each do |channel|
    define_method("write_analog_#{channel}") do |value|
      @minilab.write_analog(channel, value)
      sleep 0.1
    end
  end

  # Digital pin input and output methods
  VALID_PINS.each do |pin|
    define_method("digital_pin_#{pin}_should_be") do |value|
      assert_equal value, @minilab.read_digital(pin)
    end

    define_method("write_digital_pin_#{pin}") do |value|
      @minilab.write_digital(pin, value)
    end
  end

  # Digital port read (entire bytes) methods
  VALID_PORTS.each do |port|
    define_method("digital_#{port}_should_be") do |value|
      assert_equal value, @minilab.read_digital_byte(port)
    end
  end

  # Configuration methods
  VALID_PORTS.each do |port|
    define_method("configure_#{port}_for_input") do
      @minilab.configure_input_port(port)
    end
    
    define_method("configure_#{port}_for_output") do
      @minilab.configure_output_port(port)
    end
  end
end

RSpec.configure do |config|
  # Using both to minimize the amount of porting work.
  # most assertions are still test:unit based, but some
  # (like exceptions) us rspec
  config.expect_with :stdlib, :rspec
  config.mock_framework = :rr

  config.include Minilab::MinilabConstants

  config.include MinilabUnitSpecHelpers
  config.include MinilabAcceptanceSpecHelpers, :type => :acceptance
  config.before(:all, :type => :acceptance) do
    @minilab = Minilab.build
    @minilab.connect
  end
end
