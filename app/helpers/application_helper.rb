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
    image_tag("logo.png", :alt => "Sample App", :class => "round")
  end
  
  def night
   image_tag("night.jpg",  'alt="Night"', 'title="Night"')
  end
end
