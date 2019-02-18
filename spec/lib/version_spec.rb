require 'spec_helper'

RSpec.describe Dory do
  it 'has a version number' do
    expect(Dory.version).not_to be_nil
  end

  it 'has a date' do
    expect(Dory.date).not_to be_nil
  end
end
