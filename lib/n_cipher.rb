require "n_cipher/version"

# ユニコードエスケープシーケンスを用いた簡易的な暗号化及び復号化方式を提供するモジュール
module NCipher
  # デフォルト値
  @seed = 'にゃんぱす'
  @delimiter = '〜'

  # {encode}及び{decode}での共通した処理をまとめたモジュール
  # @note このモジュールはプライベートクラスメソッドに指定されている
  module Helper
    # シード値から変換テーブルを構築する
    #
    # @example
    #   convert_table(:encode, 'あいうえお')
    #   #=> {"0"=>"あ", "1"=>"い", "2"=>"う", "3"=>"え", "4"=>"お"}
    #
    #   convert_table(:decode, 'あいうえお')
    #   #=> {"あ"=>"0", "い"=>"1", "う"=>"2", "え"=>"3", "お"=>"4"}
    #
    # @param [Symbol] mode :encodeもしくは:decodeを指定
    # @param [String] string
    #
    # @return [Hash] 変換テーブル
    #
    # @raise [RangeError] シード値が2文字以下、もしくは36文字以上の場合
    def convert_table(mode, seed)
      raise RangeError, 'Seed must be 2 to 36 characters.' unless seed.size.between?(2, 36)

      table = [*'0'..'9', *'a'..'z'].zip(seed.chars).reject(&:one?).to_h
      case mode
      when :encode then table
      when :decode then table.invert
      end
    end

    # 共通の引数チェックを行う
    #
    # このメソッドは{encode}及び{decode}での共通した以下の引数チェックをOAOO化するために定義されている
    # - 引数は全てStringオブジェクトか？（厳密には、文字列として扱えるか？）
    # - 引数は空でないか？
    # - シード値は2文字以上36文字以下か？
    # - シード値と区切り文字で値が重複していないか？
    # - シード値が重複していないか？
    #   - OK: 'あいう'
    #   - NG: 'ああい'（「あ」が重複）
    #
    # @param [#to_str] string
    # @param [String] seed
    # @param [String] delimiter
    #
    # @return [nil] 例外を発生させるのが目的のため、返り値はない
    #
    # @raise [ArgumentError]
    # @raise [TypeError]
    def common_argument_check(string, seed, delimiter)
      [string, seed, delimiter].each do |obj|
        raise TypeError, "Arguments must be respond to 'to_str' method." unless obj.respond_to? :to_str
      end
      raise ArgumentError, 'Seed and delimiter are duplicated.' unless (seed.chars & delimiter.chars).size.zero?
      raise ArgumentError, 'Character is duplicated in seed.' unless seed.size == seed.chars.uniq.size
    end
  end

  class << self
    attr_accessor :seed, :delimiter
    include NCipher::Helper

    # 文字列を暗号化
    #
    # @example
    #   NCipher.encode('abc') # 文字列のみ
    #   #=> "ぱすん〜ぱすぱ〜ぱすす〜"
    #
    #   NCipher.encode('abc', seed: 'うどん') # シード値を指定
    #   #=> "どうどんど〜どうどんん〜どうんうう〜"
    #
    #   NCipher.encode('abc', seed: 'うどん', delimiter: 'ひげ') # シード値、区切り文字を指定
    #   #=> "どうどんどひげどうどんんひげどうんううひげ"
    #
    # @param [String] string 暗号対象文字列
    # @param [String] seed シード値
    # @param [String] delimiter 区切り文字
    #
    # @return [String] 暗号化された文字列オブジェクト
    #
    # @raise [ArgumentError] 引数が不正な場合
    #   - 引数チェック項目については{Helper#common_argument_check}を参照
    # @raise [TypeError] 文字列オブジェクト以外が渡された場合
    #
    # @see Helper#common_argument_check
    # @see Helper#convert_table
    def encode(string, seed: @seed, delimiter: @delimiter)
      common_argument_check(string, seed, delimiter)

      table = convert_table(:encode, seed)
      string.unpack('U*').map {|c| c.to_s(seed.size).gsub(/./, table).concat(delimiter) }.join
    end

    # 文字列を復号化
    #
    # @example
    #   NCipher.decode('ぱすん〜ぱすぱ〜ぱすす〜', seed: 'にゃんぱす', delimiter: '〜')
    #   #=> "abc"
    #
    # @param [String] string 復号対象文字列
    # @param [String] seed シード値
    # @param [String] delimiter 区切り文字
    #
    # @return [String] 復号化された文字列オブジェクト
    #
    # @raise [ArgumentError] 引数が不正な場合
    #   - 復号時は{Helper#common_argument_check}に加えて以下をチェックする
    #     - 暗号文字列に区切り文字が含まれているか？
    #     - シード値に不足はないか？
    # @raise [TypeError] 文字列オブジェクト以外が渡された場合
    #
    # @see Helper#common_argument_check
    # @see Helper#convert_table
    def decode(string, seed: @seed, delimiter: @delimiter)
      common_argument_check(string, seed, delimiter)
      raise ArgumentError, 'Delimiter is not include in the cipher string.' unless string.match(delimiter)
      raise ArgumentError, 'Invalid cipher string.' unless (string.chars - "#{seed}#{delimiter}".chars).size.zero?

      table = convert_table(:decode, seed)
      string.split(delimiter).map {|ele| [ele.gsub(/./, table).to_i(seed.size)].pack('U') }.join
    end
  end

  private_class_method :convert_table, :common_argument_check
end
