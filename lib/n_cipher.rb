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
      raise ArgumentError, 'Seed and delimiter are deplicated.' unless (seed.split(//).uniq.sort & delimiter.split(//).uniq.sort) == []

      string.unpack('U*').map {|c| c.to_s(seed.size).gsub(/./, convert_table(seed, :encode)).concat(delimiter) }.join
    end

    def decode(string, seed: , delimiter: )
      [string, seed, delimiter].each do |obj|
        raise TypeError, "#{obj} is #{obj.class}. Argument must be string object." unless obj.kind_of?(String)
        raise ArgumentError, 'Invalid argument.' if obj.empty?
      end

      seed_include_in_string = -> { (string.split(//) - delimiter.split(//)).map {|ele| seed.split(//).index(ele) }.all? }
      delimiter_inclide_in_string = -> { delimiter.split(//).uniq.sort.map {|ele| string.include?(ele) }.all? }
      seed_and_delimiter_dont_overlap = -> { (seed.split(//).uniq.sort & delimiter.split(//).uniq.sort) == [] }

      case false
      when seed_include_in_string.call
        raise ArgumentError, 'Invalid seed.'
      when delimiter_inclide_in_string.call
        raise ArgumentError, 'Invalid delimiter.'
      when seed_and_delimiter_dont_overlap.call
        raise ArgumentError, 'Seed and delimiter are deplicated.'
      end

      string.split(delimiter).map {|ele| [ele.gsub(/./, convert_table(seed, :decode)).to_i(seed.size)].pack('U') }.join
    end
  end

  private_class_method :convert_table
end
