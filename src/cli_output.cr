class CliOutput
  def self.new
    CliOutput.new({"message" => ""})
  end

  def initialize(@values : Hash(String, String))
  end

  def with(key : String, value : String) : CliOutput
    CliOutput.new(@values.merge({key => value}))
  end

  def content : String
    @values["message"]
  end
end
