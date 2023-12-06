class BreakMessage
  def initialize(@status : CurrentStatus)
  end

  def content : String
    "On a break since #{start_time} - #{totals_for_day}"
  end

  private def start_time : String
    @status.started("%d.%m.%Y %H:%M")
  end

  private def totals_for_day : String
    "#{@status.total_work} (#{@status.total_break})"
  end
end
