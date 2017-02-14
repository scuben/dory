RSpec.describe Dory::PortUtils do
  def start_service_on_53
    puts "Requesting sudo to start an ncat listener on 53"
    `sudo echo 'Got sudo. starting ncat listener'`
    Process.spawn('sudo ncat -l 53')
    sleep(0.5)  # give the process time to bind
  end

  def cleanup_53
    Dory::Sh.run_command('sudo killall ncat')
    Dory::Sh.run_command('sudo killall exe')
  end

  describe '#check_port' do
    let(:port) { 53 }

    before(:each) { start_service_on_53 }
    after(:each) { cleanup_53 }

    it "detects listening services" do
      expect(Dory::PortUtils.check_port(port).count).to eq(2)
      Dory::PortUtils.check_port(port).each { |p| expect(p.command).to match(/^(ncat|exe)$/) }
    end
  end
end
