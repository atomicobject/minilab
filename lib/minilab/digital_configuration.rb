module Minilab
  class DigitalConfiguration #@private
    include MinilabConstants
    constructor :minilab_wrapper

    PORTS = [:porta, :portb, :portcl, :portch]
    LIBRARY_PORT_NAMES = {
      :porta => FIRSTPORTA,
      :portb => FIRSTPORTB,
      :portcl => FIRSTPORTCL,
      :portch => FIRSTPORTCH
    }

    def setup
      @port_status = PORTS.inject({}) do |port_status, port|
        port_status[port] = :not_configured
        port_status
      end
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
      raise "Port #{port} is not valid." unless PORTS.include?(port)
    end

    def configure_port(port, direction)
      is_port_recognized?(port)

      @minilab_wrapper.configure_port(:direction => direction, :port => LIBRARY_PORT_NAMES[port])
      @port_status[port] = direction
      true
    end

    def check_port_status(port, status)
      is_port_recognized?(port)
      @port_status[port] == status ? true : false
    end
  end
end
