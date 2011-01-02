require_relative "../lib/minilab"

RSpec.configure do |config|
  config.expect_with :stdlib
  config.mock_framework = :rr
end
