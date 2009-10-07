require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"
require 'result_verifier'

class ResultVerifierTest < Test::Unit::TestCase
  def setup
    mox = create_mocks :minilab_hardware
    @target = ResultVerifier.new(mox)
  end

  should "return true when there is no error and not consult the hardware" do
    result = { :value => 2 }

    assert_equal true, @target.verify(result)
  end

  should "raise an exception when there is an error" do
    result = { :error => 1 }
    @minilab_hardware.expect.get_error_string(1).returns("kaboom")
    assert_error(RuntimeError, /kaboom/) { @target.verify(result) }


    result = { :error => 2 }
    @minilab_hardware.expect.get_error_string(2).returns("burn")
    assert_error(RuntimeError, /burn/) { @target.verify(result) }
  end

  should "include the custom message passed in the exception that is raised" do
    result = { :error => 1 }
    @minilab_hardware.expect.get_error_string(1).returns("oy")

    assert_error(RuntimeError, /argh/) { @target.verify(result, "argh") }
  end
end
