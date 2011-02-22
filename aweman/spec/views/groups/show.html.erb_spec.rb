require 'spec_helper'

describe "groups/show.html.erb" do
  before(:each) do
    @group = assign(:group, stub_model(Group,
      :nr => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/1/)
  end
end
