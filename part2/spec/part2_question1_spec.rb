require 'rspec'

class ParseStrategy
  def execute(input_string)
    {
      feature: parse_feature(input_string),
      date_range: parse_date_range(input_string),
      price: parse_price(input_string)
    }
  end

  private

  def parse_feature(input_string)
    /[A-Z]+\s[A-Z]+\s\-\s\d+/.match(input_string).to_s
  end

  def parse_date_range(input_string)
    /\d+\/\d+\s\-\s\d+\/\d+/.match(input_string).to_s
  end

  def parse_price(input_string)
    /\d+\.\d+$/.match(input_string).to_s.to_f
  end
end

describe 'part2_question1' do
  context 'ParseStrategy' do
    subject { ParseStrategy.new }
    let(:example) { "$5.00 TXT MESSAGING - 250 09/29 - 10/28 4.99" }

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
end
