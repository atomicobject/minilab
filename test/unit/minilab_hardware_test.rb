require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"

# Not many tests for this class, since there isn't much behavior outside of
# calling into the minilab library. I could probably figure out another way
# to unit test those calls, but I don't believe there would be much value
# in brittle tests for code that is already covered by system tests.
class MinilabHardwareTest < Test::Unit::TestCase
  include MinilabConstants

  def setup
    @target = MinilabHardware.new
  end

  should "raise an error if auxport configuration isn't given the correct hash parameters" do
    assert_error RuntimeError, ":direction is a required parameter" do
      @target.configure_auxport(:pin => 3)
    end

    assert_error RuntimeError, ":pin is a required parameter" do
      @target.configure_auxport(:direction => DIGITALIN)
    end
  end

  should "raise an error if port configuration isn't given the correct hash parameters" do
    assert_error RuntimeError, ":direction is a required parameter" do
      @target.configure_port(:port => FIRSTPORTA)
    end

    assert_error RuntimeError, ":port is a required parameter" do
      @target.configure_port(:direction => DIGITALOUT)
    end
  end
end
