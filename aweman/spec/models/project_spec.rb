require 'spec_helper'

describe Project do
  before(:each) do
    @attr = {
      :name => "test project",
      :description => "foobar"
      }
  end
  
  it "should create a new instance given valid attrs" do
    Project.create!(@attr)
  end
  
  it "should have a not empty name" do
      no_name_user = Project.create(@attr.merge(:name => ""))
      no_name_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
      long_name = "a" * 51
      long_name_project = Project.new(@attr.merge(:name => long_name))
      long_name_project.should_not be_valid
  end
  
  it "should reject duplicate names" do
      Project.create!(@attr)
      duplicate_project = Project.new(@attr)
      duplicate_project.should_not be_valid
  end
end
