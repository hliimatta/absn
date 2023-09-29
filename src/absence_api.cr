require "http/client"
require "openssl/hmac"
require "json"
require "./timespan_repository.cr"

module Absence
  class API < TimespanRepository
    def initialize(@api_id : String, @api_key : String)
    end

    def start(userId : String, type : String, start : Time) : JSON::Any
      response = request(
        "POST",
        "/api/v2/timespans/create",
        "{\"userId\":\"#{userId}\",\"type\":\"#{type}\",
          \"start\":\"#{start.to_utc.to_s("%Y-%m-%dT%H:%M:%S.%3NZ")}\",
          \"timezone\":\"#{Time.local.zone.format(false, false)}\", \"timezoneName\":\"#{Time.local.zone.name}\"}"
      ).body
      JSON.parse(response)
    end

    def last : JSON::Any
      json = JSON.parse(
        request(
          "POST",
          "/api/v2/timespans",
          "{\"sortBy\":{\"start\":-1}}"
        ).body
      )
      time = Time.parse!(json["data"][0]["startInTimezone"].to_s, "%Y-%m-%dT%H:%M:%S.%3N%z")

      timespans(time)
    end

    def stop(timespanId : String, stop : Time) : JSON::Any
      response = request(
        "PUT",
        "/api/v2/timespans/#{timespanId}",
        "{\"end\":\"#{stop.to_utc.to_s("%Y-%m-%dT%H:%M:%S.%3NZ")}\",
          \"timezone\":\"#{Time.local.zone.format(false, false)}\", \"timezoneName\":\"#{Time.local.zone.name}\"}"
      ).body

      JSON.parse(response)
    end

    def timespans(time : Time) : JSON::Any
      response = request(
        "POST",
        "/api/v2/timespans",
        "{\"filter\":{\"start\":{\"$gte\":\"#{time.to_utc.to_s("%Y-%m-%d")}\"}},\"sortBy\":{\"start\":-1}}"
      ).body

      JSON.parse(response)["data"]
    end

    private def hawk_token(method : String, path : String, host : String) : String
      nonce = Random::Secure.hex(3)
      timestamp = Time.utc.to_unix
      algorithm = "sha256"
      port = 443
      normalized_request = "hawk.1.header\n#{timestamp}\n#{nonce}\n#{method}\n#{path}\n#{host}\n#{port}\n\n\n"
      mac = OpenSSL::HMAC.digest(OpenSSL::Algorithm::SHA256, @api_key, normalized_request)
      mac_base64 = Base64.strict_encode(mac)

      "Hawk id=\"#{@api_id}\", ts=\"#{timestamp}\", nonce=\"#{nonce}\", mac=\"#{mac_base64}\""
    end

    private def request(method : String, path : String, body : String) : HTTP::Client::Response
      host = "app.absence.io"
      headers = HTTP::Headers{
        "Authorization" => hawk_token(method, path, host),
        "Content-Type"  => "application/json",
      }
      if method == "POST"
        return HTTP::Client.post("https://#{host}#{path}", headers, body)
      end

      if method == "PUT"
        return HTTP::Client.put("https://#{host}#{path}", headers, body)
      end

      HTTP::Client.get("https://#{host}#{path}", headers)
    end
  end
end
