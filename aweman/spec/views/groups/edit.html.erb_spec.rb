require 'spec_helper'

describe "groups/edit.html.erb" do
  before(:each) do
    @group = assign(:group, stub_model(Group,
      :nr => 1
    ))
  end

  it "renders the edit group form" do
    render

    assert_select "form", :action => groups_path(@group), :method => "post" do
      assert_select "input#group_nr", :name => "group[nr]"
    end
  end
end
