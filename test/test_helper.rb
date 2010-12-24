require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

require "test/unit"
require "hardmock"
require "assert_error" # comes from hardmock

$LOAD_PATH << "#{APP_ROOT}/vendor/behaviors/lib"
require "behaviors"

class Test::Unit::TestCase
  extend Behaviors
end
