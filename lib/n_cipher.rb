require "n_cipher/version"

module NCipher
  module Helper
    def convert_table(string, mode)
      table = string.chars.map.with_index(0) {|c,i| [i.to_s, c] }.to_h
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
      raise ArgumentError, 'Seed must be 2 to 10 characters.' unless seed.size.between?(2, 10)
      raise ArgumentError, 'Seed and delimiter are duplicated.' unless (seed.chars.uniq.sort & delimiter.chars.uniq.sort).size.zero?
      # シード値が重複していないか？
      #   OK: 'あいう'
      #   NG: 'ああい'（「あ」が重複）
      raise ArgumentError, 'Character is duplicated in seed.' unless seed.chars.size == seed.chars.uniq.size
    end
  end

  class << self
    include NCipher::Helper

    def encode(string, seed: 'にゃんぱす', delimiter: '〜')
      common_argument_check(string, seed, delimiter)

      string.unpack('U*').map {|c| c.to_s(seed.size).gsub(/./, convert_table(seed, :encode)).concat(delimiter) }.join
    end

    def decode(string, seed: , delimiter: )
      common_argument_check(string, seed, delimiter)
      [seed, delimiter].each do |ele|
        raise ArgumentError, "'#{ele}' is not include in the cipher string." unless ele.chars.map {|char| string.include?(char) }.all?
      end
      raise ArgumentError, 'Invalid cipher string.' unless (string.chars - "#{seed}#{delimiter}".chars).size.zero?

      string.split(delimiter).map {|ele| [ele.gsub(/./, convert_table(seed, :decode)).to_i(seed.size)].pack('U') }.join
    end
  end

  private_class_method :convert_table, :common_argument_check
end
