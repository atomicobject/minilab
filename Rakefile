require "rspec/core/rake_task"

desc "Run the unit specs"
task :default => "spec:unit"

namespace :spec do
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "spec/unit/**/*_spec.rb"
  end

  RSpec::Core::RakeTask.new(:acceptance) do |t|
    t.pattern = "spec/acceptance/**/*_spec.rb"
  end

  desc "all tests"
  task :all => %w[ spec:unit spec:acceptance ]
end
