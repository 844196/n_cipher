describe NCipher::ArgumentValidation do
  before do
    @klass = Class.new.class_eval do
      include NCipher::ArgumentValidation
      def test_method(arg); arg; end
      args_validation(:test_method, 'Not string!') {|arg| arg.kind_of? String }
      args_validation(:test_method, 'Too short!') {|arg| arg.length >= 3 }
    end
  end

  describe '基本機能' do
    it 'メソッド引数に対してバリデーションを設定できること' do
      expect {
        @klass.class_eval do
          args_validation(:test_method, 'Too short!') {|arg| arg.length >= 3 }
        end
      }.not_to raise_error
    end

    it 'エラーメッセージは省略できること' do
      expect {
        @klass.class_eval do
          args_validation(:test_method, 'Too short!') {|arg| arg.length >= 3 }
        end
      }.not_to raise_error
      expect {
        @klass.class_eval do
          args_validation(:test_method) {|arg| arg.length <= 5 }
        end
      }.not_to raise_error
    end

    it 'args_validationはクラス定義のコンテキストでのみアクセスできること' do
      expect(@klass).not_to respond_to(:args_validation)
    end

    it 'バリデーション一覧が確認できること' do
      expect(@klass.new.method(:test_method).validation.size).to eq(2)
    end

    it 'バリデーションチェックが機能すること' do
      expect { @klass.new.test_method(1234) }.to raise_error(ArgumentError, 'Not string!')
      expect { @klass.new.test_method('12') }.to raise_error(ArgumentError, 'Too short!')
    end

    it 'ブロック内のコンテキストはクラスのインスタンス内であること' do
      @klass.class_eval do
        def initialize; @instance_variable = 'get_instance_variable'; end
        args_validation(:test_method) {|arg| arg == @instance_variable }
      end
      expect { @klass.new.test_method('get_instance_variable') }.not_to raise_error
    end

    it 'メソッド名はシンボルでも文字列でも受け付けること' do
      @klass.class_eval do
        args_validation('test_method', 'Too long!') {|arg| arg.length <= 5 }
      end
      expect { @klass.new.test_method(1234) }.to raise_error(ArgumentError, 'Not string!')
      expect { @klass.new.test_method('12') }.to raise_error(ArgumentError, 'Too short!')
      expect { @klass.new.test_method('123456') }.to raise_error(ArgumentError, 'Too long!')
    end
  end

  context 'インクルードしたクラスが親クラスとして継承された場合' do
    before { @inherited_klass = Class.new(@klass) }

    it '継承してもバリデーションが機能すること' do
      expect { @inherited_klass.new.test_method(1234) }.to raise_error(ArgumentError, 'Not string!')
      expect { @inherited_klass.new.test_method('12') }.to raise_error(ArgumentError, 'Too short!')
    end

    it '継承先で既存のメソッドにバリデーションを追加できること' do
      @inherited_klass.class_eval do
        args_validation(:test_method, 'Too long!') {|arg| arg.length <= 5 }
      end
      expect { @inherited_klass.new.test_method(1234) }.to raise_error(ArgumentError, 'Not string!')
      expect { @inherited_klass.new.test_method('12') }.to raise_error(ArgumentError, 'Too short!')
      expect { @inherited_klass.new.test_method('123456') }.to raise_error(ArgumentError, 'Too long!')
    end

    it '継承元と継承先のバリデーションは独立していること' do
      @inherited_klass.class_eval do
        args_validation(:test_method, 'Too long!') {|arg| arg.length <= 5 }
      end
      expect { @klass.new.test_method('123456') }.not_to raise_error
      expect { @inherited_klass.new.test_method('123456') }.to raise_error(ArgumentError, 'Too long!')
    end
  end

  context '1つの親クラスが2つの子クラスへ継承された場合' do
    it 'バリデーションは子クラス間で共有されないこと' do
      inherited_klass_a = Class.new(@klass).class_eval do
        args_validation(:test_method, 'Too long!') {|arg| arg.length <= 4 }
      end
      inherited_klass_b = Class.new(@klass).class_eval do
        args_validation(:test_method, 'Too long!') {|arg| arg.length <= 5 }
      end

      # base class
      expect { @klass.new.test_method('12') }.to raise_error(ArgumentError, 'Too short!')
      expect { @klass.new.test_method('123') }.not_to raise_error
      expect { @klass.new.test_method('1234') }.not_to raise_error
      expect { @klass.new.test_method('12345') }.not_to raise_error
      expect { @klass.new.test_method('123456') }.not_to raise_error

      # inherited class A
      expect { inherited_klass_a.new.test_method('12') }.to raise_error(ArgumentError, 'Too short!')
      expect { inherited_klass_a.new.test_method('123') }.not_to raise_error
      expect { inherited_klass_a.new.test_method('1234') }.not_to raise_error
      expect { inherited_klass_a.new.test_method('12345') }.to raise_error(ArgumentError, 'Too long!')
      expect { inherited_klass_a.new.test_method('123456') }.to raise_error(ArgumentError, 'Too long!')

      # inherited class B
      expect { inherited_klass_b.new.test_method('12') }.to raise_error(ArgumentError, 'Too short!')
      expect { inherited_klass_b.new.test_method('123') }.not_to raise_error
      expect { inherited_klass_b.new.test_method('1234') }.not_to raise_error
      expect { inherited_klass_b.new.test_method('12345') }.not_to raise_error
      expect { inherited_klass_b.new.test_method('123456') }.to raise_error(ArgumentError, 'Too long!')
    end
  end

  context 'モジュールの特異クラスにインクルードされた場合' do
    it '正しく機能すること' do
      test_module = Module.new
      class << test_module
        include NCipher::ArgumentValidation
        def test_method(arg); arg; end
        args_validation(:test_method, 'Not string!') {|arg| arg.kind_of? String }
        args_validation(:test_method, 'Too short!') {|arg| arg.length >= 3 }
      end

      expect(test_module).not_to respond_to(:args_validation)
      expect(test_module.method(:test_method).validation.size).to eq(2)
      expect { test_module.test_method(1234) }.to raise_error(ArgumentError, 'Not string!')
      expect { test_module.test_method('12') }.to raise_error(ArgumentError, 'Too short!')
    end
  end
end
