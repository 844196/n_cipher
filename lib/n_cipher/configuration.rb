class NCipher::Configuration
  include NCipher::ArgumentValidation

  attr_reader :seed
  attr_accessor :delimiter

  def initialize
    reset
  end

  def reset
    @seed      = 'にゃんぱす'.chars
    @delimiter = '〜'
  end

  def seed=(string)
    @seed = string.chars
  end

  args_validation :seed=, 'Seed must be 2 to 36 characters.' do |seed|
    seed.length.between?(2, 36)
  end

  args_validation :seed=, 'Character is duplicated in seed.' do |seed|
    seed.length == seed.chars.uniq.length
  end

  args_validation :seed=, 'Seed and delimiter are duplicated.' do |seed|
    !seed.include?(@delimiter)
  end

  args_validation :delimiter=, 'Delimiter and seed are duplicated.' do |delimiter|
    !@seed.join.include?(delimiter)
  end
end

class << NCipher
  def config
    @config ||= NCipher::Configuration.new
  end

  def configure(&block)
    block.call(config)
  end
end
