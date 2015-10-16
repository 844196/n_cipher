require 'n_cipher'

class ConfigurationTest < Test::Unit::TestCase
  test 'メソッド呼び出し' do
    assert_respond_to NCipher, :configure
  end

  test 'シード値設定' do
    NCipher.configure {|config| config.seed = '890' }
    old = NCipher.encode 'abc'

    NCipher.configure {|config| config.seed = '123' }
    new = NCipher.encode 'abc'

    assert_not_equal old, new
  end

  test 'デリミタ設定' do
    NCipher.configure {|config| config.delimiter = ',' }
    old = NCipher.encode 'abc'

    NCipher.configure {|config| config.delimiter = '-' }
    new = NCipher.encode 'abc'

    assert_not_equal old, new
  end
end
