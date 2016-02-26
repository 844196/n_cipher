require 'n_cipher/version'

module NCipher
  @seed = 'にゃんぱす'
  @delimiter = '〜'

  module Configuration
    attr_accessor :seed, :delimiter

    def configure
      yield self
    end
  end

  module Convert
    def convert_table(mode, seed)
      fail RangeError, 'Seed must be 2 to 36 characters.' unless seed.size.between?(2, 36)

      table = [*'0'..'9', *'a'..'z'].zip(seed.chars).reject(&:one?).to_h
      case mode
      when :encode then table
      when :decode then table.invert
      end
    end

    def validate_arguments(mode, string, seed, delimiter)
      fail ArgumentError, 'Seed and delimiter are duplicated.' unless (seed.chars & delimiter.chars).size.zero?
      fail ArgumentError, 'Character is duplicated in seed.' unless seed.size == seed.chars.uniq.size

      if mode == :decode
        fail ArgumentError, 'Delimiter is not include in the cipher string.' unless string.match(delimiter)
        fail ArgumentError, 'Invalid cipher string.' unless (string.chars - "#{seed}#{delimiter}".chars).size.zero?
      end

      true
    end

    def convert(mode, string, seed, delimiter)
      validate_arguments(mode, string, seed, delimiter)

      table = convert_table(mode.to_sym, seed)
      rtn = case mode
            when :encode
              string.unpack('U*').map {|ele| ele.to_s(seed.size).gsub(/./, table).concat(delimiter) }
            when :decode
              string.split(delimiter).map {|ele| [ele.gsub(/./, table).to_i(seed.size)].pack('U') }
            end

      rtn.join
    end
  end

  class << self
    include NCipher::Configuration
    include NCipher::Convert

    def encode(string, seed: @seed, delimiter: @delimiter)
      [string, seed, delimiter].each do |obj|
        fail TypeError, "Arguments must be respond to 'to_str' method." unless obj.respond_to? :to_str
      end
      convert(:encode, string.to_str, seed.to_str, delimiter.to_str)
    end

    def decode(string, seed: @seed, delimiter: @delimiter)
      [string, seed, delimiter].each do |obj|
        fail TypeError, "Arguments must be respond to 'to_str' method." unless obj.respond_to? :to_str
      end
      convert(:decode, string.to_str, seed.to_str, delimiter.to_str)
    end
  end

  private_class_method :convert_table, :convert
end
