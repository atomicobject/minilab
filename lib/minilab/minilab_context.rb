require "diy"
require "yaml"
require "pathname"

module Minilab
  class MinilabContext #@private
    OBJECT_DEFINITION = Pathname.new(__FILE__).dirname + "objects.yml"

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
