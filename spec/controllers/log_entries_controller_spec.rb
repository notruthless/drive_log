require 'spec_helper'

describe LogEntriesController do
  render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "failure" do

      before(:each) do
        @attr = { :start_time => nil }
      end

      it "should not create a log entry" do
        lambda do
          post :create, :log_entry => @attr
        end.should_not change(LogEntry, :count)
      end

      it "should render the home page" do
        post :create, :log_entry => @attr
        response.should render_template('pages/home')
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :start_time => 10.minutes.ago, :end_time => 1.minute.ago }
      end

      it "should create a log_entry" do
        lambda do
          post :create, :log_entry => @attr
        end.should change(LogEntry, :count).by(1)
      end

      it "should redirect to the home page" do
        post :create, :log_entry => @attr
        response.should redirect_to(root_path)
      end

      it "should have a flash message" do
        post :create, :log_entry => @attr
        flash[:success].should =~ /log entry created/i
      end
    end
  end
  
  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(wrong_user)
        @log_entry = Factory(:log_entry, :user => @user)
      end

      it "should deny access" do
        delete :destroy, :id => @log_entry
        response.should redirect_to(root_path)
      end
    end

    describe "for an authorized user" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @log_entry = Factory(:log_entry, :user => @user)
      end

      it "should destroy the log entry" do
        lambda do 
          delete :destroy, :id => @log_entry
        end.should change(LogEntry, :count).by(-1)
      end
    end
  end  

end