require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class MinilabContextTest < Test::Unit::TestCase
  def setup
    MinilabContext.clear
    @target = MinilabContext.new
  end

  def build_context
    context = nil

    assert_nothing_raised "should build without error" do
      context = @target.build
    end
    assert_not_nil context, "should have gotten a context"

    context
  end

  should "build minilab context" do
    context = build_context

    minilab = context[:minilab]
    assert_not_nil minilab, "should have a minilab object in the context"
    assert_kind_of Minilab, minilab, "should have gotten a Minilab object"
  end

  should "allow for the context to be cleared" do
    first_context = @target.build
    MinilabContext.clear
    second_context = @target.build

    assert_not_same first_context, second_context, "context should have been cleared and rebuilt"
  end

  should "return the same context when built more than once" do
    first_context = build_context
    second_context = build_context

    assert_same first_context, second_context, "not the same context object"
  end

  should "allow arbitrary objects to be injected into the context before it is built" do
    create_mock(:minilab_hardware)
    MinilabContext.inject(:object => :minilab_hardware, :instance => @minilab_hardware)

    context = build_context
    minilab = context[:minilab_hardware]
    assert_same @minilab_hardware, minilab, "not the same object was returned from the context as was injected"

    create_mock(:kryll)
    MinilabContext.inject(:object => :kryll, :instance => @kryll)

    context = build_context
    kryll = context[:kryll]
    assert_same @kryll, kryll, "not the same object was returned from the context as was injected"
  end
  
  should "blow up if trying to inject an object without the appropriate parameters" do
    assert_error RuntimeError, /missing parameter :object/i do
      MinilabContext.inject(:instance => "foo")
    end

    assert_error RuntimeError, /missing parameter :instance/i do
      MinilabContext.inject(:object => "foo")
    end

    assert_error RuntimeError, /parameters hash was nil/i do
      MinilabContext.inject(nil)
    end
  end
  
  should "raise an error if trying to inject an object into the context after it has been built" do
    @target.build

    assert_error RuntimeError, /minilab_hardware/i do
      MinilabContext.inject(:object => 'minilab_hardware', :instance => "kaboo")
    end
  end
end
