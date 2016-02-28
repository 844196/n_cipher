module NCipher; end
require 'n_cipher/version'
require 'n_cipher/argument_validation'
require 'n_cipher/configuration'

class << NCipher
  include NCipher::ArgumentValidation

  def config
    @config ||= NCipher::Configuration.new(:seed => 'にゃんぱす', :delimiter => '〜') do |setter|
      setter.add_validation :seed=, 'Seed must be 2 to 36 characters.' do |seed|
        seed.length.between?(2, 36)
      end

      setter.add_validation :seed=, 'Character is duplicated in seed.' do |seed|
        seed.length == seed.chars.uniq.length
      end

      setter.add_validation :seed=, 'Seed and delimiter are duplicated.' do |seed|
        !seed.include?(@delimiter)
      end

      setter.add_validation :delimiter=, 'Delimiter and seed are duplicated.' do |delimiter|
        !@seed.include?(delimiter)
      end
    end
  end

  def configure(&block)
    block.call(config)
  end

  def encode(string)
    string
      .to_str
      .unpack('U*')
      .map {|char| char.to_s(NCipher.config.seed.chars.length) }
      .map {|char| char.gsub(/./, convert_table(:for => :encode)) }
      .join(NCipher.config.delimiter)
  end

  def decode(string)
    string
      .to_str
      .split(NCipher.config.delimiter)
      .map {|char| char.gsub(/./, convert_table(:for => :decode)) }
      .map {|char| char.to_i(NCipher.config.seed.chars.length) }
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
    (string.to_str.chars - "#{NCipher.config.seed}#{NCipher.config.delimiter}".chars).size.zero?
  end

  private

  def convert_table(param={:for => nil})
    table = [*'0'..'9', *'a'..'z'].zip(NCipher.config.seed.chars).reject(&:one?).to_h
    case param[:for]
    when :encode then table
    when :decode then table.invert
    end
  end
end
