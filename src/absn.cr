require "system/user"
require "./absence_api.cr"
require "./config.cr"
require "./status.cr"
require "./command.cr"
require "./cli_output.cr"
require "./forked_command.cr"
require "./output.cr"
require "./switch_to_work.cr"
require "./switch_to_break.cr"
require "./stop.cr"

lib LibC
  fun getuid : UidT
end

class Absn
  def self.new(param : String, config_file : String)
    user = System::User.find_by id: LibC.getuid.to_s
    config = Config.new("#{user.home_directory}/#{config_file}")
    absence_api = Absence::API.new(config.id, config.key)
    self.new(
      ForkedCommand.new(
        param,
        [
          Fork.new("", Status.new(absence_api)),
          Fork.new("w", SwitchToWork.new(absence_api)),
          Fork.new("b", SwitchToBreak.new(absence_api)),
          Fork.new("s", Stop.new(absence_api)),
          Fork.new("-h", Help.new),
        ]
      ),
      Config.new(config_file)
    )
  end

  def self.new(command : Command)
    self.new(command, Config.new(""))
  end

  def initialize(@command : Command, @config : Config)
  end

  def print(output : Output) : Output
    @command.print(output) 
  end
end

