require 'rspec'

$:.unshift File.expand_path("../..", __FILE__)

RSpec.configure do |c|
  c.fail_fast = true
  c.order = :random
end
