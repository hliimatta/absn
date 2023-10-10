class WorkMessage
  def initialize(@status : CurrentStatus)
  end

  def content : String
    "Working since #{start_time} - #{totals_for_day}"
  end

  private def start_time : String
    @status.start_time("%d.%m.%Y %H:%M")
  end

  private def totals_for_day : String
    "#{@status.total_work} (#{@status.total_break})"
  end
end
