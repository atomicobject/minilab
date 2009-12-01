# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{constructor}
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Atomic Object"]
  s.date = %q{2009-11-30}
  s.description = %q{== DESCRIPTION:

Declarative means to define object properties by passing a hash 
to the constructor, which will set the corresponding ivars.}
  s.email = %q{dev@atomicobject.com}
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/constructor.rb", "lib/constructor_struct.rb", "specs/constructor_spec.rb", "specs/constructor_struct_spec.rb"]
  s.homepage = %q{http://atomicobjectrb.rubyforge.org/constructor}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{atomicobjectrb}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Declarative, named constructor arguments.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end
