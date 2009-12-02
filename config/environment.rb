APP_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")

$LOAD_PATH << "#{APP_ROOT}/vendor/mcc"
$LOAD_PATH << "#{APP_ROOT}/lib"
require "#{APP_ROOT}/vendor/gems/environment"

require "minilab_constants"
Dir["#{APP_ROOT}/lib/*.rb"].reject do |file|
  file =~ /minilab_constants/
end.each do |file|
  require file
end
