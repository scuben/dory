require_relative 'docker_service'

module Dory
  module Systemd
    def self.up_delay_seconds
      Dory::Config.settings[:dory][:dnsmasq][:service_start_delay] || 5
    end

    def self.has_systemd?
      Sh.run_command('which systemctl').success?
    end

    def self.systemd_service_installed?(service)
      return false unless self.has_systemd?
      !(Sh.run_command("systemctl status #{service} | head -1").stdout =~ /not-found/)
    end

    def self.systemd_service_running?(service)
      return false unless self.has_systemd?
      !!(Sh.run_command("systemctl status #{service} | head -3").stdout =~ /Active:\s+active.*running/)
    end

    def self.systemd_service_enabled?(service)
      return false unless self.has_systemd?
      !!(Sh.run_command("systemctl status #{service} | head -3").stdout.gsub(/Loaded.*?;/, '') =~ /^\s*enabled;/)
    end

    def self.set_systemd_service(service:, up:)
      action = up ? 'start' : 'stop'
      puts "Requesting sudo to #{action} #{service}".green
      retval = Sh.run_command("sudo systemctl #{action} #{service}").success?

      # We need to wait a few seconds for init if putting stuff up to avoid race conditions
      if up
        puts "Waiting #{self.up_delay_seconds} seconds for #{service} to start ...".green
        sleep(self.up_delay_seconds)
      end

      retval
    end
  end
end
