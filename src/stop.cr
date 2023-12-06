require "json"
require "./command.cr"
require "./current_status.cr"
require "./timespan_repository.cr"

class Stop < Command
  def self.new(repository : TimespanRepository)
    self.new(repository, Time.local(Time::Location.load("Europe/Helsinki")))
  end

  def initialize(@repository : TimespanRepository, @time : Time)
  end

  def print(output : Output) : Output
    status = CurrentStatus.new(@repository)
    if status.active?
      @repository.stop(status.id, @time)
    end

    output.with_content(LastMessage.new(status).content)
  end
end
