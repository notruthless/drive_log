module ApplicationHelper

  # Return a title on a per-page basis.
  def title
    base_title = "Driving Log"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def logo
    image_tag("logo.png", :size => "100X25", :alt => "Sample App", :class => "round")
  end
  
end

