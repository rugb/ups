require 'spec_helper'

describe GroupProject do
  before(:each) do
    @group = Group.new(:nr => 23)
    @project = Project.new(:name => "foo")
    @group.save
    @project.save
    
    @group_project = @group.group_projects.build(:project_id => @project.id)
  end
  
  it "should create a new instance given valid attributes" do
    @group_project.save
  end
  
  describe "group/project methods" do
    before(:each) do
      @group_project.save
    end
    
    it "should have a group attribute" do
      @group_project.should respond_to(:group)
    end
    
    it "should have the right group" do
      @group_project.group.should == @group
    end
    
    it "should have a project attribute" do
      @group_project.should respond_to(:project)
    end
    
    it "should have the right project" do
      @group_project.project.should == @project
    end
  end
  
  describe "validations" do
    
    it "should require a project_id" do
      @group_project.project_id = nil
      @group_project.should_not be_valid
    end
    
    it "should require a group_id" do
      @group_project.group_id = nil
      @group_project.should_not be_valid
    end
  end
  
end
