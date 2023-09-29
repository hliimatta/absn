require "./command.cr"
require "./last_report.cr"
require "./timespan_repository.cr"
require "./message/last_message.cr"

class Status < Command
  def self.new(repository : TimespanRepository)
    self.new(LastReport.new(repository.last))
  end

  def initialize(@report : LastReport)
  end

  def print(output : CliOutput) : CliOutput
    output.with("message", message)
  end

  private def message : String
    @report.active? ? active_message : LastMessage.new(@report).content
  end

  private def active_message : String
    @report.type == "work" ? WorkMessage.new(@report).content : BreakMessage.new(@report).content
  end
end
