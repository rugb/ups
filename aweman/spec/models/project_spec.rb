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
  
  describe "group_projects" do
    before(:each) do
      @project = Project.create(@attr)
      @group = Group.create(:nr => 24)
    end
    
    it "should have a group_projects method" do
      @project.should respond_to(:group_projects)
    end
    
    it "should have a groups method" do
      @project.should respond_to(:groups)
    end
    
    it "should have a method has_group?" do
      @project.should respond_to(:has_group?)
    end
    
    it "should have a method add_group!" do
      @project.should respond_to(:add_group!)
    end
    
    it "should add groups" do
      @project.add_group!(@group)
      @project.has_group?(@group).should be_true
    end
    
    it "should include the group in the groups array" do
      @project.add_group!(@group)
      @project.groups.should include(@group)
    end
    
    it "should have a remove_group method" do
      @project.should respond_to(:remove_group)
    end
    
    it "should remove a group" do
      @project.add_group!(@group)
      @project.remove_group!(@group)
      @project.has_group?(@group).should be_false
    end
  end
end
