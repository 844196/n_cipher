class NCipher::Configuration
  attr_accessor :seed, :delimiter

  def initialize
    reset
  end

  def reset
    @seed      = 'にゃんぱす'
    @delimiter = '〜'
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
