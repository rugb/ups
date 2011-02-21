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
  
  describe "group_projects" do
    before(:each) do
      @group = Group.new(@attr)
      @project = Project.new(:name => "foo")
    end
    
    it "should have a group_projects method" do
      @group.should respond_to(:group_projects)
    end
    
    it "should have a projects method" do
      @group.should respond_to(:projects)
    end
    
    it "should have a method has_project?" do
      @group.should respond_to(:has_project?)
    end
    
    it "should have a method add_project!" do
      @group.should respond_to(:add_project!)
    end
    
    it "should add projects" do
      @group.add_project!(@project)
      @group.has_project?.should be_true
    end
    
    it "should include the project in the projects array" do
      @group.add_project!(@project)
      @group.projects.should include(@project)
    end
  end
end
