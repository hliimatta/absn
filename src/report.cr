class Report
  def initialize(@timespans : Array(JSON::Any))
  end

  def total_break : String
    end_time = start_time = Array(Time).new

    @timespans.each do |timespan|
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

    @timespans.each do |timespan|
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
end
