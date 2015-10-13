require 'n_cipher'

class EncodeTest < Test::Unit::TestCase
  sub_test_case '正常系' do
    test '文字列のみ' do
      assert_equal('ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん〜',
                   NCipher::encode('にゃんぱす'))
    end

    sub_test_case '引数' do
      data(
        'シード値のみ指定' => [{seed: 'えお'},
                               'おおえええええおええええおえ〜おおえええええおえええおええ〜おおえええええおえええおおえ〜'],
        'デリミタのみ指定' => [{delimiter: 'か'},
                               'ぱすぱすにすかぱすぱすゃゃかぱすぱすゃぱか'],
        'すべて指定'       => [{seed: 'えお', delimiter: 'か'},
                               'おおえええええおええええおえかおおえええええおえええおええかおおえええええおえええおおえか'])

      test 'オプション指定' do |(options, result)|
        assert_equal(result, NCipher.send(:encode, 'あいう', options))
      end
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
          NCipher.send(:encode, string, options)
        end
      end

      data do
        [*1..3, *35..37].map {|i| ["#{i}文字", [*'0'..'9', *'a'..'z', *'A'..'Z'][0, i].join] }.to_h
      end

      test 'シード値文字数' do |seed|
        case seed.size
        when 2..36
          assert_nothing_raised do
            NCipher.send(:encode, 'あいう', seed: seed)
          end
        else
          assert_raise(ArgumentError.new('Seed must be 2 to 36 characters.')) do
            NCipher.send(:encode, 'あいう', seed: seed)
          end
        end
      end

      test 'シード値とデリミタで値が重複' do
        assert_raise(ArgumentError.new('Seed and delimiter are duplicated.')) do
          NCipher::encode('にゃんぱす', seed: 'あい', delimiter: 'あ')
        end
      end

      test 'シード値内で値が重複' do
        assert_raise(ArgumentError.new('Character is duplicated in seed.')) do
          NCipher::encode('にゃんぱす', seed: 'ああ')
        end
      end
    end

    sub_test_case 'TypeError' do
      data do
        object = [123, [:foo, :bar], {foo: 'hoge', bar: 'fuga'}, :foo, nil]
        object.map {|obj| [obj.class.to_s, obj] }.to_h
      end

      test 'String以外のオブジェクト' do |obj|
        assert_raise(TypeError) { NCipher::encode(obj, seed: 'にゃんぱす', delimiter: '〜') }
        assert_raise(TypeError) { NCipher::encode('にゃんぱす', seed: obj, delimiter: '〜') }
        assert_raise(TypeError) { NCipher::encode('にゃんぱす', seed: 'にゃんぱす', delimiter: obj) }
      end
    end
  end
end
