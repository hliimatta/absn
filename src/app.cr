require "./absn.cr"

puts Absn.new(
  ARGV.size > 0 ? ARGV[0] : "",
  ".absn.json"
).run(CliOutput.new)
