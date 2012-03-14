# encoding: utf-8
require 'will_paginate/array'

class PagesController < ApplicationController
  
  def home
    if signed_in?
      @user = current_user
      @feed_items = @user.event_feed.paginate(:page => params[:page], :per_page => 15)
    end
    @page_title = home_page_title
  end

  def contact
    @page_title = contact_page_title
  end

  def about
    @page_title = about_page_title
  end

end
