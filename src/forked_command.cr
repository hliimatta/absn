require "./command.cr"
require "./cli_output.cr"
require "./help.cr"

class ForkedCommand < Command
  def initialize(@flag : String, @forks : Array(Fork))
  end

  def print(output : CliOutput) : CliOutput
    @forks.each do |fork|
      return fork.print(output) if fork.match?(@flag)
    end

    Help.new.print(output)
  end
end

class Fork
  def initialize(@flag : String, @command : Command)
  end

  def match?(flag : String) : Bool
    @flag == flag
  end

  def print(output : CliOutput) : CliOutput
    @command.print(output)
  end
end
