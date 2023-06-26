require "./spec_helper.cr"
require "../src/absn.cr"
require "../src/status.cr"

describe Absn do
  it "returns current status if no commands given and working is started" do
    when_command_is_run(given_status_command("./spec/timespans_when_working.json")).should eq "Working since 14.06.2023 18:00"
  end

  it "returns current status if no commands given and working is stopped" do
    when_command_is_run(given_status_command("./spec/timespans.json")).should eq "Last: 14.06.2023 - 1h 20m"
  end

  it "returns correct status if no commands given and break is started" do
    when_command_is_run(given_status_command("./spec/timespans_when_on_break.json")).should eq "On a break since 14.06.2023 18:00"
  end
end

# TODO:Create test for application call with w command
# TODO:Create test for application call with p command
# TODO:Create test for application call with s command
# TODO:Create test f application call with -h parameter

def when_command_is_run(command : Command) : String
  Absn.new(command).run(CliOutput.new)
end

def given_status_command(file : String) : Command
  Status.new(
    TimespanRepository::Fake.new(
      File.read(file)
    )
  )
end
