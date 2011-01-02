require 'yaml'

class MinilabContext #:nodoc:
  OBJECT_DEFINITION = APP_ROOT + "/config/objects.yml"

  def build
    if not @context
      DIY::Context.auto_require = false
      @context = DIY::Context.new(YAML.load_file(OBJECT_DEFINITION))
      @context.build_everything
    end
    @context
  end
end
