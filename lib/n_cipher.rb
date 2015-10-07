require "n_cipher/version"

module NCipher
  module Helper
    def convert_table(string, mode)
      table = string.split('').map.with_index(0) {|c,i| [i.to_s, c] }.to_h
      case mode
      when :encode then table
      when :decode then table.invert
      end
    end
  end

  class << self
    include NCipher::Helper

    def encode(string, seed: 'にゃんぱす', delimiter: '〜')
      [string, seed, delimiter].each do |obj|
        raise TypeError, "#{obj} is #{obj.class}. Argument must be string object." unless obj.kind_of?(String)
        raise ArgumentError, 'Invalid argument.' if obj.empty?
      end
      raise ArgumentError, 'Seed must be 2 to 10 characters.' unless seed.size.between?(2,10)

      string.unpack('U*').map {|c| c.to_s(seed.size).gsub(/./, convert_table(seed, :encode)).concat(delimiter) }.join
    end
  end

  private_class_method :convert_table
end
