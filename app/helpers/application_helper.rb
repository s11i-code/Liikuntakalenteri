# encoding: utf-8

module ApplicationHelper

  def title
    @app_name = "yolk | "
    if @page_title.nil?
      @app_name
    else
      @app_name +" " + @page_title
    end
  end

  def logo
    image_tag('uusi_logo.png', :alt => 'Sample App')
  end

  def gravatar_for(user, options = { :size => 45, :default => "mm"})
    gravatar_image_tag(user.email, :class => "gravatar", :gravatar => options)
  end

  def as_inessive(location)

    case location.downcase
    when "meilahti" then "Meilahdessa"
    when "viikki" then "Viikissä"
    else location.capitalize + "ssa"
    end

  end
end
