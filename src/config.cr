require "json"

class Config
  @id : String
  @key : String

  def initialize(@config_file : String)
    @id = ""
    @key = ""
  end

  def id : String
    if @id == ""
      load_config
    end

    @id
  end

  def key : String
    if @key == ""
      load_config
    end

    @key
  end

  private def load_config
    if File.exists?(@config_file)
      config = File.read(@config_file)
      unless config.empty?
        config = JSON.parse(config)
        @id = config["id"].to_s
        @key = config["key"].to_s
      end
    else
      raise "No config file found at #{@config_file}"
    end
  end
end
