describe 'NCipher.decode' do
  before { NCipher.config.reset }
  after  { NCipher.config.reset }

  context '文字列オブジェクトが渡された場合' do
    context '正しい暗号文字列が渡された場合' do
      it '復号化できること' do
        valid_crypt_str = 'ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん'
        expect(NCipher.decode(valid_crypt_str)).to eq('にゃんぱす')
      end
    end

    context '暗号文字列にシード値が含まれていない場合' do
      it do
        expect { NCipher.decode('あいう〜あい〜あああ〜') }
          .to raise_error(ArgumentError, 'Invalid cipher string.')
      end
    end

    context '暗号文字列にシード値・デリミタ以外の文字が含まれていた場合' do
      it do
        expect { NCipher.decode('にゃんぱす〜にゃん〜ぱす〜あ〜') }
          .to raise_error(ArgumentError, 'Invalid cipher string.')
      end
    end

    context '暗号文字列にデリミタが含まれていない場合' do
      it do
        expect { NCipher.decode('にゃんぱす,にゃん,ぱす,') }
          .to raise_error(ArgumentError, 'Delimiter is not include in the cipher string.')
      end
    end
  end

  context '文字列オブジェクト以外が渡された場合' do
    it 'to_strに応答するオブジェクトであれば結果を返すこと' do
      class Have_to_str_Object
        def to_str
          'ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん'
        end
      end
      object = Have_to_str_Object.new

      expect { NCipher.decode(object) }.not_to raise_error
    end

    it 'to_strに応答しないオブジェクトが渡された場合は例外が発生すること' do
      class DoNotHave_to_str_Object; end
      object = DoNotHave_to_str_Object.new

      expect { NCipher.decode(object) }
        .to raise_error(ArgumentError, "Arguments must be respond to 'to_str' method.")
    end
  end
end
