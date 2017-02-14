require_relative 'docker_service'

module Dory
  module Systemd
    def self.has_systemd?
      Sh.run_command('which systemctl').success?
    end

    def self.systemd_service_installed?(service)
      !(Sh.run_command("systemctl status #{service} | head -1").stdout =~ /not-found/)
    end

    def self.systemd_service_running?(service)
      !!(Sh.run_command("systemctl status #{service} | head -3").stdout =~ /Active:\s+active.*running/)
    end

    def self.systemd_service_enabled?(service)
      !!(Sh.run_command("systemctl status #{service} | head -3").stdout.gsub(/Loaded.*?;/, '') =~ /^\s*enabled;/)
    end

    def self.set_systemd_service(service:, up:)
      action = up ? 'start' : 'stop'
      puts "Requesting sudo to #{action} #{service}".green
      Sh.run_command("sudo systemctl #{action} #{service}").success?
    end
  end
end
