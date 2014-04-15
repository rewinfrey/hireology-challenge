require 'spec_helper'
require 'part2/question1/file_to_json'
require 'part2/question1/parse_strategy'

describe FileToJson do

  let(:example) { "$5.00 TXT MESSAGING - 250 09/29 - 10/28 4.99" }

  let(:parse_strategy) { ParseStrategy.new }
  let(:output)         { StringIO.new }

  subject { FileToJson.new(parse_strategy, output) }

  context '#execute' do
    it 'applies the parsing strategy for every line in the input file and outputs as JSON' do
      file_name = "test"
      temp_file = File.open(file_name, "w+")
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

      File.delete(file_name)
    end
  end
end
