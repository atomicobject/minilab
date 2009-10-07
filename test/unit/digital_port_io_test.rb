require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"

class DigitalPortIoTest < Test::Unit::TestCase
  def setup
    @good_ports = [:porta, :portb, :portcl, :portch]

    mox = create_mocks(:minilab_hardware, :result_verifier,
                       :digital_configuration, :library_translator)
    @target = DigitalPortIo.new(mox)
  end

  # configuration tests
  should "get the list of valid ports from the configuration object" do
    ports = [:porta, "signal", 1]
    @digital_configuration.expects.get_valid_ports().returns(ports)

    assert_same ports, @target.get_valid_ports
  end

  should "use the digital configuration object to configure a port for input" do
    @digital_configuration.expects.configure_port_for_input(:porta).returns(true)
    @target.configure_input_port(:porta)
    
    @digital_configuration.expects.configure_port_for_input(:portch).returns(true)
    assert_equal true, @target.configure_input_port(:portch)
  end

  should "use the digital configuration object to configure a port for output" do
    @digital_configuration.expects.configure_port_for_output(:portb).returns(true)
    assert @target.configure_output_port(:portb)

    @digital_configuration.expects.configure_port_for_output(:portcl).returns(true)
    assert_equal true, @target.configure_output_port(:portcl)
  end

  # read tests
  should "read digital input from the digital pins" do
    pin = 1

    @library_translator.expects.get_port_for_pin(pin).returns(:porta)
    @digital_configuration.expects.is_port_configured_for_input?(:porta).returns(true)
    @library_translator.expects.get_library_pin_number(pin).returns(21)

    result = { :value => "woohoo" }
    @minilab_hardware.expects.read_digital_pin(21).returns(result)
    @result_verifier.expects.verify(result)

    assert_equal "woohoo", @target.read_digital(pin)
  end

  should "read digital input from a digital port" do
    result = { :value => 0x34 }
    @digital_configuration.expects.get_valid_ports.returns(@good_ports)
    @digital_configuration.expects.is_port_configured_for_input?(:portb).returns(true)
    @library_translator.expects.get_library_port(:portb).returns("some port")
    @minilab_hardware.expects.read_port("some port").returns(result)
    @result_verifier.expects.verify(result)

    assert_equal 0x34, @target.read_port(:portb)
  end

  should "raise an error when the configuration object says the port isn't configured for input when reading a pin" do
    @library_translator.expects.get_port_for_pin(20).returns(:portc)
    @digital_configuration.expects.is_port_configured_for_input?(:portc).returns(false)

    assert_raise (RuntimeError) { @target.read_digital(20) }
  end

  should "raise an error when the configuration objects says the port isn't configured for input when reading a port" do
    @digital_configuration.expects.get_valid_ports.returns(@good_ports)
    @digital_configuration.expects.is_port_configured_for_input?(:porta).returns(false)

    assert_raise (RuntimeError) { @target.read_port(:porta) }
  end

  should "raise an error when the port passed for read_port does not exist" do
    @good_ports.each do |port|
      result = { :value => 0x34 }
      @digital_configuration.expects.get_valid_ports.returns(@good_ports)
      @digital_configuration.expects.is_port_configured_for_input?(port).returns(true)
      @library_translator.expects.get_library_port(port).returns("some port")
      @minilab_hardware.expects.read_port("some port").returns(result)
      @result_verifier.expects.verify(result)

      assert_equal 0x34, @target.read_port(port)    
    end

   [nil, 0, false, :laptop, :portd].each do |bad_port|
      @digital_configuration.expects.get_valid_ports.returns(@good_ports)
      assert_raise(RuntimeError) { @target.read_port(bad_port) }
   end
  end

  # output tests
  should "write digital output to a digital pin" do
    pin = 2
    value = 0

    @library_translator.expects.get_port_for_pin(pin).returns(:portcl)
    @digital_configuration.expects.is_port_configured_for_output?(:portcl).returns(true)
    @library_translator.expects.get_library_pin_number(pin).returns(7)
    result = { :value => "ibm" }
    @minilab_hardware.expects.write_digital_pin(7, value).returns(result)
    @result_verifier.expects.verify(result)

    assert_equal true, @target.write_digital(pin, value)
  end
  
  should "raise an exception when the configuration object says the port is not configured for output (for write_digital)" do
    @library_translator.expects.get_port_for_pin(1).returns(:portd)
    @digital_configuration.expects.is_port_configured_for_output?(:portd).returns(false)

    assert_raise (RuntimeError) { @target.write_digital(1, 1) }
  end
end
