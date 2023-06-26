require "./cli_output.cr"

abstract class Command
  abstract def print(output : CliOutput) : CliOutput

  class Fake < Command
    def initialize(@output : String)
    end

    def print(output : CliOutput) : CliOutput
      output.with("message", @output)
    end
  end
end
