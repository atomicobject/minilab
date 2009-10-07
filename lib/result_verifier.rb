class ResultVerifier #:nodoc:
  constructor :minilab_hardware

  def verify(result, user_message="Command")
    if result[:error]
      library_message = @minilab_hardware.get_error_string(result[:error])
      raise "#{user_message} caused a hardware error: #{library_message}"
    end

    return true
  end
end
