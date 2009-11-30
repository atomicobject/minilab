# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{diy}
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Atomic Object"]
  s.date = %q{2009-11-01}
  s.description = %q{DIY (Dependency Injection in YAML) is a simple dependency injection library
which focuses on declarative composition of objects through constructor injection.}
  s.email = %q{dev@atomicobject.com}
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt", "TODO.txt", "homepage/Notes.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "TODO.txt", "homepage/Notes.txt", "homepage/Rakefile", "homepage/diy_example.png", "homepage/index.erb", "homepage/index.html", "homepage/objects_yml.png", "homepage/page_header.graffle", "homepage/page_header.html", "homepage/page_header.png", "lib/diy.rb", "sample_code/car.rb", "sample_code/chassis.rb", "sample_code/diy_example.rb", "sample_code/engine.rb", "sample_code/objects.yml", "test/constructor.rb", "test/diy_test.rb", "test/files/broken_construction.yml", "test/files/cat/cat.rb", "test/files/cat/extra_conflict.yml", "test/files/cat/heritage.rb", "test/files/cat/needs_input.yml", "test/files/cat/the_cat_lineage.rb", "test/files/dog/dog_model.rb", "test/files/dog/dog_presenter.rb", "test/files/dog/dog_view.rb", "test/files/dog/file_resolver.rb", "test/files/dog/other_thing.rb", "test/files/dog/simple.yml", "test/files/donkey/foo.rb", "test/files/donkey/foo/bar/qux.rb", "test/files/fud/objects.yml", "test/files/fud/toy.rb", "test/files/functions/attached_things_builder.rb", "test/files/functions/invalid_method.yml", "test/files/functions/method_extractor.rb", "test/files/functions/nonsingleton_objects.yml", "test/files/functions/objects.yml", "test/files/functions/thing.rb", "test/files/functions/thing_builder.rb", "test/files/functions/things_builder.rb", "test/files/gnu/objects.yml", "test/files/gnu/thinger.rb", "test/files/goat/base.rb", "test/files/goat/can.rb", "test/files/goat/goat.rb", "test/files/goat/objects.yml", "test/files/goat/paper.rb", "test/files/goat/plane.rb", "test/files/goat/shirt.rb", "test/files/goat/wings.rb", "test/files/horse/holder_thing.rb", "test/files/horse/objects.yml", "test/files/namespace/animal/bird.rb", "test/files/namespace/animal/cat.rb", "test/files/namespace/animal/reptile/hardshell/turtle.rb", "test/files/namespace/animal/reptile/lizard.rb", "test/files/namespace/bad_module_specified.yml", "test/files/namespace/class_name_combine.yml", "test/files/namespace/hello.txt", "test/files/namespace/no_module_specified.yml", "test/files/namespace/objects.yml", "test/files/namespace/road.rb", "test/files/namespace/sky.rb", "test/files/namespace/subcontext.yml", "test/files/non_singleton/air.rb", "test/files/non_singleton/fat_cat.rb", "test/files/non_singleton/objects.yml", "test/files/non_singleton/pig.rb", "test/files/non_singleton/thread_spinner.rb", "test/files/non_singleton/tick.rb", "test/files/non_singleton/yard.rb", "test/files/yak/core_model.rb", "test/files/yak/core_presenter.rb", "test/files/yak/core_view.rb", "test/files/yak/data_source.rb", "test/files/yak/fringe_model.rb", "test/files/yak/fringe_presenter.rb", "test/files/yak/fringe_view.rb", "test/files/yak/giant_squid.rb", "test/files/yak/krill.rb", "test/files/yak/my_objects.yml", "test/files/yak/sub_sub_context_test.yml", "test/test_helper.rb", "test/factory_test.rb"]
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{atomicobjectrb}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Constructor-based dependency injection container using YAML input.}
  s.test_files = ["test/diy_test.rb", "test/factory_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<constructor>, [">= 1.0.0"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<constructor>, [">= 1.0.0"])
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<constructor>, [">= 1.0.0"])
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end