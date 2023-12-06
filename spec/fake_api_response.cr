class FakeApiEntry
  def initialize(@type : String, @start_time : Time, @end_time : Time|Nil)
  end

  def type : String
    @type
  end

  def start_time : Time
    @start_time
  end

  def end_time : Time|Nil
    @end_time
  end
end

class FakeApiResponse
  def to_json(times : Array(FakeApiEntry)) : String
    %({"data":
        [
          #{times.map do |time|
            create_entry(
              time.type, 
              time.start_time,
              time.end_time
            )
          end.join(",")}
        ]
      })
  end

  private def create_entry(type : String, start_time : Time, end_time : Time|Nil) : String
    start = start_time.to_s("%Y-%m-%dT%H:%M:%S.000Z")
    end_ = end_time ? end_time.to_s("%Y-%m-%dT%H:%M:%S.000Z") : "null"
    %({
      "compensations": [],
      "source": {
        "sourceType": "browser",
        "sourceId": "manual"
      },
      "_id": "2",
      "type": "#{type}",
      "start": "#{start}",
      "end": "#{end_}",
      "commentary": null,
      "timezone": "+0300",
      "millisecondOffset": 10800000,
      "timezoneName": "manual",
      "createdOn": "2023-06-15T02:51:32.107Z",
      "modifiedOn": "2023-06-15T02:52:46.085Z",
      "userId": "1",
      "companyId": "1",
      "createdById": "1",
      "modifiedById": "1",
      "labelIds": [],
      "effectiveStart": "#{start}",
      "effectiveEnd": "#{end_}",
      "startInTimezone": "#{start}"
      #{timezone_end(end_)}
      })
  end

  private def timezone_end(end_time : String) : String
    if end_time == "null"
      return ""
    end
    %(
      ,
      "endInTimezone": "#{end_time}"
    )
  end
end
