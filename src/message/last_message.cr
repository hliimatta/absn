class LastMessage
  def initialize(@report : LastReport)
  end

  def content : String
    "Last: #{last_date} - #{last_duration} - Total: #{totals_for_day}"
  end

  private def last_date : String
    @report.date("%d.%m.%Y")
  end

  private def last_duration : String
    duration = @report.last_duration
    "#{duration.hours}h #{duration.minutes}m"
  end

  private def totals_for_day : String
    "#{@report.total_work} (#{@report.total_break})"
  end
end
