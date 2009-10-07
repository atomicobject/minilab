unless $environment_already_defined
  $environment_already_defined = true

  APP_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")

  %w[ ffi-0.4.0-x86-mswin32 diy-1.1.1 constructor-1.0.2 ].each do |dir|
    $LOAD_PATH << "#{APP_ROOT}/vendor/#{dir}/lib"
  end

  %w[ ffi constructor diy ].each do |lib|
    require lib
  end

  $LOAD_PATH << "#{APP_ROOT}/vendor/mcc"
  $LOAD_PATH << "#{APP_ROOT}/lib"
  require "minilab_constants"

  Dir["#{APP_ROOT}/lib/*.rb"].reject do |file|
    file =~ /minilab_constants/
  end.each do |file|
    require file
  end
end
