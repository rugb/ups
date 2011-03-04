require 'spec_helper'

include ApplicationHelper

def category_name(category)
  select_by_language_id(category).name
end

def select_by_language_id(category)
  return category.category_names.first
end

describe LinksHelper do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "linklist" do
    it "should return nil if no category given" do
      linklist(nil).should == nil
    end

    it "should return a string, if a category_id given" do
      linklist(Category.first.id).should_not == nil
    end

    it "should return a string, if a category_name is given" do
      linklist(Category.first.category_names.first.name).should_not == nil
    end

    it "should return a string containing ul, li and h2"
  end
end
