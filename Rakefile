require "rake/rdoctask"
require "rspec/core/rake_task"

desc "Run the unit specs"
task :default => "spec:unit"

namespace :spec do
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "spec/unit/**/*_spec.rb"
  end

  RSpec::Core::RakeTask.new(:system) do |t|
    t.pattern = "spec/system/**/*_spec.rb"
  end
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
