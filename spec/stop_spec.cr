require "./spec_helper.cr"
require "../src/stop.cr"

describe Stop do
  it "stops current timespan if timespan is not stopped already" do
    time = Time.local(Time::Location.load("Europe/Helsinki"))
    Stop.new(
      TimespanRepository::Fake.new(
        File.read("./spec/timespans_when_working.json")
      ),
      time
    )
      .print(CliOutput.new)
      .content.should contain "Last: #{time.to_s("%d.%m.%Y")}"
  end
end
