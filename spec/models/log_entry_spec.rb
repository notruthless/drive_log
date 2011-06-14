require 'spec_helper'

describe LogEntry do
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :notes => "value for notes",
      :start_time => 10.minutes.ago,
      :end_time => 1.minute.ago,
      :night => false
    }
  end

  it "should create a new instance given valid attributes" do
    @user.log_entries.create!(@attr)
  end
  
  describe "user associations" do

    before(:each) do
      @entry = @user.log_entries.create(@attr)
    end

    it "should have a user attribute" do
      @entry.should respond_to(:user)
    end

    it "should have the right associated user" do
      @entry.user_id.should == @user.id
      @entry.user.should == @user
    end
  end
  
   describe "validations" do

    it "should require a user id" do
      LogEntry.new(@attr).should_not be_valid
    end

    it "should require a start time" do
      @user.log_entries.build(:start_time => 0).should_not be_valid
    end

    it "should require an end time" do
      @user.log_entries.build(:end_time => 0).should_not be_valid
    end

    it "should reject long notes" do
      @user.log_entries.build(:notes => "a" * 251).should_not be_valid
    end
  end
  
  describe "log entries" do
    before(:each) do
      @entry = @user.log_entries.create(@attr)
    end

    it "should calculate elapsed time" do
      @entry.elapsed_time.should == ((@attr[:end_time] - @attr[:start_time])/60).round
    end
  end
 
end
