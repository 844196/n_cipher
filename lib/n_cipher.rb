module NCipher; end
require 'n_cipher/version'
require 'n_cipher/argument_validation'
require 'n_cipher/configuration'

class << NCipher
  include NCipher::ArgumentValidation

  def encode(string)
    string
      .to_str
      .unpack('U*')
      .map {|char| char.to_s(NCipher.config.seed.length) }
      .map {|char| char.gsub(/./, convert_table(:for => :encode)) }
      .join(NCipher.config.delimiter)
  end

  def decode(string)
    string
      .to_str
      .split(NCipher.config.delimiter)
      .map {|char| char.gsub(/./, convert_table(:for => :decode)) }
      .map {|char| char.to_i(NCipher.config.seed.length) }
      .map {|char| [char].pack('U') }
      .join
  end

  args_validation :encode, "Arguments must be respond to 'to_str' method." do |string|
    string.respond_to? :to_str
  end

  args_validation :decode, "Arguments must be respond to 'to_str' method." do |string|
    string.respond_to? :to_str
  end

  args_validation :decode, 'Delimiter is not include in the cipher string.' do |string|
    string.to_str.match(NCipher.config.delimiter)
  end

  args_validation :decode, 'Invalid cipher string.' do |string|
    (string.to_str.chars - "#{NCipher.config.seed.join}#{NCipher.config.delimiter}".chars).size.zero?
  end

  private

  def convert_table(param={:for => nil})
    table = [*'0'..'9', *'a'..'z'].zip(NCipher.config.seed).reject(&:one?).to_h
    case param[:for]
    when :encode then table
    when :decode then table.invert
    end
  end
end
