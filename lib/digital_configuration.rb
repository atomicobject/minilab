class DigitalConfiguration #:nodoc:
  include MinilabConstants
  constructor :minilab_hardware, :result_verifier

  PORTS = [:porta, :portb, :portcl, :portch]
  LIBRARY_PORT_NAMES = {
    :porta => FIRSTPORTA,
    :portb => FIRSTPORTB,
    :portcl => FIRSTPORTCL,
    :portch => FIRSTPORTCH
  }

  def setup
    @port_status = {}
    PORTS.each { |port| @port_status[port] = :not_configured }
  end

  def get_valid_ports
    PORTS
  end

  def configure_port_for_input(port)
    configure_port(port, DIGITALIN)
  end

  def configure_port_for_output(port)
    configure_port(port, DIGITALOUT)
  end

  def is_port_configured_for_input?(port)
    check_port_status(port, DIGITALIN)
  end

  def is_port_configured_for_output?(port)
    check_port_status(port, DIGITALOUT)
  end
  
  private
  def is_port_recognized?(port)
    if get_valid_ports.include?(port)
      true
    else
      raise "Port #{port} is not valid."
    end
  end

  def configure_port(port, direction)
    is_port_recognized?(port)

    result = @minilab_hardware.configure_port(:direction => direction, :port => LIBRARY_PORT_NAMES[port])
    @result_verifier.verify(result)

    @port_status[port] = direction
    true
  end

  def check_port_status(port, status)
    is_port_recognized?(port)

    return false unless @port_status[port] == status
    true
  end
end
