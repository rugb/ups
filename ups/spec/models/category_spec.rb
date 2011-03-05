require 'spec_helper'

describe Category do
  before(:each) do
    @attr = { :category_names_attributes => {
      0 => {
        :name => "News",
        :language_id => 1
        }
      }
    }
  end

  it "should create a valid instance" do
    Category.new(@attr)
  end

  describe "get_or_new test" do

    it "should return a new instance" do
      c = Category.get_or_new(@attr)

      c.should be_new_record
    end

    it "should return an existing instance" do
      c = Category.get_or_new(@attr)
      c.save!

      Category.get_or_new(:id => c.id).should_not be_new_record
    end
  end
end
