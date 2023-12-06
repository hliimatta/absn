abstract class Output
  abstract def to_s : String
  abstract def with_content(content : String) : Output
end
