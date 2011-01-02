require_relative "../spec_helper"

describe Minilab::DigitalConfiguration do
  before { @mox = create_mocks(:minilab_wrapper) }
  subject { described_class.new(@mox) }

  it "configure known ports for input" do
    good_ports.each do |port|
      expected_configuration = { :direction => DIGITALIN, :port => port_to_library_port_mapping[port] }
      @minilab_wrapper.configure_port(expected_configuration).returns "you"
    end

    good_ports.each do |port|
      assert_equal true, subject.configure_port_for_input(port)
    end
  end
  
  it "configure known ports for output" do
    good_ports.each do |port|
      expected_configuration = { :direction => DIGITALOUT, :port => port_to_library_port_mapping[port] }
      @minilab_wrapper.configure_port(expected_configuration).returns "boo"
    end

    good_ports.each do |port|
      assert_equal true, subject.configure_port_for_output(port)
    end
  end
  
  it "raise an error for an invalid input port" do
    check_error_for_all_bad_ports(:configure_port_for_input)
  end

  it "raise an error for an invalid output port" do
    check_error_for_all_bad_ports(:configure_port_for_output)
  end

  it "return false when each of the ports has not been configured for input yet and a client asks if it has" do
    good_ports.each do |port|
      assert_equal false, subject.is_port_configured_for_input?(port)
    end
  end

  it "return false when each of the ports has not been configured for output yet and a client asks if it has" do
    good_ports.each do |port|
      assert_equal false, subject.is_port_configured_for_output?(port)
    end
  end

  it "return the input configuration status of a port when asked" do
    expected_configuration = { :direction => DIGITALIN, :port => port_to_library_port_mapping[:porta] }
    @minilab_wrapper.configure_port(expected_configuration).returns true

    subject.configure_port_for_input(:porta)
    assert_equal true, subject.is_port_configured_for_input?(:porta)
  end
  
  it "return the output configuration status of a port when asked" do
    expected_configuration = { :direction => DIGITALOUT, :port => port_to_library_port_mapping[:portb] }
    @minilab_wrapper.configure_port(expected_configuration).returns true

    subject.configure_port_for_output(:portb)
    assert_equal true, subject.is_port_configured_for_output?(:portb)
  end
  
  it "raise an error if you pass is_port_configured_for_input? an invalid port" do
    check_error_for_all_bad_ports(:is_port_configured_for_input?)
  end
  
  it "raise an error if you pass is_port_configured_for_output? an invalid port" do
    check_error_for_all_bad_ports(:is_port_configured_for_output?)
  end

  private
  def good_ports
    [:porta, :portb, :portcl, :portch]
  end

  def bad_ports
    [nil, :portd, :portttt, "ibm"]
  end

  def port_to_library_port_mapping
    {
      :porta => FIRSTPORTA,
      :portb => FIRSTPORTB,
      :portcl => FIRSTPORTCL,
      :portch => FIRSTPORTCH
    }
  end

  def check_error_for_all_bad_ports(method_to_test)
    bad_ports.each do |bad_port|
      -> { subject.send(method_to_test, bad_port) }.should raise_error
    end
  end
end
