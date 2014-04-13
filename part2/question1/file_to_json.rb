require 'json'

class FileToJson
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

