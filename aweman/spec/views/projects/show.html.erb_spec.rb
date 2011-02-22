require 'spec_helper'

describe "projects/show.html.erb" do
  before(:each) do
    @client = Client.create(
      :name => "foobar"
    )
    @project = assign(:project, stub_model(Project,
      :name => "Name",
      :client_id => 1,
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/foobar/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
  end
end
