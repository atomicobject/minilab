require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"
require 'integration_test'
require 'minilab'

class DigitalInputOutputTest < IntegrationTest
  def setup
    super
    build_and_connect_to_minilab
  end

  should "read digital data from the terminals on the top of the device" do
    for_all_screw_terminals do |terminal|
      terminal_number = get_terminal_number(terminal)
      configuration = { :direction => DIGITALIN, :pin => terminal_number }
      @minilab_hardware.expects.configure_auxport(configuration).returns(no_error)
      @minilab_hardware.expects.read_auxport(terminal_number).returns(no_error_and_value(1))
    end

    for_all_screw_terminals do |terminal|
      assert_equal 1, @minilab.read_digital(terminal)
    end
  end

  should "write digital data to the terminals" do
    for_all_screw_terminals do |terminal|
      terminal_number = get_terminal_number(terminal)
      configuration = { :direction => DIGITALOUT, :pin => terminal_number }
      @minilab_hardware.expects.configure_auxport(configuration).returns(no_error)
      @minilab_hardware.expects.write_auxport(terminal_number, 0).returns(no_error)
    end

    for_all_screw_terminals do |terminal|
      assert @minilab.write_digital(terminal, 0)
    end
  end

  should "read digital data from the external digital pins only if the port is configured for input" do
    configure_each_port_for_input

    # We'll go with just one pin for each of the four ports.
    # Finer grained testing of each pin is left to the unit tests.
    for_some_digital_pins do |numbered_pin, library_pin|
      @minilab_hardware.expects.read_digital_pin(library_pin).returns(no_error_and_value(0))
      assert_equal 0, @minilab.read_digital(numbered_pin), "wrong value"
    end
  end

  should "raise an error when there is a problem reading a digital pin" do
    configure_each_port_for_input
    for_some_digital_pins do |numbered_pin, library_pin|
      @minilab_hardware.expects.read_digital_pin(library_pin).returns(error(2))
      expect_get_error_string :error => 2, :message => "yoink"
      assert_error(RuntimeError, /yoink/) { @minilab.read_digital(numbered_pin) }
    end
  end

  should "write digital data to the external digital pins only if the port is configured for output" do
    configure_each_port_for_output

    for_some_digital_pins do |numbered_pin, library_pin|
      @minilab_hardware.expects.write_digital_pin(library_pin, 1).returns(no_error)
      assert @minilab.write_digital(numbered_pin, 1), "should have written with no error"
    end
  end

  should "read an entire byte from a single port only if the port is configured for input" do
    configure_each_port_for_input
    @port_to_library_port_mapping.each do |port, library_port|
      @minilab_hardware.expects.read_port(library_port).returns(no_error_and_value(167))
      assert_equal 167, @minilab.read_digital_byte(port), "read wrong value"
    end
  end

  private
  def get_terminal_number(terminal)
    terminal[-1..-1].to_i
  end

  def for_some_digital_pins
    # The pins numbered on the external ports don't match what the
    # minilab library uses. The ruby code is responsible for doing the
    # correct translation.
    {
      32 => 5,
      6 => 12,
      26 => 19,
      25 => 20
    }.each do |numbered_pin, library_pin|
      yield numbered_pin, library_pin
    end
  end

  def for_all_screw_terminals
    ['DIO0', 'DIO1', 'DIO2', 'DIO3'].each do |terminal|
      yield terminal
    end
  end

  def configure_each_port_for_input
    @port_to_library_port_mapping.each do |port, library_port|
      expected_configuration = { :direction => DIGITALIN, :port => library_port }
      @minilab_hardware.expects.configure_port(expected_configuration).returns(no_error)
      @minilab.configure_input_port(port)
    end
  end

  def configure_each_port_for_output
    @port_to_library_port_mapping.each do |port, library_port|
      expected_configuration = { :direction => DIGITALOUT, :port => library_port }
      @minilab_hardware.expects.configure_port(expected_configuration).returns(no_error)
      @minilab.configure_output_port(port)
    end
  end
end
