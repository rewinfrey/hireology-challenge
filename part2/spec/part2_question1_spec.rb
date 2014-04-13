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

class FileToJson
  require 'json'
  def initialize(parse_strategy, output = $standard_out)
    @parse_strategy = parse_strategy
    @output         = output
  end

  def execute(input_file)
    IO.foreach(input_file) do |line|
      output.puts(
        hash_to_json(
          parse_strategy.execute(line)
        )
      )
    end
  end

  private

  attr_reader :parse_strategy, :output

  def hash_to_json(parsed_hash)
    JSON.pretty_generate(parsed_hash)
  end
end

describe 'part2_question1' do
  let(:example) { "$5.00 TXT MESSAGING - 250 09/29 - 10/28 4.99" }

  context 'ParseStrategy' do
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

  context 'FileToJson' do
    let(:parse_strategy) { ParseStrategy.new }
    let(:output)         { StringIO.new }

    subject { FileToJson.new(parse_strategy, output) }

    context '#execute' do
      it 'applies the parsing strategy for every line in the input file and outputs as JSON' do
        temp_file = File.open("test", "w+")
        2.times { temp_file.write("#{example}\n") }
        temp_file.flush

        subject.execute(temp_file)
        output.string.should == "" +
          "{\n  " +
          "\"feature\": \"TXT MESSAGING - 250\",\n  " +
          "\"date_range\": \"09/29 - 10/28\",\n  " +
          "\"price\": 4.99\n" +
          "}\n" +
          "{\n  " +
          "\"feature\": \"TXT MESSAGING - 250\",\n  " +
          "\"date_range\": \"09/29 - 10/28\",\n  " +
          "\"price\": 4.99\n" +
          "}\n"

        File.delete("test")
      end
    end
  end
end
