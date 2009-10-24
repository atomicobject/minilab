class DigitalPortIo #:nodoc:
  constructor :minilab_wrapper, :digital_configuration, :library_translator

  def configure_input_port(port)
    @digital_configuration.configure_port_for_input(port)
  end
  
  def configure_output_port(port)
    @digital_configuration.configure_port_for_output(port)
  end

  def read_digital(pin)
    check_pin_configuration(pin, :input)
    @minilab_wrapper.read_digital_pin(get_library_pin_number(pin))
  end

  def write_digital(pin, value)
    check_pin_configuration(pin, :output)
    @minilab_wrapper.write_digital_pin(get_library_pin_number(pin), value)
    true
  end

  def read_port(port)
    raise "Digital port #{port} is not configured for input." unless @digital_configuration.is_port_configured_for_input?(port)
    @minilab_wrapper.read_port(@library_translator.get_library_port(port))
  end

  private
  def get_library_pin_number(pin)
    @library_translator.get_library_pin_number(pin)
  end

  def check_pin_configuration(pin, type)
    port = @library_translator.get_port_for_pin(pin)
    unless @digital_configuration.send("is_port_configured_for_#{type}?", port)
      raise "Digital port #{port} for pin #{pin} is not configured for #{type}."
    end
  end
end
