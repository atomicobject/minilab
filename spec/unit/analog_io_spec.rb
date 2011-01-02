require_relative "../spec_helper"

describe Minilab::AnalogIo do
  before { @mox = create_mocks(:minilab_wrapper) }
  subject { described_class.new(@mox) }

  it "read analog data" do
    @minilab_wrapper.read_analog(2).returns 5.7
    assert_equal 5.7, subject.read_analog(2)
  end

  it "raise an exception when analog input channel is out of range" do
    # The minilab device has 8 analog inputs (when used in straight
    # input mode, not differential). We expect that exceptions
    # it be thrown for channels that are out of bounds.
    -> { subject.read_analog(-1) }.should raise_error
    0.upto(7) do |channel|
      @minilab_wrapper.read_analog(channel).returns(1.0)
      -> { subject.read_analog(channel) }.should_not raise_error
    end
    -> { subject.read_analog(8) }.should raise_error
  end

  it "write analog data" do
    @minilab_wrapper.write_analog(1, 4.5)
    subject.write_analog(1, 4.5)
  end

  it "raise an error when analog output voltage is out of range" do
    -> { subject.write_analog(0, -0.1) }.should raise_error

    @minilab_wrapper.write_analog(0, 0.0)
    -> { subject.write_analog(0, 0.0) }.should_not raise_error

    @minilab_wrapper.write_analog(0, 2.1)
    -> { subject.write_analog(0, 2.1) }.should_not raise_error

    @minilab_wrapper.write_analog(0, 5.0)
    -> { subject.write_analog(0, 5.0) }.should_not raise_error

    -> { subject.write_analog(0, 5.1) }.should raise_error
  end
  
  it "raise an error when analog output channel is out of range" do
    -> { subject.write_analog(-1, 0.0) }.should raise_error

    @minilab_wrapper.write_analog(0, 0.0)
    -> { subject.write_analog(0, 0.0) }.should_not raise_error

    @minilab_wrapper.write_analog(1, 0.0)
    -> { subject.write_analog(1, 0.0) }.should_not raise_error

    -> { subject.write_analog(2, 0.0) }.should raise_error
  end
end
