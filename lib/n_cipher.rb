require 'n_cipher/version'

# ユニコードエスケープシーケンスを用いた簡易的な暗号化及び復号化方式を提供するモジュール
module NCipher
  # デフォルト値
  @seed = 'にゃんぱす'
  @delimiter = '〜'

  # 実際の暗号化、復号化を行うメソッドが定義されているモジュール
  # @note このモジュール内のメソッドはプライベートクラスメソッドに指定されているため、外部から呼び出すことはできない
  module Convert
    # シード値から変換テーブルを構築する
    #
    # @example
    #   convert_table(:encode, 'あいうえお')
    #   #=> {"0"=>"あ", "1"=>"い", "2"=>"う", "3"=>"え", "4"=>"お"}
    #
    #   convert_table(:decode, 'あいうえお')
    #   #=> {"あ"=>"0", "い"=>"1", "う"=>"2", "え"=>"3", "お"=>"4"}
    #
    # @param [Symbol] mode +:encode+もしくは+:decode+を指定
    # @param [String] seed 元となるシード値
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

    # 実際の変換処理を行う
    #
    # @param [Symbol] mode +:encode+もしくは+:decode+を指定
    # @param [String] string 対象文字列
    # @param [String] seed シード値
    # @param [String] delimiter 区切り文字
    #
    # @return [String] 変換された文字列オブジェクト
    #
    # @raise [ArgumentError]
    def convert(mode, string, seed, delimiter)
      raise ArgumentError, 'Seed and delimiter are duplicated.' unless (seed.chars & delimiter.chars).size.zero?
      raise ArgumentError, 'Character is duplicated in seed.' unless seed.size == seed.chars.uniq.size

      table = convert_table(mode.to_sym, seed)
      rtn = case mode
        when :encode
          string.unpack('U*').map {|ele| ele.to_s(seed.size).gsub(/./, table).concat(delimiter) }
        when :decode
          raise ArgumentError, 'Delimiter is not include in the cipher string.' unless string.match(delimiter)
          raise ArgumentError, 'Invalid cipher string.' unless (string.chars - "#{seed}#{delimiter}".chars).size.zero?
          string.split(delimiter).map {|ele| [ele.gsub(/./, table).to_i(seed.size)].pack('U') }
        end

      rtn.join
    end
  end

  class << self
    attr_accessor :seed, :delimiter
    include NCipher::Convert

    # 文字列を暗号化
    #
    # @note このメソッドは{Convert#convert}のラッパーメソッドである
    #
    # @example
    #   NCipher.encode('abc', seed: 'にゃんぱす', delimiter: '〜')
    #   #=> "ぱすん〜ぱすぱ〜ぱすす〜"
    #
    # @param [#to_str] string 対象文字列
    # @param [#to_str] seed シード値
    # @param [#to_str] delimiter 区切り文字
    #
    # @return [String] 暗号化された文字列オブジェクト
    #
    # @raise [ArgumentError]
    # @raise [TypeError]
    # @raise [RangeError]
    #
    # @see Convert#convert
    def encode(string, seed: @seed, delimiter: @delimiter); end

    # 文字列を復号化
    #
    # @note このメソッドは{Convert#convert}のラッパーメソッドである
    #
    # @example
    #   NCipher.decode('ぱすん〜ぱすぱ〜ぱすす〜', seed: 'にゃんぱす', delimiter: '〜')
    #   #=> "abc"
    #
    # @param [#to_str] string 対象文字列
    # @param [#to_str] seed シード値
    # @param [#to_str] delimiter 区切り文字
    #
    # @return [String] 復号化された文字列オブジェクト
    #
    # @raise [ArgumentError]
    # @raise [TypeError]
    # @raise [RangeError]
    #
    # @see Convert#convert
    def decode(string, seed: @seed, delimiter: @delimiter); end

    %i(encode decode).each do |mode|
      define_method(mode) do |string, seed: @seed, delimiter: @delimiter|
        [string, seed, delimiter].each do |obj|
          raise TypeError, "Arguments must be respond to 'to_str' method." unless obj.respond_to? :to_str
        end
        convert(mode, string.to_str, seed.to_str, delimiter.to_str)
      end
    end
  end

  private_class_method :convert_table, :convert
end
