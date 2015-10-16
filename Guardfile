# vim:set filetype=ruby:

guard :shell do
  watch(/(?:lib|test)\/.+\.rb/) { `bundle exec rake test` }
  watch(/lib\/.+\.rb/) { `bundle exec rake yard` }
end
