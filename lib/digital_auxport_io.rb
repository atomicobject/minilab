class DigitalAuxportIo #:nodoc:
  constructor :minilab_hardware, :result_verifier
  include MinilabConstants

  VALID_PINS = ['DIO0', 'DIO1', 'DIO2', 'DIO3']

  def read_digital(pin)
    check_pin_valid(pin)
    pin = get_pin_number(pin)

    configuration = {:direction => DIGITALIN, :pin => pin}
    result = @minilab_hardware.configure_auxport(configuration)
    @result_verifier.verify(result, "configure_auxport_in")

    result = @minilab_hardware.read_auxport(pin)
    @result_verifier.verify(result, "read_auxport")

    result[:value]
  end

  def write_digital(pin, value)
    check_pin_valid(pin)
    pin = get_pin_number(pin)

    raise "#{value} is not a valid digital output." if (value < 0)
    value = 1 if (value > 0)

    configuration = { :direction => DIGITALOUT, :pin => pin }
    result = @minilab_hardware.configure_auxport(configuration)
    @result_verifier.verify(result, "configure_auxport_out")

    result = @minilab_hardware.write_auxport(pin, value)
    @result_verifier.verify(result, "write_auxport")
  end

  private
  def check_pin_valid(pin)
    if !VALID_PINS.include?(pin.to_s.upcase)
      raise "#{pin} is not a valid digital IO pin"
    end
  end

  def get_pin_number(pin)
    pin.match(/(\d)$/)[0].to_i
  end
end
