class WorkMessage
  def initialize(@report : LastReport)
  end

  def content : String
    "Working since #{start_time} - #{totals_for_day}"
  end

  private def start_time : String
    @report.start_time("%d.%m.%Y %H:%M")
  end

  private def totals_for_day : String
    "#{@report.total_work} (#{@report.total_break})"
  end
end
