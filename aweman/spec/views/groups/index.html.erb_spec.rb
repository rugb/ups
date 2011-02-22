require 'spec_helper'

describe "groups/index.html.erb" do
  before(:each) do
    assign(:groups, [
      stub_model(Group,
        :nr => 1
      ),
      stub_model(Group,
        :nr => 1
      )
    ])
  end

  it "renders a list of groups" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
