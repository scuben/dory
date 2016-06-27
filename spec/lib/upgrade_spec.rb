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
          OpenStruct.new(success?: true, stdout: stdout)
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
end
