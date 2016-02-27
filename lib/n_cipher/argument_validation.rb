module NCipher; end
module NCipher::ArgumentValidation
  @@validations = {}

  def self.included(klass)
    klass.extend(ClassMethod)
    klass.extend(InheritValidation)
    Method.send(:include, MonkeyPatchToMethodClass)
  end

  module MonkeyPatchToMethodClass
    def validation
      ::NCipher::ArgumentValidation.validations[owner]["__#{name}__"]
    end
  end

  module InheritValidation
    def inherited(klass)
      super
      # 継承先へバリデーションをディープコピー
      baseclass_validations = ::NCipher::ArgumentValidation.validations[self]
      ::NCipher::ArgumentValidation.validations[klass] = baseclass_validations.map {|k, v| [k, v.map(&:clone)] }.to_h
    end
  end

  module ClassMethod
    private

    def args_validation(method, message=nil, &validation)
      exception = ArgumentError.new(message).tap do |ex|
        # バックトレースの偽装
        ex.set_backtrace(validation.source_location.push("in `args_validation'").join(':'))
      end

      ::NCipher::ArgumentValidation.store_validation(self, "__#{method}__", validation, exception)

      unless private_method_defined?("__#{method}__")
        ::NCipher::ArgumentValidation.around_alias(self, "__#{method}__", method)
        ::NCipher::ArgumentValidation.define_proxy_method(self, method)
      end

      self
    end
  end

  class << self
    def store_validation(owner, method_name, validation, exception)
      @@validations[owner] ||= {}
      @@validations[owner][method_name] ||= []
      @@validations[owner][method_name] << {
        :validation => validation,
        :exception  => exception
      }
    end

    def define_proxy_method(owner, name)
      owner.class_eval do
        define_method(name) do |*args, &block|
          validations = ::NCipher::ArgumentValidation
            .validations
            .values_at(self.class, self.singleton_class)
            .compact
            .each_with_object({}) {|orig_h,rtn_h| rtn_h.merge!(orig_h) }

          validations["__#{name}__"].each do |pattern|
            # ブロックをインスタンスのコンテキストで評価
            raise(pattern[:exception]) unless self.instance_exec(*args, block, &pattern[:validation])
          end

          __send__("__#{name}__", *args, &block)
        end
      end
    end

    def around_alias(owner, new_name, old_name)
      owner.class_eval do
        private(old_name)
        alias_method new_name, old_name
      end
    end

    def validations
      @@validations
    end
  end
end
