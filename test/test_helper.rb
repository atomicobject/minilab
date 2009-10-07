require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

$LOAD_PATH << "#{APP_ROOT}/test/integration"

%w[ behaviors hardmock-1.3.7 ].each do |lib|
  $LOAD_PATH << "#{APP_ROOT}/vendor/#{lib}/lib"
end
require "behaviors"
require "hardmock"
require "assert_error"

require "test/unit"
class Test::Unit::TestCase
  extend Behaviors
end
