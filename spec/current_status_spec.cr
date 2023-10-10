require "./spec_helper.cr"
require "../src/current_status.cr"

describe CurrentStatus do
  it "returns correct total_work" do
    when_total_work_is_printed "single_item", "1h 20m"
  end

  it "returns correct total_break when no breaks" do
    status("./spec/test_data/single_item.json").total_break.should eq "0h 0m"
  end

  it "returns correct total_work when multiple timespans" do
    when_total_work_is_printed "multiple_work_items", "2h 40m"
  end

  it "returns correct total_work when working" do

  end
end

def status(file : String) : CurrentStatus
  CurrentStatus.new(
    JSON.parse(
      File.read(file)
    )["data"]
  )
end

def when_total_work_is_printed(filename : String, expected : String) : Void
    status("./spec/test_data/#{filename}.json").total_work.should eq expected
end
