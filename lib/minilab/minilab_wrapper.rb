module Minilab
  class MinilabWrapper #:nodoc:
    constructor :minilab_hardware

    def method_missing(method, *argz)
      result = @minilab_hardware.send(method, *argz)
      if result[:error]
        message = @minilab_hardware.get_error_string(result[:error])
        raise "Command [#{method}(#{argz.inspect})] caused a hardware error: #{message}"
      end
      result[:value]
    end
  end
end
