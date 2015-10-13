require "n_cipher/version"

module NCipher
  module Helper
    def convert_table(string, mode)
      table = [*'0'..'9', *'a'..'z'].zip(string.chars).reject(&:one?).to_h
      case mode
      when :encode then table
      when :decode then table.invert
      end
    end

    def common_argument_check(string, seed, delimiter)
      [string, seed, delimiter].each do |obj|
        raise TypeError, "#{obj} is #{obj.class} object. Argument must be string object." unless obj.kind_of?(String)
        raise ArgumentError, 'Invalid argument.' if obj.empty?
      end
      raise ArgumentError, 'Seed must be 2 to 36 characters.' unless seed.size.between?(2, 36)
      raise ArgumentError, 'Seed and delimiter are duplicated.' unless (seed.chars & delimiter.chars).size.zero?
      # シード値が重複していないか？
      #   OK: 'あいう'
      #   NG: 'ああい'（「あ」が重複）
      raise ArgumentError, 'Character is duplicated in seed.' unless seed.size == seed.chars.uniq.size
    end
  end

  class << self
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
    # @return [String] 暗号化されたStringオブジェクト
    #
    # @raise [ArgumentError] 引数が不正な場合
    #   - 引数チェック項目については{Helper#common_argument_check}を参照
    # @raise [TypeError] 文字列オブジェクト以外が渡された場合
    #
    # @see Helper#common_argument_check
    # @see Helper#convert_table
    def encode(string, seed: 'にゃんぱす', delimiter: '〜')
      common_argument_check(string, seed, delimiter)

      string.unpack('U*').map {|c| c.to_s(seed.size).gsub(/./, convert_table(seed, :encode)).concat(delimiter) }.join
    end

    def decode(string, seed: , delimiter: )
      common_argument_check(string, seed, delimiter)
      raise ArgumentError, 'Delimiter is not include in the cipher string.' unless string.match(delimiter)
      raise ArgumentError, 'Invalid cipher string.' unless (string.chars - "#{seed}#{delimiter}".chars).size.zero?

      string.split(delimiter).map {|ele| [ele.gsub(/./, convert_table(seed, :decode)).to_i(seed.size)].pack('U') }.join
    end
  end

  private_class_method :convert_table, :common_argument_check
end
