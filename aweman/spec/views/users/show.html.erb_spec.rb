require 'spec_helper'

describe "users/show.html.erb" do
  describe "user without group" do
    before(:each) do
      @user = User.create!(:name => "Bill Gates", :email => "gates@microsoft.com")
    end
    
    it "renders attributes in <p> and group building form" do
      render
      
      rendered.should match(/Name/)
      rendered.should match(/Email/)
      
      assert_select "form", :action => group_with_user_path(@user), :method => "post" do
        assert_select "select#group_with_user_id", :name => "group_with[group_id]"
      end
    end
  end
  
  describe "user with group" do
    before(:each) do
      @user = User.create!(:name => "Bill Gates", :email => "gates@microsoft.com")
      @group = Group.create!(:nr => 23)
      @user.group = @group
      @user.save
    end
    
    it "renders attributes in <p>" do
      render
      
      rendered.should match(/Name/)
      rendered.should match(/Email/)
      rendered.should match(/23/)
    end
  end
end
