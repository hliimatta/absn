require "json"

abstract class TimespanRepository
  abstract def last : JSON::Any
  abstract def start(userId : String, type : String, start : Time) : JSON::Any
  abstract def status : JSON::Any
  abstract def stop(timespanId : String, stop : Time) : JSON::Any
  abstract def timespans(time : Time) : JSON::Any

  class Fake < TimespanRepository
    def self.new
      self.new("")
    end

    def initialize(@response : String)
    end

    def last : JSON::Any
      unless @response.empty?
        json = JSON.parse(@response)
        time = Time.parse!(json["data"][0]["startInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z")
        return timespans(time)
      end
      JSON::Any.new("")
    end

    def start(userId : String, type : String, start : Time) : JSON::Any
      content = File.read("spec/created_timespan.json")
      unless content.empty?
        json = JSON.parse(content)
        hash = json.as_h
        hash["startInTimezone"] = JSON::Any.new(start.to_s("%Y-%m-%dT%H:%M:%S.%3N%z"))
        return JSON.parse(hash.to_json)
      end
      JSON::Any.new("")
    end

    def status : JSON::Any
      last[0]
    end

    def stop(timespanId : String, stop : Time) : JSON::Any
      content = File.read("spec/created_timespan.json")
      unless content.empty?
        json = JSON.parse(content)
        hash = json.as_h
        hash["endInTimezone"] = JSON::Any.new(stop.to_s("%Y-%m-%dT%H:%M:%S.%3N%z"))
        return JSON.parse(hash.to_json)
      end
      JSON::Any.new("")
    end

    def timespans(time : Time) : JSON::Any
      unless @response.empty?
        json = JSON.parse(@response)
        return json["data"]
      end
      JSON::Any.new("")
    end
  end
end
