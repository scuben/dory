require 'colorize'

module Dory
  module Dinghy
    class DinghyError < RuntimeError
    end

    def self.installed?
      Bash.run_command("which dinghy >/dev/null 2>&1").success?
    end

    def self.ip
      res = Bash.run_command("dinghy ip").stdout.chomp
      unless res =~ /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/
        raise DinghyError.new(<<-ERROR)
          Dinghy responded with: '#{res}', but we expected an IP address.
          Please make sure the dinghy vm is running, and that running
          `dinghy ip` gives you an IP address
        ERROR
      end
      res
    end

    def self.match?(str)
      # be lenient cause I typo this all the time
      str =~ /^:?din.?.?y:?/
    end
  end
end
