module NCipher::ArgumentValidation
  def self.included(klass)
    klass.class_eval { @__args_validations__ ||= Hash.new {|h,k| h[k] = [] } }
    klass.extend(InheritValidation)
    klass.extend(ClassMethod)
  end

  module InheritValidation
    def inherited(klass)
      super
      # 継承先へバリデーションをディープコピー
      baseclass_validations = @__args_validations__.map {|k,v| [k, v.clone] }.to_h
      klass.class_eval { @__args_validations__ = baseclass_validations }
    end
  end

  module ClassMethod
    def __args_validations__
      @__args_validations__
    end

    private

    def args_validation(method, message=nil, &validation)
      exception = ArgumentError.new(message).tap do |ex|
        # バックトレースの偽装
        ex.set_backtrace(validation.source_location.push("in `args_validation'").join(':'))
      end

      @__args_validations__[method.to_sym] << {
        :validation => validation,
        :exception  => exception
      }

      return if private_method_defined?("__#{method}__")

      # オリジナルメソッドの可視性をprivateにして退避
      private(method); alias_method("__#{method}__", method)

      define_method(method) do |*args, &block|
        self.class.instance_variable_get("@__args_validations__")[method].each do |pattern|
          # ブロックをインスタンスのコンテキストで評価
          raise(pattern[:exception]) unless self.instance_exec(*args, block, &pattern[:validation])
        end
        __send__("__#{method}__", *args, &block)
      end
    end
  end
end
