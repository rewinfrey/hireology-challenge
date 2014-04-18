$:.unshift File.expand_path("../..", __FILE__)

require 'rspec'
require 'part2/question2/factory'

RSpec.configure do |c|
  c.fail_fast = true
  c.order = :random

  c.before(:each) do
    Factory.delete_all!
  end
end
