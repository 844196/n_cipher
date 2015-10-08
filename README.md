# NCipher

[![Gem](https://img.shields.io/gem/v/n_cipher.svg)]()
[![Travis branch](https://img.shields.io/travis/844196/n_cipher.svg)](https://travis-ci.org/844196/n_cipher)
[![Coveralls branch](https://img.shields.io/coveralls/844196/n_cipher/master.svg)](https://coveralls.io/github/844196/n_cipher)
[![Code Climate](https://img.shields.io/codeclimate/github/844196/n_cipher.svg)](https://codeclimate.com/github/844196/n_cipher)

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
