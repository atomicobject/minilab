require "diy"
require "yaml"

module Minilab
  class MinilabContext #:nodoc:
    OBJECT_DEFINITION = File.dirname(__FILE__) + "/objects.yml"

    def build
      if not @context
        DIY::Context.auto_require = false
        @context = DIY::Context.new(YAML.load_file(OBJECT_DEFINITION))
        @context.build_everything
      end
      @context
    end
  end
end
