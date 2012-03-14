# encoding: utf-8
class ApprovalsController < ApplicationController

  before_filter :authenticate
  before_filter :admin_user

 
  def update
    @user = User.find(params[:id])
    if user_accessing_self?
      redirect_to users_path, :flash => {:error => "Itseään ei voi hyväksyä/hylätä."}
    else
      @user.toggle!(:approved)
      redirect_to users_path, :flash => {:success => "Tila muutettu."}
    end
  end

end
