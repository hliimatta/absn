require "./command.cr"
require "./timespan_repository.cr"

class SwitchToWork < Command
  def self.new(repository : TimespanRepository)
    self.new(repository, Time.local(Time::Location.load("Europe/Helsinki")))
  end

  def initialize(@repository : TimespanRepository, @time : Time)
  end

  def print(output : CliOutput) : CliOutput
    output.with("message", switch_to_work)
  end

  private def switch_to_work : String
    status = @repository.last[0]
    response = status
    if status["endInTimezone"]?
      response = @repository.start(status["userId"].to_s, "work", @time)
    end
    if status["type"] == "break"
      @repository.stop(status["_id"].to_s, @time)
      response = @repository.start(status["userId"].to_s, "work", @time)
    end
    time = Time.parse!(response["startInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z")

    "Working since #{time.to_s("%d.%m.%Y %H:%M")}"
  end
end
