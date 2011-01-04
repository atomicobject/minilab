module Minilab
  class LibraryTranslator #@private
    include MinilabConstants

    def get_port_for_pin(pin)
      case pin
      when 30..37
        :porta
      when 3..10
        :portb
      when 26..29
        :portcl
      when 22..25
        :portch
      else
        raise "Pin #{pin} does not map to a known minilab DB37 port."
      end
    end

    def get_library_pin_number(pin)
      case pin
      when 30..37  # port a pins
        7 - (pin - 30)
      when 3..10   # port b pins
        15 - (pin - 3)
      when 26..29  # port cl pins
        19 - (pin - 26)
      when 22..25  # port ch pins
        23 - (pin - 22)
      else
        raise "Pin #{pin} does not map to a minilab library pin number."
      end
    end
    
    def get_library_port(port)
      port_to_library_port_mapping = {
        :porta => FIRSTPORTA,
        :portb => FIRSTPORTB,
        :portcl => FIRSTPORTCL,
        :portch => FIRSTPORTCH
      }

      library_port = port_to_library_port_mapping[port]
      return library_port unless library_port.nil?
      raise "Port #{port} is not a valid port."
    end
  end
end
