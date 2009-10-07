class IntegrationTest < Test::Unit::TestCase
  include MinilabConstants

  def setup
    MinilabContext.clear
    create_mock :minilab_hardware
    MinilabContext.inject :object => :minilab_hardware, :instance => @minilab_hardware

    @port_to_library_port_mapping = {
      :porta => FIRSTPORTA,
      :portb => FIRSTPORTB,
      :portcl => FIRSTPORTCL,
      :portch => FIRSTPORTCH
    }
  end

  def no_error
    {:no => :error}
  end

  def error(number)
    {:error => number}
  end

  def no_error_and_value(value)
    {:no => :error, :value => value}
  end

  def expect_get_error_string(optz)
    @minilab_hardware.expects.get_error_string(optz[:error]).returns(optz[:message])
  end

  def build_and_connect_to_minilab
    @minilab = Minilab.build

    @minilab_hardware.expects.setup_error_handling(DONTPRINT, STOPALL).returns(no_error)
    @minilab_hardware.expects.declare_revision(CURRENTREVNUM).returns(no_error)

    configure_input_result = {:no => :error}
    [:porta, :portb, :portcl, :portch].each do |port|
      expected_configuration = { :direction => DIGITALIN, :port => @port_to_library_port_mapping[port] }
      @minilab_hardware.expects.configure_port(expected_configuration).returns(no_error)
    end

    @minilab.connect
  end

  should "have an empty test case so that Test::Unit::TestCase doesn't complain" do
  end
end
