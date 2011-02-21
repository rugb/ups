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
      @group = Group.create(@attr)
      @project = Project.create(:name => "foo")
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
      @group.has_project?(@project).should be_true
    end
    
    it "should include the project in the projects array" do
      @group.add_project!(@project)
      @group.projects.should include(@project)
    end
    
    it "should have a remove_project! method" do
      @group.should respond_to(:remove_project!)
    end
    
    it "should remove a project" do
      @group.add_project!(@project)
      @group.remove_project!(@project)
      @group.has_project?(@project).should be_false
    end
  end
  
  describe "user association" do
    before(:each) do
      @group = Group.create(@attr)
    end
    
    it "should have a users attribute" do
      @group.should respond_to(:users)
    end
  end
  
  describe "group building" do
    before(:each) do
      @group1 = Group.new(:nr => 1)
      @group2 = Group.new(:nr => 2)
    end
    
    it "should sort groups by nr" do
      @group2.save
      @group1.save
      
      Group.all.should == [@group1, @group2]
    end
    
    it "should have a method next" do
      Group.should respond_to(:next)
    end
    
    it "should give the lowest free number to new group 1/3" do
      @group = Group.next
      @group.nr.should == 1
    end
    
    it "should give the lowest free number to new group 2/3" do
      @group2.save
      
      @group = Group.next
      @group.nr.should == 1
    end
    
    it "should give the lowest free number to new group 3/3" do
      @group1.save
      @group2.save
      
      @group = Group.next
      @group.nr.should == 3
    end
  end
end
