require 'spec_helper'
require 'part2/question1/parse_strategy'

describe ParseStrategy do
  let(:example) { "$5.00 TXT MESSAGING - 250 09/29 - 10/28 4.99" }

  subject { ParseStrategy.new }

  context '#execute' do
    it 'returns a hash containing the feature, date_range and price of the input string' do
      subject.execute(example).should == {
        feature: "TXT MESSAGING - 250",
        date_range: "09/29 - 10/28",
        price: 4.99
      }
    end
  end
end

