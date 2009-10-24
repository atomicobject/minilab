require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"

class DigitalConfigurationTest < Test::Unit::TestCase
  include MinilabConstants

  def setup
    mox = create_mocks(:minilab_wrapper)
    @target = DigitalConfiguration.new(mox)
  end

  should "configure known ports for input" do
    good_ports.each do |port|
      expected_configuration = { :direction => DIGITALIN, :port => port_to_library_port_mapping[port] }
      @minilab_wrapper.expects.configure_port(expected_configuration).returns "you"
    end

    good_ports.each do |port|
      assert_equal true, @target.configure_port_for_input(port)
    end
  end
  
  should "configure known ports for output" do
    good_ports.each do |port|
      expected_configuration = { :direction => DIGITALOUT, :port => port_to_library_port_mapping[port] }
      @minilab_wrapper.expects.configure_port(expected_configuration).returns "boo"
    end

    good_ports.each do |port|
      assert_equal true, @target.configure_port_for_output(port)
    end
  end
  
  should "raise an error for an invalid input port" do
    check_error_for_all_bad_ports(:configure_port_for_input)
  end

  should "raise an error for an invalid output port" do
    check_error_for_all_bad_ports(:configure_port_for_output)
  end

  should "return false when each of the ports has not been configured for input yet and a client asks if it has" do
    good_ports.each do |port|
      assert_equal false, @target.is_port_configured_for_input?(port)
    end
  end

  should "return false when each of the ports has not been configured for output yet and a client asks if it has" do
    good_ports.each do |port|
      assert_equal false, @target.is_port_configured_for_output?(port)
    end
  end

  should "return the input configuration status of a port when asked" do
    expected_configuration = { :direction => DIGITALIN, :port => port_to_library_port_mapping[:porta] }
    @minilab_wrapper.expects.configure_port(expected_configuration).returns true

    @target.configure_port_for_input(:porta)
    assert_equal true, @target.is_port_configured_for_input?(:porta)
  end
  
  should "return the output configuration status of a port when asked" do
    expected_configuration = { :direction => DIGITALOUT, :port => port_to_library_port_mapping[:portb] }
    @minilab_wrapper.expects.configure_port(expected_configuration).returns true

    @target.configure_port_for_output(:portb)
    assert_equal true, @target.is_port_configured_for_output?(:portb)
  end
  
  should "raise an error if you pass is_port_configured_for_input? an invalid port" do
    check_error_for_all_bad_ports(:is_port_configured_for_input?)
  end
  
  should "raise an error if you pass is_port_configured_for_output? an invalid port" do
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
      assert_raise(RuntimeError) { @target.send(method_to_test, bad_port) }
    end
  end
end
