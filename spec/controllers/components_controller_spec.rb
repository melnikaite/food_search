require 'rails_helper'

RSpec.describe ComponentsController, :type => :controller do
  it 'should show all components' do
    component = FactoryGirl.create(:component)
    get :index
    assert_response :success
    result = JSON.parse(response.body)
    result[0]['id'].should == component.id
  end
end
