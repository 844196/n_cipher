require 'n_cipher'

class DecodeTest < Test::Unit::TestCase
  sub_test_case '正常系' do
    test '通常利用想定' do
      assert_equal(
        'にゃんぱす',
        NCipher.decode('ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん',
                       seed: 'にゃんぱす', delimiter: '〜')
      )
    end
  end

  sub_test_case '異常系' do
    sub_test_case 'ArgumentError' do
      data do
        string      = ['あいう', '', '']
        seed        = ['', 'えお', '']
        delimiter   = ['', '', 'か']
        combination = string.product(seed, delimiter).uniq.select {|e| e.any?(&:empty?) }

        combination.map do |(str, sed, deli)|
          [[str, sed, deli].inspect, [str, {seed: sed, delimiter: deli}]]
        end
      end

      test '空文字' do |(string, options)|
        assert_raise(ArgumentError.new('Invalid argument.')) do
          NCipher.send(:decode, string, options)
        end
      end

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
        object = [123, [:foo, :bar], {foo: 'hoge', bar: 'fuga'}, :foo, nil]
        object.map {|obj| [obj.class.to_s, obj] }.to_h
      end

      test 'String以外のオブジェクト' do |obj|
        assert_raise(TypeError) { NCipher.decode(obj, seed: 'にゃんぱす', delimiter: '〜') }
        assert_raise(TypeError) { NCipher.decode('にゃんぱす', seed: obj, delimiter: '〜') }
        assert_raise(TypeError) { NCipher.decode('にゃんぱす', seed: 'にゃんぱす', delimiter: obj) }
      end
    end
  end
end
