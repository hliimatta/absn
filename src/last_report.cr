require "json"

class LastReport
  def initialize(@timespans : JSON::Any)
  end

  def active? : Bool
    !last_entry()["endInTimezone"]?
  end

  def date(format : String) : String
    if last_entry()["endInTimezone"]?
      return format_time(last_entry()["endInTimezone"], format)
    end

    format_time(last_entry()["startInTimezone"], format)
  end

  def last_duration : Time::Span
    unless last_entry()["endInTimezone"]?
      return Time::Span.new
    end
    end_time = Time.parse!(last_entry()["endInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z")
    start_time = Time.parse!(last_entry()["startInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z")

    (end_time - start_time)
  end

  def start_time(format : String) : String
    Time.parse!(last_entry()["startInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z").to_s(format)
  end

  def total_break : String
    end_time = start_time = Array(Time).new
    @timespans.as_a.each do |timespan|
      if timespan["type"] == "break" && timespan["endInTimezone"]?
        end_time << Time.parse!(timespan["endInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z")
        start_time << Time.parse!(timespan["startInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z")
      end
    end
    if end_time.empty? || start_time.empty?
      return "0h 0m"
    end
    span = end_time.max - start_time.min

    "#{span.hours}h #{span.minutes}m"
  end

  def total_work : String
    end_time = start_time = Array(Time).new
    @timespans.as_a.each do |timespan|
      if timespan["type"] == "work" && timespan["endInTimezone"]?
        end_time << Time.parse!(timespan["endInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z")
        start_time << Time.parse!(timespan["startInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z")
      end
    end
    if end_time.empty? || start_time.empty?
      return "0h 0m"
    end
    span = end_time.max - start_time.min

    "#{span.hours}h #{span.minutes}m"
  end

  def type : String
    last_entry()["type"].to_s
  end

  private def last_entry : JSON::Any
    @timespans[0]
  end

  private def format_time(time : JSON::Any, format : String) : String
    Time.parse!(time.to_s, "%Y-%m-%dT%H:%M:%S.%3N%z").to_s("%d.%m.%Y")
  end
end
