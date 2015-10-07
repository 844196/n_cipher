require 'n_cipher'

class DecodeTest < Test::Unit::TestCase
  test '通常利用想定' do
    assert_equal(
      'にゃんぱす',
      NCipher::decode(
        'ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん',
        seed: 'にゃんぱす', delimiter: '〜'
      )
    )
  end

  sub_test_case '異常系' do
    sub_test_case 'シード値不正' do
      test '暗号文字列にシード値が含まれていない' do
        assert_raise(ArgumentError) do
          NCipher::decode(
            'ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん',
            seed: 'あいうえお', delimiter: '〜'
          )
        end
      end

      test 'シード値が足りない' do
        assert_raise(ArgumentError) do
          NCipher::decode(
            'ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん',
            seed: 'に', delimiter: '〜'
          )
        end
      end
    end

    sub_test_case 'デリミタ不正' do
      test '暗号文字列にデリミタが含まれていない' do
        assert_raise(ArgumentError) do
          NCipher::decode(
            'ぱすすにすにぱすすゃぱすぱすすんんにぱすすゃにゃぱすすににん',
            seed: 'にゃんぱす', delimiter: '〜'
          )
        end
      end
    end

    sub_test_case '型不正' do
      data do
        object = [123, [:foo, :bar], {foo: 'hoge', bar: 'fuga'}, :foo, nil]
        object.map {|obj| [obj.class.to_s, obj] }.to_h
      end

      test 'String以外のオブジェクトを引数に指定' do |obj|
        assert_raise(TypeError) { NCipher::decode(obj, seed: 'にゃんぱす', delimiter: '〜') }
        assert_raise(TypeError) { NCipher::decode('にゃんぱす', seed: obj, delimiter: '〜') }
        assert_raise(TypeError) { NCipher::decode('にゃんぱす', seed: 'にゃんぱす', delimiter: obj) }
      end
    end

    sub_test_case '空文字' do
      test '文字列が空文字' do
        assert_raise(ArgumentError) do
          NCipher::decode(
            '',
            seed: 'にゃんぱす', delimiter: '〜'
          )
        end
      end

      test 'シード値が空文字' do
        assert_raise(ArgumentError) do
          NCipher::decode(
            'ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん',
            seed: '', delimiter: '〜'
          )
        end
      end

      test 'デリミタが空文字' do
        assert_raise(ArgumentError) do
          NCipher::decode(
            'ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん',
            seed: 'にゃんぱす', delimiter: ''
          )
        end
      end
    end
  end
end
