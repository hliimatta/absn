class LastMessage
  def initialize(@status : CurrentStatus)
  end

  def content : String
    "Last: #{last_date} - #{last_duration} - Total: #{totals}"
  end

  private def last_date : String
    @status.date("%d.%m.%Y")
  end

  private def last_duration : String
    duration = @status.duration
    "#{duration.hours}h #{duration.minutes}m"
  end

  private def totals : String
    "#{@status.total_work} (#{@status.total_break})"
  end
end
