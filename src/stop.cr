require "json"
require "./command.cr"
require "./timespan_repository.cr"

class Stop < Command
  def self.new(repository : TimespanRepository)
    self.new(repository, Time.local(Time::Location.load("Europe/Helsinki")))
  end

  def initialize(@repository : TimespanRepository, @time : Time)
  end

  def print(output : CliOutput) : CliOutput
    status = @repository.last
    unless status["endInTimezone"]?
      response = @repository.stop(status["_id"].to_s, @time)
      output.with("message", message(response))
    else
      output.with("message", message(status))
    end
  end

  private def message(json : JSON::Any) : String
    "Last: #{last_date(json)} - #{last_duration(json)}"
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
end
