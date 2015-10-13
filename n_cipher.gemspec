# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'n_cipher/version'

Gem::Specification.new do |spec|
  spec.name          = "n_cipher"
  spec.version       = NCipher::VERSION
  spec.authors       = ["Masaya Takeda"]
  spec.email         = ["844196@gmail.com"]

  spec.summary       = %q{ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん〜ぱすぱんぱゃ}
  spec.description   = %q{文字列のUnicodeエスケープシーケンスを利用した簡易的な暗号です}
  spec.homepage      = "https://github.com/844196/n_cipher"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.1.0'
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "rubocop"

  spec.add_dependency "thor"
end
