require_relative 'argument_validation'

module NCipher; end
class NCipher::Configuration
  include NCipher::ArgumentValidation

  def initialize(hash, &block)
    hash.each(&method(:set_attribute))
    hash.each(&method(:define_accessor))
    define_reseter(hash)
    yield(self) if block_given?
  end

  def to_h
    instance_variables.map(&:to_s).each_with_object({}) do |key, rtn_hash|
      rtn_hash[key.sub(/\A@/, '').to_sym] = instance_variable_get(key)
    end
  end

  def add_validation(name, message=nil, &validation)
    singleton_class.class_eval { args_validation(name, message, &validation) }
  end

  private

  def define_reseter(initial_hash)
    define_singleton_method(:reset) { initial_hash.each(&method(:set_attribute)); self }
  end

  def define_reader(name)
    define_singleton_method(name) { instance_variable_get("@#{name}") }
  end

  def define_writer(name)
    define_singleton_method("#{name}=") {|arg| instance_variable_set("@#{name}", arg) }
  end

  def define_accessor((name, *))
    %i(reader writer).each {|function| __send__("define_#{function}", name) }
  end

  def set_attribute((name, value))
    instance_variable_set("@#{name}", value)
  end
end
