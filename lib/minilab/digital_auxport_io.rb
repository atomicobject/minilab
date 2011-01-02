class DigitalAuxportIo #:nodoc:
  constructor :minilab_wrapper
  include MinilabConstants

  VALID_PINS = %w[ DIO0 DIO1 DIO2 DIO3 ]

  def read_digital(pin)
    validate_pin(pin)
    configuration = {:direction => DIGITALIN, :pin => get_pin_number(pin)}

    @minilab_wrapper.configure_auxport(configuration)
    @minilab_wrapper.read_auxport(get_pin_number(pin))
  end

  def write_digital(pin, value)
    raise "#{value} is not a valid digital output." if (value < 0)
    value = 1 if (value > 0)

    validate_pin(pin)
    configuration = { :direction => DIGITALOUT, :pin => get_pin_number(pin)}

    @minilab_wrapper.configure_auxport(configuration)
    @minilab_wrapper.write_auxport(get_pin_number(pin), value)
  end

  private
  def validate_pin(pin)
    raise "#{pin} is not a valid digital IO pin" unless VALID_PINS.include?(pin.to_s.upcase)
  end

  def get_pin_number(pin)
    pin.match(/(\d)$/)[0].to_i
  end
end
