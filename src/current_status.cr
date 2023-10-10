require "json"

class CurrentStatus
  def self.new(timespan_repository : TimespanRepository)
    self.new(timespan_repository.last)
  end
  
  def initialize(@timespans : JSON::Any)
  end

  def active? : Bool
    !last_entry["endInTimezone"]?
  end

  def date(format : String) : String
    if last_entry["endInTimezone"]?
      return format_time(last_entry["endInTimezone"], format)
    end

    format_time(last_entry["startInTimezone"], format)
  end

  def duration : Time::Span
    if last_entry["endInTimezone"]?
      end_time = Time.parse!(last_entry["endInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z")
      start_time = Time.parse!(last_entry["startInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z")
    
      return (end_time - start_time)
    end

    Time::Span.new
  end

  def id : String
    last_entry["_id"].to_s
  end

  def started(format : String) : String
    Time.parse!(last_entry["startInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z").to_s(format)
  end

  def total_break : String
    total = sum_time("break")

    "#{total.hours}h #{total.minutes}m"
  end

  def total_work : String
    total = sum_time("work")

    "#{total.hours}h #{total.minutes}m"
  end

  def type : String
    last_entry["type"].to_s
  end

  def user_id : String
    last_entry["userId"].to_s
  end

  private def sum_time(type : String) : Time::Span
    total = Time::Span.new 
    @timespans.as_a.each do |timespan|
      if timespan["type"] == type
        if timespan["endInTimezone"]?
            end_time = Time.parse!(timespan["endInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z")
        else
            end_time = Time.local(Time::Location.load("Europe/Helsinki"))
        end
        start_time = Time.parse!(timespan["startInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z")
        total = total + (end_time - start_time)
      end
    end
    total
  end

  private def last_entry : JSON::Any
    @timespans[0]
  end

  private def format_time(time : JSON::Any, format : String) : String
    Time.parse!(time.to_s, "%Y-%m-%dT%H:%M:%S.%3N%z").to_s("%d.%m.%Y")
  end
end
