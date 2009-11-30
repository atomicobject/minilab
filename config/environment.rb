unless $environment_already_defined
  $environment_already_defined = true

  APP_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")

  # Bah - can't figure out how to freeze ffi with bundler
  # I don't think it is possible to specify a platform-specific
  # gem to bundler right now.
  $LOAD_PATH << "#{APP_ROOT}/vendor/ffi-0.4.0-x86-mswin32/lib"
  require "#{APP_ROOT}/vendor/gems/environment"
  %w[ ffi constructor diy ].each do |lib| require lib end

  $LOAD_PATH << "#{APP_ROOT}/vendor/mcc"
  $LOAD_PATH << "#{APP_ROOT}/lib"
  require "minilab_constants"

  Dir["#{APP_ROOT}/lib/*.rb"].reject do |file|
    file =~ /minilab_constants/
  end.each do |file|
    require file
  end
end
