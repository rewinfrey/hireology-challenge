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
