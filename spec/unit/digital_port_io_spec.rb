require_relative "../spec_helper"

describe Minilab::DigitalPortIo do
  before { @mox =create_mocks(:minilab_wrapper, :digital_configuration, :library_translator) }
  subject { described_class.new(@mox) }

  # configuration tests
  it "use the digital configuration object to configure a port for input" do
    @digital_configuration.configure_port_for_input(:portch).returns(true)
    assert subject.configure_input_port(:portch)
  end

  it "use the digital configuration object to configure a port for output" do
    @digital_configuration.configure_port_for_output(:portcl).returns(true)
    assert subject.configure_output_port(:portcl)
  end

  # read tests
  it "read digital input from the digital pins" do
    @library_translator.get_port_for_pin(1).returns(:porta)
    @digital_configuration.is_port_configured_for_input?(:porta).returns(true)
    @library_translator.get_library_pin_number(1).returns(21)
    @minilab_wrapper.read_digital_pin(21).returns "woohoo"

    assert_equal "woohoo", subject.read_digital(1)
  end

  it "read digital input from a digital port" do
    @digital_configuration.is_port_configured_for_input?(:portb).returns(true)
    @library_translator.get_library_port(:portb).returns("some port")
    @minilab_wrapper.read_port("some port").returns 0x34

    assert_equal 0x34, subject.read_port(:portb)
  end

  it "raise an error when the configuration object says the port isn't configured for input when reading a pin" do
    @library_translator.get_port_for_pin(20).returns(:portc)
    @digital_configuration.is_port_configured_for_input?(:portc).returns(false)

    assert_raise (RuntimeError) { subject.read_digital(20) }
  end

  it "raise an error when the configuration objects says the port isn't configured for input when reading a port" do
    @digital_configuration.is_port_configured_for_input?(:porta).returns(false)

    assert_raise (RuntimeError) { subject.read_port(:porta) }
  end

  # output tests
  it "write digital output to a digital pin" do
    @library_translator.get_port_for_pin(2).returns(:portcl)
    @digital_configuration.is_port_configured_for_output?(:portcl).returns(true)
    @library_translator.get_library_pin_number(2).returns(7)
    @minilab_wrapper.write_digital_pin(7, 0).returns "ibm"

    assert_equal true, subject.write_digital(2, 0)
  end
  
  it "raise an error when the configuration object says the port is not configured for output (for write_digital)" do
    @library_translator.get_port_for_pin(1).returns(:portd)
    @digital_configuration.is_port_configured_for_output?(:portd).returns(false)

    assert_raise (RuntimeError) { subject.write_digital(1, 1) }
  end
end
