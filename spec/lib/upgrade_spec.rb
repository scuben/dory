require 'ostruct'

RSpec.describe Dory::Upgrade do
  context 'parsing the version' do
    let(:version_num) { "2.2.2" }

    let(:version_str) do
      ->(version_number) do
        "dory (#{version_number})\n"
      end
    end

    let(:stub_sh) do
      ->(success, stdout) do
        allow(Dory::Sh).to receive(:run_command) do
          OpenStruct.new(success?: success, stdout: stdout)
        end
      end
    end

    it "parses the new version" do
      stub_sh.call(true, version_str.call(version_num))
      expect(Dory::Upgrade.new_version).to eq(version_num)
    end

    it "returns an error if the regex parses multiple matches" do
      stub_sh.call(true, 'dory some version')
      expect(Dory::Upgrade.new_version).to be_falsey
    end

    it "returns an error if the regex parses multiple matches" do
      stub_sh.call(false, '')
      expect(Dory::Upgrade.new_version).to be_falsey
    end
  end

  it 'knows if it is outdated' do
    expect(Dory::Upgrade.outdated?(Dory.version)).to be_falsey
    expect(Dory::Upgrade.outdated?('fake version')).to be_truthy
  end

  it 'gem installs a new dory' do
    allow(Dory::Sh).to receive(:run_command).with('gem install dory') { true }
    expect(Dory::Upgrade.install).to be_truthy
  end

  it 'cleans up old gems' do
    allow(Dory::Sh).to receive(:run_command).with('gem cleanup dory') { true }
    expect(Dory::Upgrade.cleanup).to be_truthy
  end
end
