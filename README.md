# NCipher

[![Gem](https://img.shields.io/gem/v/n_cipher.svg)](https://rubygems.org/gems/n_cipher)
[![Required Ruby](https://img.shields.io/badge/ruby-%3E%3D%202.2.0-red.svg)](#)
[![Travis branch](https://img.shields.io/travis/844196/n_cipher.svg)](https://travis-ci.org/844196/n_cipher)
[![Coveralls branch](https://img.shields.io/coveralls/844196/n_cipher/master.svg)](https://coveralls.io/github/844196/n_cipher)
[![Code Climate](https://img.shields.io/codeclimate/github/844196/n_cipher.svg)](https://codeclimate.com/github/844196/n_cipher)

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
NCipher.configure do |config|
  config.seed = 'おうどん'
  config.delimiter = 'ひげ'
end

NCipher.encode 'にゃんぱす'
#=> "んおおうどどんひげんおおどおおんひげんおおどうおんひげんおおうんおうひげんおおううどう"

NCipher.decode 'んおおうどどんひげんおおどおおんひげんおおどうおんひげんおおうんおうひげんおおううどう'
#=> "にゃんぱす"
```
