describe 'NCipher.encode' do
  before { NCipher.config.reset }
  after  { NCipher.config.reset }

  context '文字列オブジェクトを渡された場合' do
    it '暗号化できること' do
      expect(NCipher.encode('にゃんぱす'))
        .to eq('ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん')
    end
  end

  context '文字列オブジェクト以外が渡された場合' do
    it 'to_strに応答するオブジェクトであれば結果を返すこと' do
      class Have_to_str_Object; def to_str; 'hi!'; end; end
      object = Have_to_str_Object.new

      expect { NCipher.encode(object) }.not_to raise_error
    end

    it 'to_strに応答しないオブジェクトが渡された場合は例外が発生すること' do
      class DoNotHave_to_str_Object; end
      object = DoNotHave_to_str_Object.new

      expect { NCipher.encode(object) }
        .to raise_error(ArgumentError, "Arguments must be respond to 'to_str' method.")
    end
  end
end
