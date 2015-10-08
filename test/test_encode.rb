require 'n_cipher'

class EncodeTest < Test::Unit::TestCase
  test '通常利用想定' do
    assert_equal(
      'ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん〜',
      NCipher::encode('にゃんぱす')
    )
  end

  sub_test_case 'オプション指定' do
    test 'シード値のみ指定' do
      assert_equal(
        'んおおうどどん〜んおおどおおん〜んおおどうおん〜んおおうんおう〜んおおううどう〜',
        NCipher::encode('にゃんぱす', seed: 'おうどん')
      )
    end

    test 'デリミタのみ指定' do
      assert_equal(
        'ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん〜',
        NCipher::encode('にゃんぱす', delimiter: '〜')
      )
    end

    test 'シード値、デリミタ両方指定' do
      assert_equal(
        'んおおうどどん〜んおおどおおん〜んおおどうおん〜んおおうんおう〜んおおううどう〜',
        NCipher::encode('にゃんぱす', seed: 'おうどん', delimiter: '〜')
      )
    end
  end

  sub_test_case '異常系' do
    sub_test_case '重複' do
      test 'シード値とデリミタで値が重複' do
        assert_raise(ArgumentError) { NCipher::encode('にゃんぱす', seed: 'あい', delimiter: 'あ') }
      end

      test 'シード値内で値が重複' do
        assert_raise(ArgumentError) { NCipher::encode('にゃんぱす', seed: 'ああ') }
      end
    end

    sub_test_case '文字数' do
      test 'シード値が1文字' do
        assert_raise(ArgumentError) { NCipher::encode('にゃんぱす', seed: 'あ') }
      end

      test 'シード値が11文字' do
        assert_raise(ArgumentError) { NCipher::encode('にゃんぱす', seed: 'あいうえおかきくけこさ') }
      end
    end

    sub_test_case '空文字' do
      test '文字列が空文字' do
        assert_raise(ArgumentError) { NCipher::encode('') }
      end

      test 'シード値が空文字' do
        assert_raise(ArgumentError) { NCipher::encode('にゃんぱす', seed: '') }
      end

      test 'デリミタが空文字' do
        assert_raise(ArgumentError) { NCipher::encode('にゃんぱす', delimiter: '') }
      end
    end

    sub_test_case '型不正' do
      data do
        object = [123, [:foo, :bar], {foo: 'hoge', bar: 'fuga'}, :foo, nil]
        object.map {|obj| [obj.class.to_s, obj] }.to_h
      end

      test 'String以外のオブジェクトを引数に指定' do |obj|
        assert_raise(TypeError) { NCipher::encode(obj, seed: 'にゃんぱす', delimiter: '〜') }
        assert_raise(TypeError) { NCipher::encode('にゃんぱす', seed: obj, delimiter: '〜') }
        assert_raise(TypeError) { NCipher::encode('にゃんぱす', seed: 'にゃんぱす', delimiter: obj) }
      end
    end
  end
end
