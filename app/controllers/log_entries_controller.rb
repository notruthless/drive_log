class LogEntriesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  
  def create
    @log_entry  = current_user.log_entries.build(params[:log_entry])
    if @log_entry.save
      flash[:success] = "Log entry created!"
      redirect_to root_path
    else
      render 'pages/home'
    end
  end
  
  def destroy
    @log_entry.destroy
    redirect_back_or root_path
  end

  private

    def authorized_user
      @log_entry = LogEntry.find(params[:id])
      redirect_to root_path unless current_user?(@log_entry.user)
    end
end
