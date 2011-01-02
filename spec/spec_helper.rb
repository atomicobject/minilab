require_relative "../lib/minilab"

RSpec.configure do |config|
  config.mock_framework = :rr

  # Using both to minimize the amount of porting work.
  # most assertions are still test:unit based, but some
  # (like exceptions) us rspec
  config.expect_with :stdlib, :rspec
end
