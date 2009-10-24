require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"

class DigitalPortIoTest < Test::Unit::TestCase
  def setup
    mox = create_mocks(:minilab_wrapper, :digital_configuration, :library_translator)
    @target = DigitalPortIo.new(mox)
  end

  # configuration tests
  should "use the digital configuration object to configure a port for input" do
    @digital_configuration.expects.configure_port_for_input(:portch).returns(true)
    assert @target.configure_input_port(:portch)
  end

  should "use the digital configuration object to configure a port for output" do
    @digital_configuration.expects.configure_port_for_output(:portcl).returns(true)
    assert @target.configure_output_port(:portcl)
  end

  # read tests
  should "read digital input from the digital pins" do
    @library_translator.expects.get_port_for_pin(1).returns(:porta)
    @digital_configuration.expects.is_port_configured_for_input?(:porta).returns(true)
    @library_translator.expects.get_library_pin_number(1).returns(21)
    @minilab_wrapper.expects.read_digital_pin(21).returns "woohoo"

    assert_equal "woohoo", @target.read_digital(1)
  end

  should "read digital input from a digital port" do
    @digital_configuration.expects.is_port_configured_for_input?(:portb).returns(true)
    @library_translator.expects.get_library_port(:portb).returns("some port")
    @minilab_wrapper.expects.read_port("some port").returns 0x34

    assert_equal 0x34, @target.read_port(:portb)
  end

  should "raise an error when the configuration object says the port isn't configured for input when reading a pin" do
    @library_translator.expects.get_port_for_pin(20).returns(:portc)
    @digital_configuration.expects.is_port_configured_for_input?(:portc).returns(false)

    assert_raise (RuntimeError) { @target.read_digital(20) }
  end

  should "raise an error when the configuration objects says the port isn't configured for input when reading a port" do
    @digital_configuration.expects.is_port_configured_for_input?(:porta).returns(false)

    assert_raise (RuntimeError) { @target.read_port(:porta) }
  end

  # output tests
  should "write digital output to a digital pin" do
    @library_translator.expects.get_port_for_pin(2).returns(:portcl)
    @digital_configuration.expects.is_port_configured_for_output?(:portcl).returns(true)
    @library_translator.expects.get_library_pin_number(2).returns(7)
    @minilab_wrapper.expects.write_digital_pin(7, 0).returns "ibm"

    assert_equal true, @target.write_digital(2, 0)
  end
  
  should "raise an error when the configuration object says the port is not configured for output (for write_digital)" do
    @library_translator.expects.get_port_for_pin(1).returns(:portd)
    @digital_configuration.expects.is_port_configured_for_output?(:portd).returns(false)

    assert_raise (RuntimeError) { @target.write_digital(1, 1) }
  end
end
