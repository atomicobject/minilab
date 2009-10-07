class DigitalPortIo #:nodoc:
  constructor :minilab_hardware, :result_verifier, :digital_configuration, :library_translator

  def get_valid_ports
    @digital_configuration.get_valid_ports
  end

  def configure_input_port(port)
    @digital_configuration.configure_port_for_input(port)
  end
  
  def configure_output_port(port)
    @digital_configuration.configure_port_for_output(port)
  end

  def read_digital(pin)
    check_pin_configuration(pin, :input)
    pin = get_library_pin_number(pin)

    access_hardware(:read_digital_pin, pin)
  end

  def write_digital(pin, value)
    check_pin_configuration(pin, :output)
    pin = get_library_pin_number(pin)

    access_hardware(:write_digital_pin, pin, value)
    true
  end

  def read_port(port)
    raise "#{port} is an invalid port." unless get_valid_ports.include?(port)

    if !@digital_configuration.is_port_configured_for_input?(port)
      raise "Digital port #{port} is not configured for input."
    end

    access_hardware("read_port", get_library_port(port))
  end

  private
  def get_port(pin)
    @library_translator.get_port_for_pin(pin)
  end

  def get_library_pin_number(pin)
    @library_translator.get_library_pin_number(pin)
  end

  def get_library_port(port)
    @library_translator.get_library_port(port)
  end

  def check_pin_configuration(pin, type)
    port = get_port(pin)
    if !@digital_configuration.send("is_port_configured_for_#{type}?", port)
      raise "Digital port #{port} for pin #{pin} is not configured for #{type}."
    end
  end

  def access_hardware(method, *args)
    result = @minilab_hardware.send(method, *args)
    @result_verifier.verify(result)
    result[:value]
  end
end
