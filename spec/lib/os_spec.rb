RSpec.describe Dory::Os do
  it "knows we're on ubuntu" do
    expect(Dory::Os.ubuntu?).to be_truthy
    expect(Dory::Os.fedora?).to be_falsey
    expect(Dory::Os.arch?).to be_falsey
    expect(Dory::Os.macos?).to be_falsey
  end
end
