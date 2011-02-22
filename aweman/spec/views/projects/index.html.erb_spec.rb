require 'spec_helper'

describe "projects/index.html.erb" do
  before(:each) do
    assign(:projects, [
      stub_model(Project,
        :name => "Name",
        :client_id => 1,
        :description => "Description"
      ),
      stub_model(Project,
        :name => "Name",
        :client_id => 1,
        :description => "Description"
      )
    ])
  end

  it "renders a list of projects" do
    render

    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
