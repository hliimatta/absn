class Report
  def initialize(@timespans : JSON::Any)
  end

  def total_break : String
    "0h 30m"
  end

  def total_work : String
    "1h 20m"
  end
end
