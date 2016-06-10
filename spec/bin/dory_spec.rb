load 'bin/dory'

RSpec.describe DoryBin do
  CONFIG_FILENAME = '/tmp/dory-test-config.yml'

  def run_with(*args)
    DoryBin.start(args)
  end

  let(:dory_bin) { DoryBin.new }

  before :all do
    File.delete(CONFIG_FILENAME) if File.exist?(CONFIG_FILENAME)
  end

  after :all do
    File.delete(CONFIG_FILENAME) if File.exist?(CONFIG_FILENAME)
  end

  before :each do
    allow(Dory::Config).to receive(:filename) { CONFIG_FILENAME }
  end

  describe 'up' do

  end

  describe 'down' do

  end

  describe 'version' do

  end

  describe 'restart' do

  end

  describe 'status' do

  end

  describe 'config file' do
    let(:config_file_exists?) { ->() { File.exist?(Dory::Config.filename)}}

    let(:old_config) do
      %Q(---
        :dory:
          :dnsmasq:
            :enabled: true
            :domain: docker_test_name
            :address: 192.168.11.1
            :container_name: dory_dnsmasq_test_name
          :nginx_proxy:
            :enabled: true
            :container_name: nginx_container_name
          :resolv:
            :enabled: true
            :nameserver: 192.168.11.1
      ).split("\n").map{|s| s.sub(' ' * 6, '')}.join("\n")
    end

    it 'writes a config file' do
      expect{ run_with('config-file') }.to change{ config_file_exists?.call }.from(false).to(true)
    end

    context 'upgrades' do
      before :each do
        File.write(CONFIG_FILENAME, old_config)
        run_with('config-file', '--upgrade')
      end

      it 'converts symbol keys to strings' do
        yaml = YAML.load_file(CONFIG_FILENAME)
        yaml.each_key do |k|
          expect(k).to be_a(String)
          yaml[k].each_key{ |ck| expect(ck).to be_a(String) }
        end
      end

      it 'moves domain and address into array' do
        yaml = YAML.load_file(CONFIG_FILENAME).with_indifferent_access
        expect(yaml[:dory][:dnsmasq][:domain]).to be_nil
        expect(yaml[:dory][:dnsmasq][:address]).to be_nil
        expect(yaml[:dory][:dnsmasq][:domains].length).to eq(1)
        expect(yaml[:dory][:dnsmasq][:domains][0][:domain]).to eq('docker_test_name')
        expect(yaml[:dory][:dnsmasq][:domains][0][:address]).to eq('192.168.11.1')
      end
    end

    context 'config_file_action' do
      it 'doesn\'t ask about upgrading if flag is set' do
        expect(dory_bin.send('config_file_action', { upgrade: true })).to eq('u')
      end

      it 'doesn\'t ask about overwriting if flag is set' do
        expect(dory_bin.send('config_file_action', { force: true })).to eq('o')
      end

      it 'infers upgrade if both upgrade and force are set' do
        expect(dory_bin.send('config_file_action', { upgrade: true, force: true })).to eq('u')
      end
    end
  end
end
