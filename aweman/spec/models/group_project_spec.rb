require 'spec_helper'

describe GroupProject do
  before(:each) do
    @group = Group.new(:nr => 23)
    @project = Project.new(:name => "foo")

    @groupproject = @group.groupprojects.build(:project_id => @project.id)
  end

  it "should create a new instance given valid attributes" do
    @groupproject.save!
  end

  describe "group/project methods" do
    before(:each) do
      @groupproject.save
    end
    
    it "should have a group attribute" do
      @groupproject.should respond_to(:group)
    end
    
    it "should have the right group" do
      @groupproject.group.should == @group
    end
    
    it "should have a project attribute" do
      @groupproject.should respond_to(:project)
    end
    
    it "should have the right project" do
      @groupproject.project.should == @project
    end
  end
end
