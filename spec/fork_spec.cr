require "./spec_helper.cr"
require "../src/forked_command.cr"

describe ForkedCommand do
  it "returns correct command" do
    ForkedCommand.new(
      "A",
      [Fork.new("A", Command::Fake.new("is A")), Fork.new("B", Command::Fake.new("is B"))]
    ).print(CliOutput.new).content.should eq "is A"
  end
end
