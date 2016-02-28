describe 'NCipher.configure' do
  after { NCipher.config.reset }

  it 'シード値が変更できること' do
    expect { NCipher.configure {|config| config.seed = '890' } }.not_to raise_error
    expect(NCipher.config.seed).to eq('890')
  end

  it 'デリミタが変更できること' do
    expect { NCipher.configure {|config| config.delimiter = ',' } }.not_to raise_error
    expect(NCipher.config.delimiter).to eq(',')
  end
end

describe 'NCipher.config' do
  after { NCipher.config.reset }

  it 'Configurationクラスのインスタンスオブジェクトが返却されること' do
    expect(NCipher.config.class).to eq(NCipher::Configuration)
  end
end

describe 'NCipher::Configuration' do
  describe '#seed' do
    it { expect(NCipher.config).to respond_to(:seed) }
  end

  describe '#seed=' do
    before { NCipher.config.reset }
    after  { NCipher.config.reset }

    it 'シード値が変更できること' do
      NCipher.config.seed = '123'
      expect(NCipher.config.seed).to eq('123')
    end

    context 'シード値が1文字の場合' do
      it { expect { NCipher.config.seed = '1' }
        .to raise_error(ArgumentError, 'Seed must be 2 to 36 characters.') }
    end

    context 'シード値が2文字の場合' do
      it { expect { NCipher.config.seed = '12' }.not_to raise_error }
    end

    context 'シード値が35文字の場合' do
      it { expect { NCipher.config.seed = [*'0'..'9', *'a'..'y'].join }.not_to raise_error }
    end

    context 'シード値が36文字の場合' do
      it { expect { NCipher.config.seed = [*'0'..'9', *'a'..'z'].join }.not_to raise_error }
    end

    context 'シード値が37文字の場合' do
      it { expect { NCipher.config.seed = [*'0'..'9', *'a'..'z', '!'].join }
        .to raise_error(ArgumentError, 'Seed must be 2 to 36 characters.') }
    end

    context 'シード値が "ABC" の場合' do
      it { expect { NCipher.config.seed = 'ABC' }.not_to raise_error }
    end

    context 'シード値が "AAB" の場合' do
      it { expect { NCipher.config.seed = 'AAB' }.to raise_error(ArgumentError, 'Character is duplicated in seed.') }
    end

    context 'デリミタが "," の時' do
      before { NCipher.config.delimiter = ',' }
      after  { NCipher.config.reset }

      context 'シード値が "ABC" の場合' do
        it { expect { NCipher.config.seed = 'ABC' }.not_to raise_error }
      end

      context 'シード値が "AB," の場合' do
        it { expect { NCipher.config.seed = 'AB,' }.to raise_error(ArgumentError, 'Seed and delimiter are duplicated.') }
      end
    end
  end

  describe '#delimiter' do
    it { expect(NCipher.config).to respond_to(:delimiter) }
  end

  describe '#delimiter=' do
    before { NCipher.config.reset }
    after  { NCipher.config.reset }

    it 'デリミタが変更できること' do
      NCipher.config.delimiter = ','
      expect(NCipher.config.delimiter).to eq(',')
    end

    context 'シード値が "AB," の時' do
      before { NCipher.config.seed = 'AB,' }
      after  { NCipher.config.reset }

      context 'デリミタが "-" の場合' do
        it { expect { NCipher.config.delimiter = '-' }.not_to raise_error }
      end

      context 'デリミタが "," の場合' do
        it { expect { NCipher.config.delimiter = ',' }.to raise_error(ArgumentError, 'Delimiter and seed are duplicated.') }
      end
    end
  end

  describe '#reset' do
    before { NCipher.config.seed = 'ABC'; NCipher.config.delimiter = ',' }

    it '設定値がデフォルトに戻ること' do
      NCipher.config.reset
      expect(NCipher.config.seed).to eq('にゃんぱす')
      expect(NCipher.config.delimiter).to eq('〜')
    end
  end
end
