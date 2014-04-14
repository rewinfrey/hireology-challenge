require 'spec_helper'
require 'part2/question2/entities/user'

describe Entities::User do
  let(:user_entity_options) do
    {
      id: 1,
      name: "Test User",
    }
  end

  subject { described_class.new(user_entity_options) }

  it 'has an id' do
    subject.id.should == 1
  end

  it 'has a name' do
    subject.name.should == "Test User"
  end
end
