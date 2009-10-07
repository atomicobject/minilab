require 'yaml'

class MinilabContext #:nodoc:
  def build
    minilab_context = self.class.get_context
    minilab_context.build_everything
    minilab_context
  end

  def self.clear
    @@context = nil
  end

  def self.inject(options)
    object, instance = get_parameters(options)

    get_context[object] = instance
  end
  
  private
  def self.get_parameters(options)
    raise "parameters hash was nil" if options.nil?
    object = options[:object]
    instance = options[:instance]
    raise "missing parameter :object" if object.nil?
    raise "missing parameter :instance" if instance.nil?
    [object, instance]
  end

  def self.get_context
    DIY::Context.auto_require = false
    @@context ||= DIY::Context.new(YAML.load(object_definition))
    @@context
  end

  def self.object_definition
    File.read(APP_ROOT + "/config/objects.yml")
  end
end
