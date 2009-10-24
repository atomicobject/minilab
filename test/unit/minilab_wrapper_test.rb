require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"

class MinilabWrapperTest < Test::Unit::TestCase
  def setup
    mox = create_mocks(:minilab_hardware)
    @target = MinilabWrapper.new(mox)
  end

  should "call forward methods to the hardware and give the result" do
    @minilab_hardware.expects.razzle(1, 2, "three").returns({ :value => 5 })
    assert_equal 5, @target.razzle(1, 2, "three")

    @minilab_hardware.expects.dazzle.returns({ :value => :whatever })
    assert_equal :whatever, @target.dazzle
  end

  should "raise an error when there is a hardware error" do
    @minilab_hardware.expects.bang(1, 2).returns({ :error => 4 })
    @minilab_hardware.expects.get_error_string(4).returns "Righteous error"
    assert_error RuntimeError, "Command [bang([1, 2])] caused a hardware error: Righteous error" do
      @target.bang(1, 2)
    end
  end
end
