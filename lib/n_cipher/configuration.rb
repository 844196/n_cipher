class NCipher::Configuration
  attr_reader :seed
  attr_accessor :delimiter

  def initialize
    reset
  end

  def reset
    @seed      = 'にゃんぱす'.chars
    @delimiter = '〜'
  end

  # 独自のセッター
  # 引数を1文字づつに分割した配列をインスタンス変数へ格納
  def seed=(string)
    @seed = string.chars
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
