require 'spec_helper'
require 'part2/question2/entities/user'

describe Entities::User do
  let(:user_entity_options) do
    {
      id: 1,
    }
  end

  subject { described_class.new(user_entity_options) }

  it 'has an id' do
    subject.id.should == 1
  end
end
