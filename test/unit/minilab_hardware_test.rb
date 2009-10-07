require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"

# The intent of this test is to assert some basic properties on the extension.
# Typically I would not check these things, but this class is made from C code.
# Even though it's easy to create Ruby constants, methods, etc. with Ruby's C
# support, it's still more work than it takes in Ruby syntax. So here I'm
# trying to show that the stuff we expect to be there is actually there. It's
# also here to help pinpoint any problems that may not show up until system test
# time.
#
# Outside of the tests for checking hash parameters, I'm willing to discuss
# whether maintaining this set of tests is truly worthwhile. I may change my
# mind.
class MinilabHardwareTest < Test::Unit::TestCase
  include MinilabConstants

  def setup
    @target = MinilabHardware.new
  end

  should "have the expected methods" do
    expected_methods =
    [ 
      :setup_error_handling,
      :declare_revision,
      :get_revision,
      :get_error_string,

      :configure_auxport,
      :configure_port,

      :read_analog,
      :read_digital_pin,
      :read_auxport,
      :read_port,

      :write_analog,
      :write_digital_pin,
      :write_auxport,
    ]

    expected_methods.each do |method|
      assert @target.respond_to?(method), "Minilab hardware object does not respond to #{method.to_s}"
    end
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
