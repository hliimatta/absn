require "./command.cr"
require "./current_status.cr"
require "./timespan_repository.cr"
require "./message/last_message.cr"

class Status < Command
  def initialize(@repository : TimespanRepository)
  end

  def print(output : CliOutput) : CliOutput
    output.with("message", message)
  end

  private def message : String
    status = CurrentStatus.new(@repository.last)
    status.active? ? active_message(status) : LastMessage.new(status).content
  end

  private def active_message(status : CurrentStatus) : String
    status.type == "work" ? WorkMessage.new(status).content : BreakMessage.new(status).content
  end
end
