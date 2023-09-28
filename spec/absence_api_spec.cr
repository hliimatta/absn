require "./spec_helper.cr"
require "../src/absence_api.cr"
require "../src/config.cr"

describe Absence::API do
  unless Config.new("./spec/absence_api.json").id.empty?
    it "returns last timespan" do
      Absence::API.new(
        Config.new("./spec/absence_api.json").id,
        Config.new("./spec/absence_api.json").key
      ).last.to_s.should contain "startInTimezone"
    end

    it "returns timespans for date" do
    end
  end
end
