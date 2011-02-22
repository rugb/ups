require 'spec_helper'

describe "users/index.html.erb" do
  before(:each) do
    assign(:users, [
    stub_model(User,
        :name => "Name",
        :email => "Email",
        :group_id => nil
    ),
    stub_model(User,
        :name => "Name",
        :email => "Email",
        :group_id => nil
    )
    ])
  end
  
  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "Name", :count => 2
    assert_select "tr>td", :text => "Email", :count => 2
  end
end
