require File.expand_path(File.dirname(__FILE__)) + "/../test_helper"
require 'integration_test'
require 'minilab'

class ConnectToHardwareTest < IntegrationTest
  def setup
    super
  end

  should "setup error handling, declare the library revision, and setup each digital port for input when connecting" do
    build_and_connect_to_minilab
  end
end
