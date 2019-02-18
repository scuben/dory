module Dory
  module Upgrade
    def self.new_version
      res = Dory::Sh.run_command('gem search -q dory')
      return false unless res.success?
      newver = /dory\s+\((.*)\)/.match(res.stdout)
      return false if !newver ||  newver.length != 2
      newver[1]
    end

    def self.outdated?(new_version = self.new_version)
      return Dory.version != new_version
    end

    def self.install
      Dory::Sh.run_command('gem install dory')
    end

    def self.cleanup
      Dory::Sh.run_command('gem cleanup dory')
    end
  end
end
