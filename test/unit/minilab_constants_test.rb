require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"

class MinilabHardwareTest < Test::Unit::TestCase
  include MinilabConstants

  should "have expected constants" do
    [
      :CURRENTREVNUM,
      :BOARDNUM,
      :DONTPRINT,
      :STOPALL,
      :ERRSTRLEN,
      :BIP10VOLTS,
      :UNI5VOLTS,
      :AUXPORT,
      :DIGITALIN,
      :DIGITALOUT,
      :FIRSTPORTA,
      :FIRSTPORTB,
      :FIRSTPORTCL,
      :FIRSTPORTCH
    ].each do |constant|
      assert MinilabConstants.const_defined?(constant), "#{constant} should exist as a constant in MinilabConstants"
    end
  end
end
