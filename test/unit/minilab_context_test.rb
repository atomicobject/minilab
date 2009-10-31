require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class MinilabContextTest < Test::Unit::TestCase
  def setup
    @target = MinilabContext.new
  end

  should "build minilab context" do
    context = nil
    assert_nothing_raised "should build without error" do
      context = @target.build
    end
    assert_not_nil context, "should have gotten a context"

    minilab = context[:minilab]
    assert_not_nil minilab, "should have a minilab object in the context"
    assert_kind_of Minilab, minilab, "should have gotten a Minilab object"
  end

  should "give the same context when built more than once" do
    assert_same @target.build, @target.build, "not the same context object"
  end
end
