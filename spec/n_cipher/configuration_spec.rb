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

  it { expect(NCipher.config).to respond_to(:seed) }
  it { expect(NCipher.config).to respond_to(:delimiter) }

  it '.seed=でシード値が変更できること' do
    NCipher.config.seed = '123'
    expect(NCipher.config.seed).to eq('123')
  end

  it '.delimiter=でデリミタが変更できること' do
    NCipher.config.delimiter = ','
    expect(NCipher.config.delimiter).to eq(',')
  end

  it '.resetで設定値がデフォルトに戻ること' do
    NCipher.config.reset
    expect(NCipher.config.seed).to eq('にゃんぱす')
    expect(NCipher.config.delimiter).to eq('〜')
  end
end
