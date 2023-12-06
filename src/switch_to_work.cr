require "./command.cr"
require "./timespan_repository.cr"
require "./message/work_message.cr"

class SwitchToWork < Command
  def self.new(repository : TimespanRepository)
    self.new(repository, Time.local(Time::Location.load("Europe/Helsinki")))
  end

  def initialize(@repository : TimespanRepository, @time : Time)
  end

  def print(output : Output) : Output
    output.with_content(switch_to_work)
  end

  private def switch_to_work : String
    status = CurrentStatus.new(@repository.last)
    unless status.active?
      @repository.start(status.user_id, "work", @time)
    end
    if status.type == "break"
      @repository.stop(status.id, @time)
      @repository.start(status.user_id, "work", @time)
    end

    WorkMessage.new(status).content
  end
end
