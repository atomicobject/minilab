# @author Matt Fletcher (fletcher@atomicobject.com)
module Minilab
  # Constructs Minilab objects.
  # @return [Minilab] an unconnected Minilab object. Use {Minilab#connect}
  #  to connect it to the physical device.
  def self.build
    MinilabContext.new.build[:minilab]
  end

  # The main interface to the minilab library. Create one of these objects
  # using the {Minilab.build} method. After you've created a minilab object,
  # use the {#connect} method to establish the connection to the device.
  # Minilab objects are not usable until they've been connected.
  # @author Matt Fletcher (fletcher@atomicobject.com)
  class Minilab
    include MinilabConstants
    constructor :minilab_wrapper, :analog_io, :digital_auxport_io, :digital_port_io, :connection_state

    # Connect to the device. There are two side effects of connecting.
    # * Error reporting from MCC's universal library is set to print
    #   errors to standard out instead of popping up a Windows dialog.
    # * Each of the DB37 digital ports is setup for input.
    # @return [true]
    def connect
      @minilab_wrapper.setup_error_handling(DONTPRINT, STOPALL)
      @minilab_wrapper.declare_revision(CURRENTREVNUM)
      @connection_state.connected = true
      DigitalConfiguration::PORTS.each { |port| configure_input_port(port) }
      true
    end

    # Read from one of the eight analog channels on top of the device.
    #
    # Single-ended mode is the only analog mode supported.
    #
    # @param [Fixnum] channel the analog channel (0 - 7)
    # @return [Float] the voltage
    # @raise [RuntimeError] the channel number is invalid
    def read_analog(channel)
      ensure_connected_to_device
      @analog_io.read_analog(channel)
    end

    # Output a voltage on one of the eight analog channels. The output voltage
    # must be in the range of 0.0 - 5.0 volts.
    #
    # Single-ended mode is the only analog mode supported.
    #
    # @param [Fixnum] channel the analog channel (0 or 1)
    # @param [Float] volts the voltage (0.0 - 5.0)
    # @raise [RuntimeError] the channel number is invalid
    # @raise [RuntimeError] the voltage is out of range
    def write_analog(channel, volts)
      ensure_connected_to_device
      @analog_io.write_analog(channel, volts)
    end

    # Configure one of the DB37 ports for input.
    #
    # @param [Symbol] port the port. Valid ports are
    #   :porta, :portb, :portcl, and :portch.
    # @return [true]
    # @raise [RuntimeError] the port is invalid
    def configure_input_port(port)
      ensure_connected_to_device
      @digital_port_io.configure_input_port(port)
    end

    # Configure one of the DB37 ports for output.
    #
    # @param (see #configure_input_port)
    # @return [true]
    # @raise (see #configure_input_port)
    def configure_output_port(port)
      ensure_connected_to_device
      @digital_port_io.configure_output_port(port)
    end

    # Read a single bit from one of the auxport pins (on the top of the
    # device) or from a DB37 pin. Ensure the pin has been configured for
    # input (see {#configure_input_port}) before using this method.
    # auxport pins do not need to be configured.
    #
    # @param [String, Fixnum] pin a String name of the auxport (e.g. "DIO1")
    #   or a Fixnum DB37 pin number (e.g. 13)
    # @return [Fixnum] the bit value
    # @raise [RuntimeError] the given pin doesn't exist
    # @raise [RuntimeError] the DB37 pin has not been configured for input
    def read_digital(pin)
      ensure_connected_to_device
      perform_digital_op(pin, :read, pin)
    end
    
    # Write a single bit to one of the auxport pins (on the top of the
    # device) or to a DB37 pin. Ensure the pin has been configured for
    # output (see {#configure_output_port}) before using this method.
    # auxport pins do not need to be configured.
    #
    # @param [String, Fixnum] pin a String name of the auxport (e.g. "DIO1")
    #   or a Fixnum DB37 pin number (e.g. 13)
    # @param [Fixnum] value the value (0 or 1) to write. values above 1 are
    #   interpreted as 1.
    # @return [true]
    # @raise [RuntimeError] the given pin doesn't exist
    # @raise [RuntimeError] the DB37 pin has not been configured for input
    # @raise [RuntimeError] a negative value is given
    def write_digital(pin, value)
      ensure_connected_to_device
      perform_digital_op(pin, :write, pin, value)
    end

    # Read a byte from one of the DB37 ports.
    #
    # @param (see #configure_input_port)
    # @return [Fixnum] the byte value
    # @raise (see #configure_input_port)
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
end
