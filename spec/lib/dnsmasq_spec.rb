RSpec.describe Dory::Dnsmasq do
  let(:dory_config) do
    %q(---
      :dory:
        :dnsmasq:
          :enabled: true
          :domain: docker_test_name
          :address: 192.168.11.1
          :container_name: dory_dnsmasq_test_name
    ).split("\n").map{|s| s.sub(' ' * 6, '')}.join("\n")
  end

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

  after :all do
    Dory::Dnsmasq.delete
  end

  it "has the docker client" do
    expect(Dory::Dnsmasq).to have_docker_client
  end

  it "respects settings (Using defaults)" do
    allow(Dory::Config).to receive(:filename) { "/tmp/doesnotexist.lies" }
    allow(Dory::Config).to receive(:default_yaml) { dory_config }
    expect(Dory::Dnsmasq.container_name).to eq('dory_dnsmasq_test_name')
    expect(Dory::Dnsmasq.domain).to eq('docker_test_name')
    expect(Dory::Dnsmasq.addr).to eq('192.168.11.1')
  end

  it "starts up the container" do
    Dory::Dnsmasq.delete
    expect(Dory::Dnsmasq).not_to be_running
    expect{Dory::Dnsmasq.start}.to change{Dory::Dnsmasq.running?}.from(false).to(true)
    expect(Dory::Dnsmasq).to be_container_exists
  end

  it "doesn't fail when starting the container twice" do
    2.times{ expect{Dory::Dnsmasq.start}.not_to raise_error }
    expect(Dory::Dnsmasq).to be_running
  end

  it "deletes the container" do
    expect(Dory::Dnsmasq.start).to be_truthy
    expect(Dory::Dnsmasq).to be_running
    expect(Dory::Dnsmasq).to be_container_exists
    expect{Dory::Dnsmasq.delete}.to change{Dory::Dnsmasq.container_exists?}.from(true).to(false)
    expect(Dory::Dnsmasq).not_to be_running
  end

  it "stops the container" do
    expect(Dory::Dnsmasq.start).to be_truthy
    expect(Dory::Dnsmasq).to be_running
    expect(Dory::Dnsmasq.stop).to be_truthy
    expect(Dory::Dnsmasq).to be_container_exists
    expect(Dory::Dnsmasq).not_to be_running
  end

  it "starts the container when it already exists" do
    expect(Dory::Dnsmasq.start).to be_truthy
    expect(Dory::Dnsmasq).to be_running
    expect(Dory::Dnsmasq.stop).to be_truthy
    expect(Dory::Dnsmasq).to be_container_exists
    expect{Dory::Dnsmasq.start}.to change{Dory::Dnsmasq.running?}.from(false).to(true)
    expect(Dory::Dnsmasq).to be_container_exists
    expect(Dory::Dnsmasq).to be_running
  end

  context 'pre-existing listener on 53' do
    let(:port) { 53 }

    before(:each) { start_service_on_53 }
    after(:each) { cleanup_53 }

    it "detects listening services" do
      expect(Dory::Dnsmasq.check_port(port).count).to eq(2)
      Dory::Dnsmasq.check_port(port).each { |p| expect(p.command).to match(/^(ncat|exe)$/) }
    end

    it "kills listening services" do
      expect(Dory::Dnsmasq.check_port(port)).not_to be_empty
      expect(Dory::Dnsmasq.offer_to_kill(Dory::Dnsmasq.check_port(port), answer: 'y')).to be_truthy
      expect(Dory::Dnsmasq.check_port(port)).to be_empty
    end

    it "doesn't kill the listening services if declined" do
      expect(Dory::Dnsmasq.check_port(port)).not_to be_empty
      expect(Dory::Dnsmasq.offer_to_kill(Dory::Dnsmasq.check_port(port), answer: 'n')).to be_falsey
      expect(Dory::Dnsmasq.check_port(port)).not_to be_empty
    end
  end
end
