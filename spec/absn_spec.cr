require "./spec_helper.cr"
require "../spec/fake_api_response.cr"
require "../src/absn.cr"
require "../src/status.cr"

describe Absn do
  it "returns correct status when working" do
    time = Time.utc - 1.hour
    status_when_given_entries([
      given_entry("work", time)
    ]).should eq expected_response_when_working(time)
  end

  it "returns correct status when working is stopped" do
    start = Time.utc - 2.hour
    status_when_given_entries([
      given_entry("work", start, 1.hour)
    ]).should eq expected_response_when_stopped(start + 1.hour, 1.hour, 1.hour, Time::Span.new)
  end

  it "returns correct status when break is started" do
    time = Time.utc - 1.hour
    status_when_given_entries([
      given_entry("break", time)
    ]).should eq expected_response_when_on_break(time)
  end

  it "returns correct total time when multiple entries are present and working is stopped" do
    start1 = Time.utc - 2.hour
    start2 = Time.utc - 4.hour

    status_when_given_entries([
      given_entry("work", start1, 1.hour),
      given_entry("work", start2, 1.hour)
    ]).should eq expected_response_when_stopped(start1 + 1.hour, 1.hour, 2.hours, Time::Span.new)
  end

  it "returns correct total work and break time when multiple entries are present and working is stopped" do
    work_start1 = Time.utc - 2.hour
    work_start2 = Time.utc - 4.hour
    break_start1 = Time.utc - 3.hour
    break_start2 = Time.utc - 5.hour

    work_stop1 = work_start1 + 1.hour
    work_total = 2.hours
    break_total = 2.hours

    status_when_given_entries([
      given_entry("work", work_start1, 1.hour),
      given_entry("break", break_start1, 1.hour),
      given_entry("work", work_start2, 1.hour),
      given_entry("break", break_start2, 1.hour)
    ]).should eq expected_response_when_stopped(work_stop1, 1.hour, work_total, break_total)
  end
end

private def expected_response_when_on_break(break_started : Time) : String
  total = Time.utc - break_started
  "On a break since #{break_started.to_s("%d.%m.%Y %H:%M")} - 0h 0m (#{total.hours}h #{total.minutes}m)"
end

private def expected_response_when_stopped(stop : Time, last : Time::Span, total : Time::Span, break_total : Time::Span) : String
  "Last: #{stop.to_s("%d.%m.%Y")} - #{last.hours}h #{last.minutes}m - Total: #{total.hours}h #{total.minutes}m (#{break_total.hours}h #{break_total.minutes}m)"
end

private def expected_response_when_working(work_started : Time) : String
  total = Time.utc - work_started
  "Working since #{work_started.to_s("%d.%m.%Y %H:%M")} - #{total.hours}h #{total.minutes}m (0h 0m)"
end

private def given_entry(type : String, start : Time) : FakeApiEntry
  FakeApiEntry.new(type, start, nil)
end

private def given_entry(type : String, start : Time, length : Time::Span) : FakeApiEntry
  FakeApiEntry.new(type, start, start + length)
end

private def output_for(command : Command) : String
  Absn.new(command).run(CliOutput.new)
end

private def status_command(json : String) : Command
  Status.new(
    TimespanRepository::Fake.new(
      json
    )
  )
end

private def status_when_given_entries(times : Array(FakeApiEntry)) : String
  output_for(
    status_command(FakeApiResponse.new.to_json(times))
  )
end

