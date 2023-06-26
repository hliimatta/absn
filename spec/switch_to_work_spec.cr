require "./spec_helper.cr"
require "../src/switch_to_work.cr"

describe SwitchToWork do
  it "switches stasts timer if stopped" do
    time = Time.local(Time::Location.load("Europe/Helsinki"))
    SwitchToWork.new(
      TimespanRepository::Fake.new(
        File.read("./spec/timespans.json")
      ),
      time
    )
      .print(CliOutput.new)
      .content.should eq "Working since #{time.to_s("%d.%m.%Y %H:%M")}"
  end
end
