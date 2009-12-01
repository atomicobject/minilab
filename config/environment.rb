unless $environment_already_defined
  $environment_already_defined = true

  APP_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")

  $LOAD_PATH << "#{APP_ROOT}/vendor/mcc"
  $LOAD_PATH << "#{APP_ROOT}/lib"
  require "#{APP_ROOT}/vendor/gems/environment"
  %w[ ffi constructor diy ].each do |lib| require lib end

  require "minilab_constants"
  Dir["#{APP_ROOT}/lib/*.rb"].reject do |file|
    file =~ /minilab_constants/
  end.each do |file|
    require file
  end
end
