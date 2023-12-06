require "./output.cr"

class CliOutput < Output
  def self.new
    CliOutput.new({"message" => ""})
  end

  def initialize(@values : Hash(String, String))
  end

  def with(key : String, value : String) : Output
    CliOutput.new(@values.merge({key => value}))
  end

  def to_s : String
    @values["message"]
  end
end
