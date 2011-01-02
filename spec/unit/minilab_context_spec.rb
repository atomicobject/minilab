require_relative "../spec_helper"

describe Minilab::MinilabContext do
  it "build minilab context" do
    context = nil
    -> { context = subject.build }.should_not raise_error
    assert_not_nil context, "should have gotten a context"

    minilab = context[:minilab]
    assert_not_nil minilab, "should have a minilab object in the context"
    assert_kind_of Minilab::Minilab, minilab, "should have gotten a Minilab object"
  end

  it "give the same context when built more than once" do
    assert_same subject.build, subject.build, "not the same context object"
  end
end
