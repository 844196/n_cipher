require 'n_cipher'

class DecodeTest < Test::Unit::TestCase
  sub_test_case '正常系' do
    test '通常利用想定' do
      assert_equal('にゃんぱす',
                   NCipher.decode('ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん'))
    end

    sub_test_case '引数' do
      data(
        'シード値のみ指定' => {seed: 'にゃんぱす'},
        'デリミタのみ指定' => {delimiter: '〜'},
        'すべて指定'       => {seed: 'にゃんぱす', delimiter: '〜'})

      test 'オプション指定' do |options|
        assert_equal('abc', NCipher.send(:decode, 'ぱすん〜ぱすぱ〜ぱすす〜', options))
      end
    end
  end

  sub_test_case '異常系' do
    sub_test_case 'ArgumentError' do
      test 'シード値とデリミタで値が重複' do
        assert_raise(ArgumentError.new('Seed and delimiter are duplicated.')) do
          NCipher.decode('にゃんぱす', seed: 'あい', delimiter: 'あ')
        end
      end

      test 'シード値内で値が重複' do
        assert_raise(ArgumentError.new('Character is duplicated in seed.')) do
          NCipher.decode('にゃんぱす', seed: 'ににゃぱす', delimiter: 'ん')
        end
      end

      test 'シード値が足りない' do
        assert_raise(ArgumentError.new('Invalid cipher string.')) do
          NCipher.decode('ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん',
                         seed: 'にん', delimiter: '〜')
        end
      end

      test '暗号文字列にシード値が含まれていない' do
        assert_raise(ArgumentError.new('Invalid cipher string.')) do
          NCipher.decode('ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん',
                         seed: 'あいうえお', delimiter: '〜')
        end
      end

      test '暗号文字列にデリミタが含まれていない' do
        assert_raise(ArgumentError.new('Delimiter is not include in the cipher string.')) do
          NCipher.decode('ぱすすにすにぱすすゃぱすぱすすんんにぱすすゃにゃぱすすににん',
                         seed: 'にゃんぱす', delimiter: '〜')
        end
      end
    end

    sub_test_case 'TypeError' do
      data do
        object = ['abc', 123, [:foo, :bar], {foo: 'hoge', bar: 'fuga'}, :foo, nil]
        object.map {|obj| [obj.class.to_s, obj] }.to_h
      end

      test 'to_strメソッドの存否' do |obj|
        case obj.respond_to? :to_str
        when true
          assert_nothing_raised { NCipher.encode(obj, seed: 'にゃんぱす', delimiter: '〜') }
          assert_nothing_raised { NCipher.encode('にゃんぱす', seed: obj, delimiter: '〜') }
          assert_nothing_raised { NCipher.encode('にゃんぱす', seed: 'にゃんぱす', delimiter: obj) }
        else
          assert_raise(TypeError.new("Arguments must be respond to 'to_str' method.")) do
            NCipher.encode(obj, seed: 'にゃんぱす', delimiter: '〜')
          end
          assert_raise(TypeError.new("Arguments must be respond to 'to_str' method.")) do
            NCipher.encode('にゃんぱす', seed: obj, delimiter: '〜')
          end
          assert_raise(TypeError.new("Arguments must be respond to 'to_str' method.")) do
            NCipher.encode('にゃんぱす', seed: 'にゃんぱす', delimiter: obj)
          end
        end
      end
    end
  end
end
