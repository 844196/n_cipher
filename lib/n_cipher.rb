require "n_cipher/version"

module NCipher
  module Helper
    def is_empty?(object)
      object.to_s.empty?
    end

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
      raise ArgumentError if is_empty?(string) or is_empty?(seed) or is_empty?(delimiter) or seed.size > 10
      string.unpack('U*').map {|c| c.to_s(seed.size).gsub(/./, convert_table(seed, :encode)) }.join(delimiter)
    end
  end

  private_class_method :is_empty?, :convert_table
end
