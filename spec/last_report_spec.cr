require "./spec_helper.cr"
require "../src/last_report.cr"

describe LastReport do
  it "returns correct total_work" do
    report("./spec/test_data/single_item.json").total_work.should eq "1h 20m"
  end

  it "returns correct total_break when no breaks" do
    report("./spec/test_data/single_item.json").total_break.should eq "0h 0m"
  end
end

def report(file : String) : LastReport
  LastReport.new(
    JSON.parse(
      File.read(file)
    )["data"]
  )
end
