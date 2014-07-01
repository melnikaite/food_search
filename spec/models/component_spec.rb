require 'rails_helper'

RSpec.describe Component, :type => :model do
  it { should have_and_belong_to_many(:foods) }
end
