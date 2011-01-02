require_relative "../spec_helper"

describe Minilab::MinilabWrapper do
  before { @mox = create_mocks(:minilab_hardware) }
  subject { described_class.new(@mox) }

  it "forwards methods to the hardware and gives the result" do
    @minilab_hardware.razzle(1, 2, "three").returns({ :value => 5 })
    assert_equal 5, subject.razzle(1, 2, "three")

    @minilab_hardware.dazzle.returns({ :value => :whatever })
    assert_equal :whatever, subject.dazzle
  end

  it "raise an error when there is a hardware error" do
    @minilab_hardware.bang(1, 2).returns({ :error => 4 })
    @minilab_hardware.get_error_string(4).returns "Righteous error"
    -> { subject.bang(1,2) }.should raise_error("Command [bang([1, 2])] caused a hardware error: Righteous error")
  end
end
