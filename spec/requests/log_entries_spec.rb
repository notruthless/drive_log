require 'spec_helper'

describe "LogEntries" do

  before(:each) do
    user = Factory(:user)
    visit signin_path
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button
  end

  describe "creation" do

    describe "failure" do

      it "should not make a new log_entry" do
        lambda do
          visit root_path
          fill_in :log_entry_start_time, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(LogEntry, :count)
      end
    end

    describe "success" do

      it "should make a new log_entry" do
        start_time = 20.minutes.ago
        end_time = 5.minutes.ago
        lambda do
          visit root_path
          fill_in :log_entry_start_time, :with => start_time
          fill_in :log_entry_end_time, :with => end_time
          click_button
          response.should render_template('pages/home')
        end.should change(LogEntry, :count).by(1)
      end
    end
  end
end