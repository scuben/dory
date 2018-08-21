require 'rspec'

RSpec.describe Dory::Resolv::LinuxResolvconf do
  describe '.file_nameserver_line' do
    it 'delegates to the linux module'
  end

  describe '.nameserver_contents' do
    it 'delegates to the linux module'
  end

  describe '.has_our_nameserver?' do
    it 'delegates to the linux module'
  end

  describe '.configure' do
    before do
      allow(Dory::Bash).to receive(:run_command)
    end

    it 'runs resolvconf' do
      Dory::Resolv::LinuxResolvconf.configure
      expect(Dory::Bash).to have_received(:run_command).with(
        "echo -e 'nameserver 127.0.0.1  # added by dory' | sudo resolvconf -a lo.dory"
      )
    end
  end

  describe '.clean' do
    before do
      allow(Dory::Bash).to receive(:run_command)
    end

    it 'runs resolvconf' do
      Dory::Resolv::LinuxResolvconf.clean
      expect(Dory::Bash).to have_received(:run_command).with(
        'sudo resolvconf -d lo.dory'
      )
    end
  end
end
