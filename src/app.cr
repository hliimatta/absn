require "./absn.cr"

puts Absn.new(
  ARGV.size > 0 ? ARGV[0] : "",
  ".absn.json"
).print(CliOutput.new).to_s
