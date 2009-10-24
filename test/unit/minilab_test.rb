require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"

class MinilabTest < Test::Unit::TestCase
  include MinilabConstants

  def setup
    mox = create_mocks(:minilab_wrapper, :analog_io, :digital_auxport_io, :digital_port_io, :connection_state)
    @minilab = Minilab.new(mox)
  end

  should "allow the user to easily build the minilab object and its dependences" do
    minilab = nil

    assert_nothing_raised "should build without error" do
      minilab = Minilab.build
    end

    assert_not_nil minilab, "should have gotten an object"
    assert_kind_of Minilab, minilab, "should have gotten a Minilab instance"
  end

  should "connect to the hardware, setup the error handling, declare the library revision, and setup the db37 ports for input" do
    @minilab_wrapper.expects.setup_error_handling(DONTPRINT, STOPALL)
    @minilab_wrapper.expects.declare_revision(CURRENTREVNUM)
    @connection_state.expects.connected=(true)

    DigitalConfiguration::PORTS.each do |port|
      @connection_state.expects.connected?.returns true
      @digital_port_io.expects.configure_input_port(port)
    end

    @minilab.connect
  end

  should "bomb out if trying to use a method but haven't connected yet" do
    assert_not_connected_error { @minilab.read_analog(0) }
    assert_not_connected_error { @minilab.write_analog(0, 2.2) }
    assert_not_connected_error { @minilab.read_digital(6) }
    assert_not_connected_error { @minilab.write_digital(6, 1) }
    assert_not_connected_error { @minilab.read_digital_byte(:porta) }
    assert_not_connected_error { @minilab.configure_input_port(:portcl) }
    assert_not_connected_error { @minilab.configure_output_port(:portb) }
  end

  # IO tests
  should "read analog input" do
    @connection_state.expects.connected?.returns true
    @analog_io.expects.read_analog(4).returns(1.1)

    assert_equal 1.1, @minilab.read_analog(4)
  end
  
  should "write analog output" do
    @connection_state.expects.connected?.returns true
    @analog_io.expects.write_analog(1, 5.9).returns(true)

    @minilab.write_analog(1, 5.9)
  end

  should "read digital input from the DIO auxport terminals" do
    @connection_state.expects.connected?.returns true
    @digital_auxport_io.expects.read_digital('DIO1').returns(1)

    assert_equal 1, @minilab.read_digital('DIO1')
  end

  should "write digital output to the DIO auxport terminals" do
    @connection_state.expects.connected?.returns true
    @digital_auxport_io.expects.write_digital('DIO3', 0).returns(true)

    @minilab.write_digital('DIO3', 0)
  end

  should "use the digital port object when the pin is a numbered pin for read_digital" do
    @connection_state.expects.connected?.returns true
    @digital_port_io.expects.read_digital(7).returns(1)

    assert_equal 1, @minilab.read_digital(7)
  end

  should "use the digital port object when the pin is a numbered pin for write_digital" do
    @connection_state.expects.connected?.returns true
    @digital_port_io.expects.write_digital(2, 1).returns(:yourmom)

    assert_equal :yourmom, @minilab.write_digital(2, 1)
  end

  should "use the digital port object to read a byte from a digital port" do
    @connection_state.expects.connected?.returns true
    @digital_port_io.expects.read_port(:porta).returns(0x22)
    assert_equal 0x22, @minilab.read_digital_byte(:porta)
  end

  # Configuration tests
  should "use the digital port object for configuring a port for input" do
    @connection_state.expects.connected?.returns true
    @digital_port_io.expects.configure_input_port(:portch).returns(true)

    assert @minilab.configure_input_port(:portch)
  end
  
  should "use the digital port object for configuring a port for output" do
    @connection_state.expects.connected?.returns true
    @digital_port_io.expects.configure_output_port(:porta).returns(true)

    assert @minilab.configure_output_port(:porta)
  end

  private
  def assert_not_connected_error
    @connection_state.expects.connected?.returns false
    error = "Cannot use any minilab methods without calling 'connect' first."
    assert_error(RuntimeError, error) { yield }
  end
end
