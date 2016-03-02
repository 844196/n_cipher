describe 'NCipher::Configuration' do
  before { @config = NCipher::Configuration.new(:foo => 1, :bar => 2) }

  describe 'getter' do
    it { expect(@config.foo).to eq(1) }
    it { expect(@config.bar).to eq(2) }
    it { expect { @config.hoge }.to raise_error(NoMethodError) }
  end

  describe 'setter' do
    it { @config.foo = 3; expect(@config.foo).to eq(3) }
    it { @config.bar = 4; expect(@config.bar).to eq(4) }
    it { expect { @config.hoge = 5 }.to raise_error(NoMethodError) }
  end

  describe '#to_h' do
    it { expect(@config.to_h).to eq({:foo => 1, :bar => 2}) }
    it { @config.foo = 3; expect(@config.to_h).to eq({:foo => 3, :bar => 2}) }
  end

  describe '#reset' do
    it do
      @config.foo = '123'
      @config.bar = '456'
      expect { @config.reset }.not_to raise_error
      expect(@config.to_h).to eq({:foo => 1, :bar => 2})
    end
  end

  describe '#add_validation' do
    before do
      @config = NCipher::Configuration.new(:hoge => 123, :fuga => 456) do |setter|
        setter.add_validation(:hoge=, 'must be a fixnum') {|arg| arg.is_a? Fixnum }
      end
    end

    it do
      expect { @config.hoge = 789 }.not_to raise_error
      expect(@config.hoge).to eq(789)
      expect { @config.hoge = '789' }.to raise_error(ArgumentError, 'must be a fixnum')
    end

    it do
      expect { @config.fuga = 789 }.not_to raise_error
      expect(@config.fuga).to eq(789)
      expect { @config.fuga = '789' }.not_to raise_error
    end
  end
end
