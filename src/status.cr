require "./command.cr"
require "./last_report.cr"
require "./timespan_repository.cr"
require "./message/last_message.cr"

class Status < Command
  def initialize(@repository : TimespanRepository)
  end

  def print(output : CliOutput) : CliOutput
    output.with("message", message)
  end

  private def message : String
    report = LastReport.new(@repository.last)
    report.active? ? active_message(report) : LastMessage.new(report).content
  end

  private def active_message(report : LastReport) : String
    report.type == "work" ? WorkMessage.new(report).content : BreakMessage.new(report).content
  end
end
