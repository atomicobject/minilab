module Minilab
  class AnalogIo #@private
    constructor :minilab_wrapper

    def read_analog(channel)
      check_channel_range(channel, 0, 7)
      @minilab_wrapper.read_analog(channel)
    end

    def write_analog(channel, volts)
      check_channel_range(channel, 0, 1)

      unless (0.0 .. 5.0) === volts
        raise "#{volts} volts is out of range for this device; Only voltage between 0.0 and 5.0 is supported."
      end

      @minilab_wrapper.write_analog(channel, volts)
    end
    
    private
    def check_channel_range(channel, low, high)
      raise "Channel #{channel} is out of range." unless (low..high) === channel
    end
  end
end
