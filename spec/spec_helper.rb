require_relative "../lib/minilab"

module MinilabUnitSpecHelpers
  def create_mocks(*mox)
    mox.inject({}) do |bag, name|
      the_mock = Object.new
      self.instance_variable_set("@#{name}", mock(the_mock))
      bag[name] = the_mock
      bag
    end
  end
end

RSpec.configure do |config|
  config.mock_framework = :rr
  config.include MinilabUnitSpecHelpers
  config.include Minilab::MinilabConstants

  # Using both to minimize the amount of porting work.
  # most assertions are still test:unit based, but some
  # (like exceptions) us rspec
  config.expect_with :stdlib, :rspec
end
