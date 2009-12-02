require "rake/testtask"
require "rake/rdoctask"
require "rubygems/package_task"

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
    $LOAD_PATH << "#{APP_ROOT}/vendor/systir"
    SYSTEST_ROOT = APP_ROOT + "/test/system"
    require "systir"
    require "#{APP_ROOT}/test/system/minilab_driver.rb"
    result = Systir::Launcher.new.find_and_run_all_tests(MinilabDriver, SYSTEST_ROOT)
    raise "SYSTEM TESTS FAILED" unless result.passed?
  end

  desc "Run every suite of tests"
  task :all => [:units, :system]
end

def rdoc_options
  %w[ --line-numbers --inline-source --main README.rdoc --title minilab ]
end

gem_spec = Gem::Specification.new do |spec|
  spec.name = "minilab"
  spec.version = "1.1.1"
  spec.author = "Matt Fletcher - Atomic Object"
  spec.email = "fletcher@atomicobject.com"
  spec.homepage = "http://atomicobject.github.com/minilab"
  spec.rubyforge_project = "minilab"
  spec.platform = Gem::Platform::CURRENT
  spec.files = FileList["{lib,test,config,vendor}/**/*"].exclude("rdoc").to_a
  spec.files += %w[ Rakefile README.rdoc LICENSE CHANGES .document ] 
  spec.test_files = FileList["test/unit/*"]
  spec.has_rdoc = true
  spec.extra_rdoc_files = %w[ README.rdoc CHANGES LICENSE ]
  spec.rdoc_options = rdoc_options

  # Yup, that's right, I'm consciously bypassing the warning mechanisms
  # for summary and description. Why? Because there's nothing else that
  # needs to be said beyond this one line.
  spec.summary = "Ruby interface to Measurement Computing's miniLAB 1008"
  spec.description = "#{spec.summary} "
end 
  
Gem::PackageTask.new(gem_spec) do |pkg|
  pkg.need_tar = true
  pkg.need_zip = true
end

namespace :doc do
  desc "Generate RDoc documentation"
  Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir = "rdoc"
    rdoc.title = "minilab: Ruby library for the miniLAB 1008"
    rdoc.options = rdoc_options
    rdoc.rdoc_files.include("lib/minilab.rb", "README.rdoc", "CHANGES", "LICENSE")
  end
end
