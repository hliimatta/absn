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
    status = @repository.last[0]
    unless status["endInTimezone"]?
      @repository.stop(status["_id"].to_s, @time)
    end

    output.with("message", LastMessage.new(LastReport.new(@repository.last)).content)
  end
end
