require "./spec_helper.cr"
require "../src/status.cr"

describe Status do
  it "returns correct status when working" do
    statusmsg("./spec/timespans_when_working.json").should eq "Working since 14.06.2023 18:00 - 0h 43m (0h 0m)"
  end

  it "returns correct status when not working" do
    statusmsg("./spec/timespans.json").should eq "Last: 14.06.2023 - 1h 20m"
  end

  it "returns correct status when on a break" do
    statusmsg("./spec/timespans_when_on_break.json").should eq "On a break since 14.06.2023 18:00 - 0h 43m (0h 0m)"
  end
end

def statusmsg(filename : String) : String
  Status.new(
    TimespanRepository::Fake.new(
      File.read(filename)
    )
  ).print(CliOutput.new).content
end
