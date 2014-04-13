require 'rspec'

def parse_price(input_string)
  /\d+\.\d+$/.match(input_string).to_s.to_f
end

def parse_date_range(input_string)
  /\d+\/\d+\s\-\s\d+\/\d+/.match(input_string).to_s
end

def parse_feature(input_string)
  /[A-Z]+\s[A-Z]+\s\-\s\d+/.match(input_string).to_s
end

describe 'part2_question1' do
  context 'parsing' do
    let(:example) { "$5.00 TXT MESSAGING - 250 09/29 - 10/28 4.99" }

    it 'parses the price found at the end of an input string' do
      parse_price(example).should == 4.99
    end

    it 'parses the date range from the input string' do
      parse_date_range(example).should == "09/29 - 10/28"
    end

    it 'parses the feature from the input string' do
      parse_feature(example).should == "TXT MESSAGING - 250"
    end
  end
end
