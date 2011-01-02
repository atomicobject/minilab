require_relative "../config/env.rb"

RSpec.configure do |config|
  config.expect_with :stdlib
  config.mock_framework = :rr
end
