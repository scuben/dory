require 'colorize'
require 'pathname'

module Dory
  module Resolv
    def self.get_module
      return Dory::Resolv::Macos if Os.macos?
      return Dory::Resolv::LinuxResolvconf if self.resolvconf?
      Dory::Resolv::Linux
    end

    def self.has_our_nameserver?
      self.get_module.has_our_nameserver?
    end

    def self.configure
      self.get_module.configure
    end

    def self.file_nameserver_line
      self.get_module.file_nameserver_line
    end

    def self.clean
      self.get_module.clean
    end

    def self.resolvconf?
      Pathname.new('/etc/resolv.conf').realpath.to_s ==
        '/run/resolvconf/resolv.conf'
    end
  end
end
