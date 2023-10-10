class LastMessage
  def initialize(@timespans : CurrentStatus)
  end

  def content : String
    "Last: #{last_date} - #{last_duration} - Total: #{totals_for_day}"
  end

  private def last_date : String
    @timespans.date("%d.%m.%Y")
  end

  private def last_duration : String
    duration = @timespans.last_duration
    "#{duration.hours}h #{duration.minutes}m"
  end

  private def totals_for_day : String
    "#{@timespans.total_work} (#{@timespans.total_break})"
  end
end
