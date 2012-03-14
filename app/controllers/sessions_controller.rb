# encoding: utf-8
class SessionsController < ApplicationController

  def new
    @page_title = signin_title
  end

  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user
      if user.approved?
        sign_in user
        redirect_to_stored_location_or(root_path)
      else
        redirect_to contact_path, :flash => {:notice => "Käyttöoikeuttasi ei ole vielä vahvistettu."}
      end
    else
      flash.now[:error] = "Sisäänkirjautuminen epäonnistui. Tarkista sähköpostiosoite ja salasana."
      @page_title = signin_title
      render('new')
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def signin_title
    "Sisäänkirjautuminen"
  end
end
