require 'colorize'

module Dory
  module Resolv
    module Macos
      def self.system_resolv_file
        '/etc/resolv.conf'
      end

      def self.port
        19323
      end

      def self.resolv_dir
        '/etc/resolver'
      end

      def self.resolv_file_name
        'dory'
      end

      def self.resolv_file
        "#{self.resolv_dir}/#{self.resolv_file_name}"
      end

      def self.nameserver
        Dory::Config.settings[:dory][:resolv][:nameserver]
      end

      def self.file_nameserver_line
        "nameserver #{self.nameserver}"
      end

      def self.file_comment
        '# added by dory'
      end

      def self.resolv_contents
        <<-EOF.gsub(' ' * 10, '')
          #{self.file_comment}
          #{self.file_nameserver_line}
          port #{self.port}
        EOF
      end

      def self.configure
        # have to use this hack cuz we don't run as root :-(
        puts "Requesting sudo to write to #{self.resolv_file}".green
        Bash.run_command("echo -e '#{self.resolv_contents}' | sudo tee #{Shellwords.escape(self.resolv_file)} >/dev/null")
      end

      def self.clean
        puts "Requesting sudo to delete '#{self.resolv_file}'"
        Bash.run_command("sudo rm -f #{self.resolv_file}")
      end

      def self.system_resolv_file_contents
        File.read(self.system_resolv_file)
      end

      def self.resolv_file_contents
        File.read(self.resolv_file)
      end

      def self.has_our_nameserver?
        self.contents_has_our_nameserver?(self.system_resolv_file)
      end

      def self.contents_has_our_nameserver?(contents)
       !!((contents =~ /#{self.file_comment}/) || (contents =~ /#{self.file_nameserver_line}/))
      end
    end
  end
end
