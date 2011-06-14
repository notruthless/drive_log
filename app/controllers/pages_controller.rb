class PagesController < ApplicationController
  def home
    @title = "Home"
    @log_entry = LogEntry.new if signed_in?
    @list_items = current_user.log_entries.paginate(:page => params[:page]) if signed_in?
  end

  def contact
    @title = "Contact"
  end
  
  def about
    @title = "About"
  end
  
  def help
    @title = "Help"
  end

end
