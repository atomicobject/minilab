require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"
require 'integration_test'

class RequireMinilabTest < IntegrationTest
  should "be able to require the minilab class without error" do
    `ruby -e "require 'lib/minilab'"`
    assert $?.success?, "failed to require minilab without error"
  end
end
