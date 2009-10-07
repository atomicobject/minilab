require 'systir'
require 'minilab'

class MinilabDriver < Systir::LanguageDriver
  GOOD_DELTA = 0.12
  VALID_PORTS = [:porta, :portb, :portcl, :portch]
  VALID_PINS = (30..37).to_a + (3..10).to_a + (26..29).to_a + (22..25).to_a

  def setup
    @minilab = Minilab.build
    @minilab.connect
  end

  # Analog input methods
  0.upto(7) do |channel|
    define_method("analog_input_#{channel}_should_be_about") do |value|
      expect_read_analog(channel, value)
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
    end
  end

  # DIOx input and output methods
  0.upto(3) do |pin|
    define_method("DIO#{pin}_should_be") do |value|
      assert_equal value, @minilab.read_digital("DIO#{pin}")
    end

    define_method("write_DIO#{pin}") do |value|
      @minilab.write_digital("DIO#{pin}", value)
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

  # Other
  def minilab_revision_should_be(revision)
    assert_equal revision, @minilab.get_revision
  end

  private
  def expect_read_analog(channel, volts)
    input = @minilab.read_analog(channel)

    assert_in_delta(volts, input, GOOD_DELTA,
      "Input voltage was not ~#{volts} volts")
  end
end
