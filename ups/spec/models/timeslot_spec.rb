require 'spec_helper'

describe Timeslot do
  before(:each) do
    @attr = {
      :start_at => DateTime.now,
      :end_at => DateTime.now + 1
      }
  end

  describe "validation" do
    describe "of start_at" do
      it "should reject without start_at" do
        Timeslot.new(@attr.merge(:start_at => nil)).should_not be_valid
      end

      it "should reject with start_at after end_at" do
        Timeslot.new(@attr.merge(:start_at => DateTime.now + 3)).should_not be_valid
      end
    end

    describe "of end_at" do
      it "should reject without end_at" do
        Timeslot.new(@attr.merge(:end_at => nil)).should_not be_valid
      end

      it "should reject with end_at before start_at" do
        Timeslot.new(@attr.merge(:end_at => DateTime.now - 3)).should_not be_valid
      end
    end
  end
end
