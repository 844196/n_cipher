describe 'NCipher.configure' do
  after do
    NCipher.configure do |config|
      config.seed = 'にゃんぱす'
      config.delimiter = '〜'
    end
  end

  it 'シード値が変更できること' do
    before_result = NCipher.encode 'abc'
    NCipher.configure {|config| config.seed = '890' }
    after_result = NCipher.encode 'abc'
    expect(before_result).not_to equal(after_result)
  end

  it 'デリミタが変更できること' do
    before_result = NCipher.encode 'abc'
    NCipher.configure {|config| config.delimiter = ',' }
    after_result = NCipher.encode 'abc'
    expect(before_result).not_to equal(after_result)
  end
end
