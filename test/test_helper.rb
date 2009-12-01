require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

Bundler.require_env :test
require "assert_error" # comes from hardmock

$LOAD_PATH << "#{APP_ROOT}/vendor/behaviors/lib"
require "behaviors"

require "test/unit"
class Test::Unit::TestCase
  extend Behaviors
end
