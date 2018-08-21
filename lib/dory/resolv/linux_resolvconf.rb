module Dory
  module Resolv
    module LinuxResolvconf
      def self.file_nameserver_line
        Linux.file_nameserver_line
      end

      def self.nameserver_contents
        Linux.nameserver_contents
      end

      def self.has_our_nameserver?
        Linux.has_our_nameserver?
      end

      def self.configure
        puts 'Requesting sudo to run resolvconf'.green
        Bash.run_command("echo -e '#{self.nameserver_contents}' | sudo resolvconf -a lo.dory")
      end

      def self.clean
        puts 'Requesting sudo to run resolvconf'.green
        Bash.run_command("sudo resolvconf -d lo.dory")
      end
    end
  end
end
