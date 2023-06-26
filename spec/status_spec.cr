require "./spec_helper.cr"
require "../src/status.cr"

describe Status do
  it "returns correct status when working" do
    Status.new(
      TimespanRepository::Fake.new(
        File.read("./spec/timespans_when_working.json")
      )
    ).print(CliOutput.new).content.should eq "Working since 14.06.2023 18:00"
  end

  it "returns correct status when not working" do
    Status.new(
      TimespanRepository::Fake.new(
        File.read("./spec/timespans.json")
      )
    ).print(CliOutput.new).content.should eq "Last: 14.06.2023 - 1h 20m"
  end

  it "returns correct status when on a break" do
    Status.new(
      TimespanRepository::Fake.new(
        File.read("./spec/timespans_when_on_break.json")
      )
    ).print(CliOutput.new).content.should eq "On a break since 14.06.2023 18:00"
  end
end
