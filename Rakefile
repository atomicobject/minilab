require File.expand_path(File.dirname(__FILE__) + "/config/environment")
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

namespace :test do
  desc "Run the unit tests (doesn't require hardware)"
  Rake::TestTask.new(:units) do |t|
    t.pattern = 'test/unit/**/*_test.rb'
    t.verbose = true
  end

  desc "Run the integration tests (doesn't require hardware)"
  Rake::TestTask.new(:integration) do |t|
    t.pattern = "test/integration/**/*_test.rb"
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
  task :all => [:units, :integration, :system]
end

desc "Run the unit and integration tests"
task :default => %w[ test:units test:integration ]

def rdoc_options
  %w[ --line-numbers --inline-source --main README --title minilab ]
end

gem_spec = Gem::Specification.new do |spec|
  spec.name = "minilab"
  spec.version = "1.1.0"
  spec.author = "Matt Fletcher - Atomic Object"
  spec.email = "fletcher@atomicobject.com"
  spec.homepage = "http://minilab.rubyforge.org"
  spec.rubyforge_project = "minilab"
  spec.platform = Gem::Platform::CURRENT
  spec.summary = "Ruby interface to Measurement Computing's miniLAB 1008"
  spec.files = FileList["{lib,test,config,vendor}/**/*"].exclude("rdoc").to_a
  spec.files += %w[ Rakefile README LICENSE CHANGES .document ] 
  spec.test_files = FileList["{test/unit,test/integration}/*"]
  spec.has_rdoc = true
  spec.extra_rdoc_files = %w[ README CHANGES LICENSE ]
  spec.rdoc_options = rdoc_options
end 
  
Rake::GemPackageTask.new(gem_spec) do |pkg|
  pkg.need_tar = true
  pkg.need_zip = true
end

desc "Clean the project of build artifacts"
task :clean => :clobber_package

namespace :doc do
  desc "Generate RDoc documentation"
  Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir = "rdoc"
    rdoc.title = "minilab: Ruby extension for the miniLAB 1008"
    rdoc.options = rdoc_options
    rdoc.rdoc_files.include("lib/minilab.rb", "README", "CHANGES", "LICENSE")
  end
end

namespace :release do
  desc "Upload rdoc and homepage to Rubyforge"
  task :upload_doc => 'doc:rerdoc' do
    destination = "rubyforge.org:/var/www/gforge-projects/minilab/"
    %w[ index.html minilab.jpg ].each do |file|
      sh "scp homepage/#{file} #{destination}"
    end
    sh "scp -r rdoc #{destination}"
  end
end
