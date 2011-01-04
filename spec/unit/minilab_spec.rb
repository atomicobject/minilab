require_relative "../spec_helper"

describe Minilab::Minilab do
  before { @mox = create_mocks(:minilab_wrapper, :analog_io, :digital_auxport_io, :digital_port_io, :connection_state) }
  subject { described_class.new(@mox) }

  it "allow the user to easily build the minilab object and its dependences" do
    assert_not_nil Minilab.build
    assert_kind_of Minilab::Minilab, Minilab.build
  end

  it "connect to the hardware, setup the error handling, declare the library revision, and setup the db37 ports for input" do
    @minilab_wrapper.setup_error_handling(DONTPRINT, STOPALL)
    @minilab_wrapper.declare_revision(CURRENTREVNUM)
    @connection_state.connected=(true)

    Minilab::DigitalConfiguration::PORTS.each do |port|
      @connection_state.connected?.returns true
      @digital_port_io.configure_input_port(port)
    end

    assert subject.connect
  end

  it "bomb out if trying to use a method but haven't connected yet" do
    assert_not_connected_error { subject.read_analog(0) }
    assert_not_connected_error { subject.write_analog(0, 2.2) }
    assert_not_connected_error { subject.read_digital(6) }
    assert_not_connected_error { subject.write_digital(6, 1) }
    assert_not_connected_error { subject.read_digital_byte(:porta) }
    assert_not_connected_error { subject.configure_input_port(:portcl) }
    assert_not_connected_error { subject.configure_output_port(:portb) }
  end

  # IO tests
  it "read analog input" do
    @connection_state.connected?.returns true
    @analog_io.read_analog(4).returns(1.1)

    assert_equal 1.1, subject.read_analog(4)
  end
  
  it "write analog output" do
    @connection_state.connected?.returns true
    @analog_io.write_analog(1, 5.9).returns(true)

    subject.write_analog(1, 5.9)
  end

  it "read digital input from the DIO auxport terminals" do
    @connection_state.connected?.returns true
    @digital_auxport_io.read_digital('DIO1').returns(1)

    assert_equal 1, subject.read_digital('DIO1')
  end

  it "write digital output to the DIO auxport terminals" do
    @connection_state.connected?.returns true
    @digital_auxport_io.write_digital('DIO3', 0).returns(true)

    assert subject.write_digital('DIO3', 0)
  end

  it "use the digital port object when the pin is a numbered pin for read_digital" do
    @connection_state.connected?.returns true
    @digital_port_io.read_digital(7).returns(1)

    assert_equal 1, subject.read_digital(7)
  end

  it "use the digital port object when the pin is a numbered pin for write_digital" do
    @connection_state.connected?.returns true
    @digital_port_io.write_digital(2, 1).returns(:yourmom)

    assert_equal :yourmom, subject.write_digital(2, 1)
  end

  it "use the digital port object to read a byte from a digital port" do
    @connection_state.connected?.returns true
    @digital_port_io.read_port(:porta).returns(0x22)
    assert_equal 0x22, subject.read_digital_byte(:porta)
  end

  # Configuration tests
  it "use the digital port object for configuring a port for input" do
    @connection_state.connected?.returns true
    @digital_port_io.configure_input_port(:portch).returns(true)

    assert subject.configure_input_port(:portch)
  end
  
  it "use the digital port object for configuring a port for output" do
    @connection_state.connected?.returns true
    @digital_port_io.configure_output_port(:porta).returns(true)

    assert subject.configure_output_port(:porta)
  end

  private
  def assert_not_connected_error
    @connection_state.connected?.returns false
    -> { yield }.should raise_error("Cannot use any minilab methods without calling 'connect' first.")
  end
end
