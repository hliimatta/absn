require "./spec_helper.cr"
require "../src/switch_to_break.cr"

describe SwitchToBreak do
  it "switches to break if currently working" do
    time = Time.local(Time::Location.load("Europe/Helsinki"))
    SwitchToBreak.new(
      TimespanRepository::Fake.new(
        File.read("./spec/timespans.json")
      ),
      time
    )
      .print(CliOutput.new)
      .content.should contain "On a break since"
  end
end
