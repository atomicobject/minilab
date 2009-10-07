class AnalogIo #:nodoc:
  constructor :minilab_hardware, :result_verifier

  def read_analog(channel)
    check_channel_range(channel, 0, 7)

    result = @minilab_hardware.read_analog(channel)
    @result_verifier.verify(result, "read_analog")

    result[:value]
  end

  def write_analog(channel, volts)
    check_channel_range(channel, 0, 1)

    unless (0.0 .. 5.0) === volts
      raise "#{volts} volts is out of range for this device; Only voltage between 0.0 and 5.0 is supported."
    end

    result = @minilab_hardware.write_analog(channel, volts)
    @result_verifier.verify(result, "write_analog")
  end
  
  private
  def check_channel_range(channel, low, high)
    raise "Channel #{channel} is out of range." unless (low..high) === channel
  end
end
