# encoding: utf-8
class FriendshipsController < ApplicationController

  before_filter :authenticate
  
  def create
    @recognised = User.find(params[:recognition][:recognised_id])
    current_user.recognise!(@recognised)
    if params[:requesting_friendship]
      flash[:success] = "Kaveripyyntö lähetetty."
    elsif params[:confirming_friendship]
      flash[:success] = "Kaveripyyntö hyväksytty."
    end
    redirect_to @recognised
    
  end

  def destroy
    @non_recognised_user = User.find(params[:non_recognised_id])
    current_user.anonymise_with(@non_recognised_user)
    if params[:deleting_request]
      flash[:success] = "Kaveripyyntö peruutettu henkilölle " + @non_recognised_user.name  + "."
    elsif params[:deleting_friendship]
      flash[:success] = @non_recognised_user.name  + " poistettu kavereista."
    end
    redirect_to root_path
  end

end
