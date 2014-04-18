require 'spec_helper'
require 'part2/question2/user/user'

describe User::CreateUser do
  subject { User.create_user }

  it 'creates a new user' do
    new_user = subject.execute({name: "Test User"})
    new_user.id.should_not be_nil
    new_user.roles.should == []
    new_user.name.should  == "Test User"
  end

  it 'raises error if user already exists for a given id' do
    new_user = subject.execute({name: "Test User"})

    expect { subject.execute({name: "Test User", id: new_user.id}) }.to raise_error User::Memory::Model::UserAlreadyExistsError
  end
end
