RSpec.describe Dory::Resolv do
  let(:modules) { [Dory::Resolv::Linux, Dory::Resolv::Macos] }
  let(:methods) do
    %i[has_our_nameserver? configure clean]
  end

  it 'calls the versions based on platform' do
    modules.each do |platform|
      allow(Dory::Os).to receive(:macos?) { platform == Dory::Resolv::Macos }
      methods.each do |m|
        allow(platform).to receive(m)
        Dory::Resolv.send(m)
        expect(platform).to have_received(m)
      end
    end
  end
end
