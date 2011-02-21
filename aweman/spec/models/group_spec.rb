require 'spec_helper'

describe Group do
  
  before(:each) do
    @attr = {
      :nr => 23
    }
  end
  
  it "should create instance" do
    Group.create!(@attr)
  end
  
  it "should reject number 0" do
    group = Group.new(@attr.merge(:nr => 0))
    group.should_not be_valid
  end
  
  it "should reject float numbers" do
    group = Group.new(@attr.merge(:nr => 23.5))
    group.should_not be_valid
  end
  
  it "should reject duplicate numbers" do
    Group.create!(@attr)
    group_duplicate = Group.new(@attr)
    group_duplicate.should_not be_valid
  end
  
  describe "groupprojects" do
    before(:each) do
      @group = Group.new(@attr)
      @project = Project.new(:name => "foo")
    end
    
    it "should have a groupprojects method" do
      @group.should respond_to(:group_projects)
    end
  end
end
