# encoding: utf-8
require 'will_paginate/array'

class UsersController < ApplicationController

  before_filter :authenticate, :except => [:new, :create]
  before_filter :admin_user, :only => [:destroy]

  def index
    @user_count = User.count
    @users = User.all(:order => :name).paginate(:page => params[:page])
    @page_title = index_page_title
  end

  def new
    @page_title = sign_up_title
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @page_title = show_page_title
    @events = @user.events.all.paginate(:page => params[:page], :per_page => 15)
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Kiitos hakemuksestasi. Käsittelemme sen viipymättä. "
      redirect_to contact_path
    else
      @page_title = sign_up_title
      render "new"
    end
  end

  def edit
    @page_title = edit_page_title
    @user = current_user
  end

  def update
    @user = current_user
    @page_title = edit_page_title
    user_params = params[:user]

    if user_params[:password].blank?
      user_params.delete :password
      user_params.delete :password_confirmation
    end

    if @user.update_attributes(user_params)
      flash[:success] = "Tiedot päivitetty."
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    if (current_user == @user)
      redirect_to users_path, :flash => {:error => "Älä nyt itseäsi tuhoa."}
    else
      @user.destroy
      redirect_to users_path, :flash => {:success => "Käyttäjä poistettu."}
    end
  end

  def friends
    @user = User.find(params[:id])
    @page_title = "Kaverit"
    @friends = @user.friends
  end
  
  def friendship_requests
    @user = current_user
    @friendship_requesters = @user.friendship_requesters
  end

  private

  def show_page_title
    @user.name
  end

  def sign_up_title
    "Tilin luominen"
  end

  def edit_page_title
    "Tietojen päivitys"
  end

  def index_page_title
    "Kaikki käyttäjät"
  end


end
