require "./command.cr"
require "./timespan_repository.cr"

class SwitchToBreak < Command
  def self.new(repository : TimespanRepository)
    self.new(repository, Time.local(Time::Location.load("Europe/Helsinki")))
  end

  def initialize(@repository : TimespanRepository, @time : Time)
  end

  def print(output : CliOutput) : CliOutput
    status = @repository.last
    response = status
    if status["endInTimezone"]?
      response = @repository.start(status["userId"].to_s, "break", @time)
    end
    if status["type"] == "work"
      @repository.stop(status["_id"].to_s, @time)
      response = @repository.start(status["userId"].to_s, "break", @time)
    end
    time = Time.parse!(response["startInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z")

    output.with("message", "On a break since #{time.to_s("%d.%m.%Y %H:%M")}")
  end
end
