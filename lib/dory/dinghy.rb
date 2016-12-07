require 'colorize'

module Dory
  module Dinghy
    def self.installed?
      Bash.run_command("which dinghy >/dev/null 2>&1").success?
    end

    def self.ip
      Bash.run_command("dinghy ip").stdout.chomp
    end

    def self.match?(str)
      str =~ /^:?din.?.?y:?/
    end
  end
end
