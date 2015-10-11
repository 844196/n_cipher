# NCipher

[![Gem](https://img.shields.io/gem/v/n_cipher.svg)](https://rubygems.org/gems/n_cipher)
[![Required Ruby](https://img.shields.io/badge/ruby-%3E%3D%202.1.0-red.svg)](#)
[![Travis branch](https://img.shields.io/travis/844196/n_cipher.svg)](https://travis-ci.org/844196/n_cipher)
[![Coveralls branch](https://img.shields.io/coveralls/844196/n_cipher/master.svg)](https://coveralls.io/github/844196/n_cipher)
[![Code Climate](https://img.shields.io/codeclimate/github/844196/n_cipher.svg)](https://codeclimate.com/github/844196/n_cipher)
[![Issues](http://img.shields.io/github/issues/844196/n_cipher.svg)](https://github.com/844196/n_cipher/issues)
[![Documents](http://img.shields.io/badge/doc-そんな物はない-red.svg?style=social)](#)

![](https://cloud.githubusercontent.com/assets/4990822/10408480/9bf5d63a-6f39-11e5-9568-55e24afcbdc5.png)

文字列のUnicodeエスケープシーケンスを利用した簡易的な暗号です

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'n_cipher'
```

And then execute:

```shellsession
$ bundle
```

Or install it yourself as:

```shellsession
$ gem install n_cipher
```

## Usage

```ruby
require 'n_cipher'

NCipher::encode('にゃんぱす', seed: 'おうどん', delimiter: 'ひげ')
#=> "んおおうどどんひげんおおどおおんひげんおおどうおんひげんおおうんおうひげんおおううどうひげ"

NCipher::decode(
  'んおおうどどんひげんおおどおおんひげんおおどうおんひげんおおうんおうひげんおおううどうひげ',
  seed: 'おうどん', delimiter: 'ひげ')
#=> "にゃんぱす"
```

```shellsession
$ n_cipher --help
Commands:
  n_cipher decode <STRING>  # N暗号文字列を復号化
  n_cipher encode <STRING>  # 文字列をN暗号化
  n_cipher help [COMMAND]   # Describe available commands or one specific command
  n_cipher version          # Print version

Options:
  [--seed=SEED]
                           # Default: にゃんぱす
  [--delimiter=DELIMITER]
                           # Default: 〜

$ # encode
$ n_cipher encode 'にゃんぱす'
ぱすすにすに〜ぱすすゃぱす〜ぱすすんんに〜ぱすすゃにゃ〜ぱすすににん〜
$ n_cipher encode --seed 'おうどん' --delimiter 'ひげ' 'にゃんぱす'
んおおうどどんひげんおおどおおんひげんおおどうおんひげんおおうんおうひげんおおううどうひげ

$ # decode
$ n_cipher decode --seed 'おうどん' --delimiter 'ひげ' 'んおおうどどんひげんおおどおおんひげんおおどうおんひげんおおうんおうひげんおおううどうひげ'
にゃんぱす

$ # support STDIN
$ renge | n_cipher encode
んんぱんにぱに〜ゃぱんぱゃゃん〜ぱすすにぱゃ〜ぱすすゃにぱ〜ぱすすゃすゃ〜すににゃぱに〜ゃんゃんぱゃぱ〜ゃぱゃんんぱぱ〜ぱすすににに〜ぱすすにゃぱ〜ぱすすんんに〜ぱすすにぱす〜すにすんんんゃ〜
```
