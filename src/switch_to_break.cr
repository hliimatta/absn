require "./command.cr"
require "./current_status.cr"
require "./timespan_repository.cr"
require "./message/break_message.cr"

class SwitchToBreak < Command
  def self.new(repository : TimespanRepository)
    self.new(repository, Time.local(Time::Location.load("Europe/Helsinki")))
  end

  def initialize(@repository : TimespanRepository, @time : Time)
  end

  def print(output : CliOutput) : CliOutput
    status = CurrentStatus.new(@repository)
    unless status.active?
      @repository.start(status.user_id, "break", @time)
    end
    if status.type == "work"
      @repository.stop(status.id, @time)
      @repository.start(status.user_id, "break", @time)
    end

    output.with("message", BreakMessage.new(status).content)
  end
end
