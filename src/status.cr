require "./command.cr"
require "./report.cr"
require "./timespan_repository.cr"

class Status < Command
  def initialize(@repository : TimespanRepository)
  end

  def print(output : CliOutput) : CliOutput
    json = @repository.last
    output.with("message", message(json))
  end

  private def message(json : JSON::Any) : String
    if json["endInTimezone"]?
      "Last: #{last_date(json)} - #{last_duration(json)}"
    else
      "#{type(json)} since #{start_time(json)} - #{totals_for_day(json)}"
    end
  end

  private def last_date(json : JSON::Any) : String
    Time.parse!(json["endInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z").to_s("%d.%m.%Y")
  end

  private def last_duration(json : JSON::Any) : String
    end_time = Time.parse!(json["endInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z")
    start_time = Time.parse!(json["startInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z")
    span = (end_time - start_time)
    "#{span.hours}h #{span.minutes}m"
  end

  private def start_time(json : JSON::Any) : String
    Time.parse!(json["startInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z").to_s("%d.%m.%Y %H:%M")
  end

  private def totals_for_day(json : JSON::Any) : String
    time = Time.parse!(json["startInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z")
    entries = @repository.timespans(time)
    report = Report.new(entries)
    "#{report.total_work} (#{report.total_break})"
  end

  private def type(json : JSON::Any) : String
    case json["type"]
    when "work"  then "Working"
    when "break" then "On a break"
    else              "Unknown"
    end
  end
end
