require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"

class DigitalConfigurationTest < Test::Unit::TestCase
  include MinilabConstants

  def setup
    mox = create_mocks(:minilab_hardware, :result_verifier)
    @target = DigitalConfiguration.new(mox)

    @good_ports = [:porta, :portb, :portcl, :portch]
    @port_to_library_port_mapping = {
      :porta => FIRSTPORTA,
      :portb => FIRSTPORTB,
      :portcl => FIRSTPORTCL,
      :portch => FIRSTPORTCH
    }

    @bad_ports = [nil, :portd, :portttt, "ibm"]
  end

  def expect_configure_input_and_verification
    result = { :hey => "you" }

    @good_ports.each do |port|
      expected_configuration = { :direction => DIGITALIN, :port => @port_to_library_port_mapping[port] }
      @minilab_hardware.expects.configure_port(expected_configuration).returns(result)
      @result_verifier.expects.verify(result)
    end
  end

  def expect_configure_output_and_verification
    result = { :woo => "boo" }

    @good_ports.each do |port|
      expected_configuration = { :direction => DIGITALOUT, :port => @port_to_library_port_mapping[port] }
      @minilab_hardware.expects.configure_port(expected_configuration).returns(result)
      @result_verifier.expects.verify(result)
    end
  end

  def check_error_for_all_bad_ports(method_to_test)
    @bad_ports.each do |bad_port|
      assert_raise(RuntimeError) { @target.send(method_to_test, bad_port) }
    end
  end

  should "know the valid ports" do
    expected_ports = [:porta, :portb, :portcl, :portch]
    actual_ports = @target.get_valid_ports

    assert_equal expected_ports.size, actual_ports.size
    expected_ports.each_with_index do |port, index|
      assert_equal port, actual_ports[index]
    end
  end
  
  should "configure a port for input" do
    expect_configure_input_and_verification

    @good_ports.each do |port|
      assert_equal true, @target.configure_port_for_input(port)
    end
  end
  
  should "configure a port for output" do
    expect_configure_output_and_verification

    @good_ports.each do |port|
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
    @good_ports.each do |port|
      assert_equal false, @target.is_port_configured_for_input?(port)
    end
  end

  should "return false when each of the ports has not been configured for output yet and a client asks if it has" do
    @good_ports.each do |port|
      assert_equal false, @target.is_port_configured_for_output?(port)
    end
  end

  should "return the input configuration status of a port when asked" do
    result = {:a => "b"}
    expected_configuration = { :direction => DIGITALIN, :port => @port_to_library_port_mapping[:porta] }
    @minilab_hardware.expects.configure_port(expected_configuration).returns(result)
    @result_verifier.expects.verify(result)

    @target.configure_port_for_input(:porta)
    assert_equal true, @target.is_port_configured_for_input?(:porta)
    
    expected_configuration = { :direction => DIGITALIN, :port => @port_to_library_port_mapping[:portch] }
    @minilab_hardware.expects.configure_port(expected_configuration).returns(result)
    @result_verifier.expects.verify(result)

    @target.configure_port_for_input(:portch)
    assert_equal true, @target.is_port_configured_for_input?(:portch)
  end
  
  should "return the output configuration status of a port when asked" do
    result = {:keyboard => "mouse"}
    expected_configuration = { :direction => DIGITALOUT, :port => @port_to_library_port_mapping[:portb] }
    @minilab_hardware.expects.configure_port(expected_configuration).returns(result)
    @result_verifier.expects.verify(result)

    @target.configure_port_for_output(:portb)
    assert_equal true, @target.is_port_configured_for_output?(:portb)
    
    expected_configuration = { :direction => DIGITALOUT, :port => @port_to_library_port_mapping[:portcl] }
    @minilab_hardware.expects.configure_port(expected_configuration).returns(result)
    @result_verifier.expects.verify(result)

    @target.configure_port_for_output(:portcl)
    assert_equal true, @target.is_port_configured_for_output?(:portcl)
  end
  
  should "raise an error if you pass is_port_configured_for_input? an invalid port" do
    check_error_for_all_bad_ports(:is_port_configured_for_input?)
  end
  
  should "raise an error if you pass is_port_configured_for_output? an invalid port" do
    check_error_for_all_bad_ports(:is_port_configured_for_output?)
  end
end
