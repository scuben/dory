require 'ostruct'

module Dory
  module Sh
    def self.run_command(command)
      stdout = `#{command}`
      OpenStruct.new({
        success?: $?.exitstatus == 0,
        exitstatus: $?.exitstatus,
        stdout: stdout
      })
    end
  end

  module Bash
    def self.escape_single_quotes(str)
      # Using this technique here:  https://stackoverflow.com/a/1315213/2062384
      str.gsub("'", "'\\\\''")
    end

    def self.escape_double_quotes(str)
      str.gsub('"', '\\"')
    end

    def self.run_command(command)
      stdout = `bash -c "#{self.escape_double_quotes(command)}"`
      OpenStruct.new({
        success?: $?.exitstatus == 0,
        exitstatus: $?.exitstatus,
        stdout: stdout
      })
    end
  end
end
