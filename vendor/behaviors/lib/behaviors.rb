=begin rdoc
= Usage
Behaviors provides a single method: should.

Your test classes should <tt>extend Behaviors</tt>. 
  
Instead of naming test methods like:

 def test_something
 end

You declare test methods like:

 should "perform action" do
 end

You also have the ability to declare flunking test methods as a way
to describe future tests:

 should "perform other action"

= Motivation
Test methods typically focus on the name of the method under test instead of its behavior.

Creating test methods with <tt>should</tt> statements focuses on the behaviors of an object.
This enhances the TDD experience by provoking the developer to think about the role of the object under test.

Writing the tests first to declare an object's behaviors and then implementing those
behaviors through object methods produces the most value.
Using this behavior-driven approach prevents the dangers associated with assuming a one-to-one mapping of method names to 
test method names.

For a more complete BDD framework, try RSpec http://rspec.rubyforge.org/
  
= Rake tasks

Behaviors includes a pair of Rake tasks, <tt>behaviors</tt> and <tt>behaviors_html</tt>.  These tasks will output to the
console or an html file in the <tt>doc</tt> directory with a list all of your <tt>should</tt> tests.
Use these tasks to summarize the behavior of your project.
=end
module Behaviors
  def should(behave,&block)
    mname = "test_should_#{behave}"
    if block
      define_method mname, &block
    else
      puts ">>> UNIMPLEMENTED CASE: #{name.sub(/Test$/,'')} should #{behave}"
    end
  end
end
