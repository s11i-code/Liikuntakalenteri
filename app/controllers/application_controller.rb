# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def home_page_title
    "Kotisivu"
  end
  
  def contact_page_title
    "Yhteystiedot"
  end

  def about_page_title
    "Tietoa sivusta"
  end

end
