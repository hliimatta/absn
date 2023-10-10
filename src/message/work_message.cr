class WorkMessage
  def initialize(@status : CurrentStatus)
  end

  def content : String
    "Working since #{start_time} - #{totals}"
  end

  private def start_time : String
    @status.started("%d.%m.%Y %H:%M")
  end

  private def totals : String
    "#{@status.total_work} (#{@status.total_break})"
  end
end
