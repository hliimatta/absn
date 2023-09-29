require "./command.cr"
require "./last_report.cr"
require "./timespan_repository.cr"

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
    @report.active? ? active_message : last_message
  end

  private def last_message : String
    "Last: #{last_date} - #{last_duration} - Total: #{totals_for_day}"
  end

  private def active_message : String
    "#{@report.type} since #{start_time} - #{totals_for_day}"
  end

  private def last_date : String
    @report.date("%d.%m.%Y")
  end

  private def last_duration : String
    duration = @report.last_duration
    "#{duration.hours}h #{duration.minutes}m"
  end

  private def start_time : String
    @report.start_time("%d.%m.%Y %H:%M")
  end

  private def totals_for_day : String
    "#{@report.total_work} (#{@report.total_break})"
  end
end
