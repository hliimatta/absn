require "./output.cr"

abstract class Command
  abstract def print(output : Output) : Output

  class Fake < Command
    def initialize(@output : String)
    end

    def print(output : Output) : Output
      output.with("message", @output)
    end
  end
end
