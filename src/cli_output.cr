require "./output.cr"

class CliOutput < Output
  def self.new
    CliOutput.new("")
  end

  def initialize(@content : String)
  end

  def with_content(content : String) : Output
    CliOutput.new(content)
  end

  def to_s : String
    @content
  end
end
