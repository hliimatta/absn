require "./command.cr"

class Help < Command
  def print(output : CliOutput) : CliOutput
    message = "
Usage: absn [options] [command]

  Options:
    -h          output usage information

  Commands:
    w           start/switch to work
    b           start/switch to break
    s           stop current timer"

    output.with("message", message)
  end
end
