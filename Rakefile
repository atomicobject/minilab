require "rake/testtask"
require "rake/rdoctask"

desc "Clean the project of build artifacts"
task :clean => :clobber_package

desc "Run the unit tests"
task :default => "test:units"

namespace :test do
  desc "Run the unit tests (doesn't require hardware)"
  Rake::TestTask.new(:units) do |t|
    t.pattern = "test/unit/**/*_test.rb"
    t.verbose = true
  end

  desc "Run the system tests (requires hardware)"
  task :system do
    root = File.dirname(__FILE__)
    $LOAD_PATH << "#{root}/vendor/systir"
    SYSTEST_ROOT = root + "/test/system"
    require "systir"
    require "#{root}/test/system/minilab_driver.rb"
    result = Systir::Launcher.new.find_and_run_all_tests(MinilabDriver, SYSTEST_ROOT)
    raise "SYSTEM TESTS FAILED" unless result.passed?
  end

  desc "Run every suite of tests"
  task :all => [:units, :system]
end

namespace :doc do
  desc "Generate RDoc documentation"
  Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir = "rdoc"
    rdoc.title = "minilab: Ruby library for the miniLAB 1008"
    rdoc.options = %w[ --line-numbers --inline-source --main README.rdoc --title minilab ]
    rdoc.rdoc_files.include("lib/minilab.rb", "README.rdoc", "CHANGES", "LICENSE")
  end
end
