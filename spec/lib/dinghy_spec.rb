RSpec.describe Dory::Dinghy do
  def dinghy_bin
    '/usr/local/bin/dinghy'
  end

  def stub_dinghy_ip
    dinghy_script = <<-EOF
      #!/usr/bin/env bash
      echo -e "5.5.5.5"
    EOF
    dinghy_script.gsub!(/^\s\s\s\s\s\s/, '')
    File.write('/tmp/dinghy', dinghy_script)
    Dory::Bash.run_command("sudo mv /tmp/dinghy #{dinghy_bin}")
    Dory::Bash.run_command("chmod +x #{dinghy_bin}")
  end

  def delete_dinghy_stub
    Dory::Bash.run_command("sudo rm #{dinghy_bin}") if File.exist?(dinghy_bin)
  end

  after :all do
    delete_dinghy_stub
  end

  it 'knows if dinghy is installed' do
    stub_dinghy_ip
    expect(Dory::Dinghy.installed?).to be_truthy
    delete_dinghy_stub
    expect(Dory::Dinghy.installed?).to be_falsey
  end

  it 'gets the ip address of the dinghy vm' do
    stub_dinghy_ip
    expect(Dory::Dinghy.ip).to eq('5.5.5.5')
  end

  it 'throws if the dinghy vm isnt running' do

  end

  it 'matches the dinghy string' do
    %w[
      dinghy
      dingy
      dinhgy
      dinhy
    ].each do |str|
      expect(Dory::Dinghy.match?(str)).to be_truthy
    end
  end
end
