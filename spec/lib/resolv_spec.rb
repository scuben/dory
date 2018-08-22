RSpec.describe Dory::Resolv do
  let(:modules) do
    [
      Dory::Resolv::Linux,
      Dory::Resolv::LinuxResolvconf,
      Dory::Resolv::Macos
    ]
  end
  let(:methods) do
    %i[has_our_nameserver? configure clean file_nameserver_line]
  end

  it 'calls the versions based on platform' do
    modules.each do |platform|
      allow(Dory::Os).to receive(:macos?) { platform == Dory::Resolv::Macos }
      allow(Dory::Resolv).to receive(:resolvconf?) { platform == Dory::Resolv::LinuxResolvconf }
      methods.each do |m|
        allow(platform).to receive(m)
        Dory::Resolv.send(m)
        expect(platform).to have_received(m)
      end
    end
  end
end
