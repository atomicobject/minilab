require_relative "../config/env.rb"

# The main interface to the minilab library. Create one of these objects
# using the +build+ class method. After you've created a minilab object,
# use the +connect+ method to establish the connection to the device.
# Minilab objects are not usable until they've been connected.
class Minilab
  include MinilabConstants
  constructor :minilab_wrapper, :analog_io, :digital_auxport_io, :digital_port_io, :connection_state

  # Use this method to construct Minilab objects. The object will not yet
  # be connected to the device.
  def self.build
    MinilabContext.new.build[:minilab]
  end

  # Connect to the device. There are two side effects of connecting.
  # * Error reporting from MCC's universal library is set to print
  #   errors to standard out instead of popping up a Windows dialog.
  # * Each of the DB37 digital ports is setup for input.
  def connect
    @minilab_wrapper.setup_error_handling(DONTPRINT, STOPALL)
    @minilab_wrapper.declare_revision(CURRENTREVNUM)
    @connection_state.connected = true
    DigitalConfiguration::PORTS.each { |port| configure_input_port(port) }
  end

  # Read from one of the eight analog channels (0 - 7) on top of the device.
  #
  # Single-ended mode is the only analog mode supported.
  #
  # An error is raised if an invalid channel number is given.
  def read_analog(channel)
    ensure_connected_to_device
    @analog_io.read_analog(channel)
  end

  # Output a voltage on one of the eight analog channels. The output voltage
  # must be in the range of 0.0 - 5.0 volts.
  #
  # Single-ended mode is the only analog mode supported.
  #
  # An error is raised if an invalid channel number or an out-of-range
  # voltage is given.
  def write_analog(channel, volts)
    ensure_connected_to_device
    @analog_io.write_analog(channel, volts)
  end

  # Configure one of the DB37 ports for input.
  #
  # Specify _port_ as a symbol. The available ports are <tt>:porta</tt>,
  # <tt>:portb</tt>, <tt>:portcl</tt>, and <tt>:portch</tt>. An error is 
  # raised if an invalid port is given.
  def configure_input_port(port)
    ensure_connected_to_device
    @digital_port_io.configure_input_port(port)
  end

  # Configure one of the DB37 ports for output.
  #
  # Specify _port_ as a symbol. The available ports are <tt>:porta</tt>,
  # <tt>:portb</tt>, <tt>:portcl</tt>, and <tt>:portch</tt>. An error is
  # raised if an invalid port is given.
  def configure_output_port(port)
    ensure_connected_to_device
    @digital_port_io.configure_output_port(port)
  end

  # Read a single bit from one of the digital pins.
  #
  # If you'd like to read from one of the pins on the top of the device (the
  # auxport pins), then specify the pin as a string with its label (e.g. 
  # read_digital("DIO1")). Alternatively, if you'd like to read from one of
  # the DB37 pins, specify the pin as the number it's labeled with (e.g.
  # read_digital(13)).
  #
  # An error is raised if you specify a pin that doesn't exist or if you
  # try to read from a DB37 pin on a port that is not configured for input.
  # The digital pins on the top of the device do not need to be configured.
  def read_digital(pin)
    ensure_connected_to_device
    perform_digital_op(pin, :read, pin)
  end
  
  # Write a single bit to one of the digital pins. _value_ must be an integer
  # 1 or 0.
  #
  # If you'd like to write to one of the pins on the top of the device (the
  # auxport pins), then specify the pin as a string with its label (e.g. 
  # write_digital("DIO2", 0)). Alternatively, if you'd like to write to one
  # of the DB37 pins, specify the pin as the number it's labeled with (e.g. 
  # write_digital(17, 1)).
  #
  # An error is raised if you specify a pin that doesn't exist or if you
  # try to write to a DB37 pin on a port that is not configured for output.
  # The digital pins on the top of the device do not need to be configured.
  #
  # Values above 1 are interpreted as 1; negative values raise an error.
  def write_digital(pin, value)
    ensure_connected_to_device
    perform_digital_op(pin, :write, pin, value)
  end

  # Read a byte from one of the DB37 ports.
  #
  # Specify _port_ as a symbol. The available ports are <tt>:porta</tt>,
  # <tt>:portb</tt>, <tt>:portcl</tt>, and <tt>:portch</tt>.
  #
  # An error is raised if an invalid port is given.
  def read_digital_byte(port)
    ensure_connected_to_device
    @digital_port_io.read_port(port)
  end

  private
  def perform_digital_op(pin, op, *args)
    method = "#{op.to_s}_digital"
    case pin
    when String
      @digital_auxport_io.send(method,*args)
    when Fixnum
      @digital_port_io.send(method,*args)
    end
  end

  def ensure_connected_to_device
    raise "Cannot use any minilab methods without calling 'connect' first." unless @connection_state.connected?
  end
end
