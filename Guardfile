# vim:set filetype=ruby:

guard :shell do
  watch(%r{(?:lib|test)/.+\.rb}) { `bundle exec rake test` }
  watch(%r{lib/.+\.rb}) { `bundle exec rake yard` }
end
