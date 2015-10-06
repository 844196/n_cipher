require 'n_cipher'

class EncodeTest < Test::Unit::TestCase
  test '通常利用想定' do
    assert_equal(
      'ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん',
      NCipher::encode('にゃんぱす')
    )
  end

  sub_test_case 'オプション指定' do
    test 'シード値のみ指定' do
      assert_equal(
        'んおおうどどん〜んおおどおおん〜んおおどうおん〜んおおうんおう〜んおおううどう',
        NCipher::encode('にゃんぱす', seed: 'おうどん')
      )
    end

    test 'デリミタのみ指定' do
      assert_equal(
        'ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん',
        NCipher::encode('にゃんぱす', delimiter: '〜')
      )
    end

    test 'シード値、デリミタ両方指定' do
      assert_equal(
        'んおおうどどん〜んおおどおおん〜んおおどうおん〜んおおうんおう〜んおおううどう',
        NCipher::encode('にゃんぱす', seed: 'おうどん', delimiter: '〜')
      )
    end
  end

  sub_test_case '異常系' do
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

    sub_test_case 'nil' do
      test '文字列がnil' do
        assert_raise(ArgumentError) { NCipher::encode(nil) }
      end

      test 'シード値がnil' do
        assert_raise(ArgumentError) { NCipher::encode('にゃんぱす', seed: nil) }
      end

      test 'デリミタがnil' do
        assert_raise(ArgumentError) { NCipher::encode('にゃんぱす', delimiter: nil) }
      end
    end
  end
end
