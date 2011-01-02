require_relative "../spec_helper"

# Not many tests for this class, since there isn't much behavior outside of
# calling into the minilab library. I could probably figure out another way
# to unit test those calls, but I don't believe there would be much value
# in brittle tests for code that is already covered by system tests.
describe Minilab::MinilabHardware do
  it "raise an error if auxport configuration isn't given the correct hash parameters" do
    -> { subject.configure_auxport(:pin => 3) }.should raise_error(":direction is a required parameter")
    -> { subject.configure_auxport(:direction => DIGITALIN) }.should raise_error(":pin is a required parameter")
  end

  it "raise an error if port configuration isn't given the correct hash parameters" do
    -> { subject.configure_port(:port => FIRSTPORTA) }.should raise_error(":direction is a required parameter")
    -> { subject.configure_port(:direction => DIGITALOUT) }.should raise_error(":port is a required parameter")
  end
end
