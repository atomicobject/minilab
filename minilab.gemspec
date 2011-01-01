# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "minilab/version"

Gem::Specification.new do |s|
  s.name        = "minilab"
  s.version     = Minilab::VERSION
  s.platform    = Gem::Platform::CURRENT
  s.authors     = ["Matt Fletcher"]
  s.email       = ["fletcher@atomicobject.com"]
  s.homepage    = "http://atomicobject.github.com/minilab"
  s.summary     = %q{Ruby interface to Measurement Computing's miniLAB 1008}
  s.description = "#{s.summary} "

  s.add_dependency "constructor", "~>2.0"
  s.add_dependency "diy", "~>1.1"
  s.add_dependency "ffi", "~>1.0"

  s.add_development_dependency "steak", "~>1.0"

  s.rubyforge_project = "minilab"

  s.has_rdoc         = true
  s.extra_rdoc_files = %w[ README.rdoc CHANGES LICENSE ]
  s.rdoc_options     = %w[ --line-numbers --inline-source --main README.rdoc --title minilab ]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
