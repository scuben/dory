require_relative 'docker_service'

module Dory
  module PortUtils
    def self.check_port(port_num = self.port)
      puts "Requesting sudo to check if something is bound to port #{port_num}".green
      ret = Dory::Sh.run_command("sudo lsof -i :#{port_num}")
      return [] unless ret.success?

      list = ret.stdout.split("\n")
      list.shift  # get rid of the column headers
      list.map! do |process|
        command, pid, user, fd, type, device, size, node, name = process.split(/\s+/)
        OpenStruct.new({
          command: command,
          pid: pid,
          user: user,
          fd: fd,
          type: type,
          device: device,
          size: size,
          node: node,
          name: name
        })
      end
    end
  end
end
