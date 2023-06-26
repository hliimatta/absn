require "./spec_helper.cr"
require "../src/config.cr"

describe Config do
  it "should load config file" do
    config = Config.new("./spec/config.json")
    config.id.should eq "test_id"
    config.key.should eq "test_key"
  end
end
