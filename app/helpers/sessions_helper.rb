# encoding: utf-8

module SessionsHelper

  def user_accessing_self?
    current_user == params[:id]
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def friend
    redirect_to root_path unless current_user.is_friends_with(params[:id])
  end

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    @current_user=user
  end

  def signed_in?
    not current_user.nil?
  end


  def current_user
    @current_user ||= user_from_remember_token
  end

  def sign_out
    cookies.delete(:remember_token)
    @current_user=nil
  end

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, :flash =>{:notice => "Sinun täytyy kirjautua sisään katsoaksesi sivua. "}
  end

  def redirect_to_stored_location_or(user)
    redirect_to(session[:redirect_to] || user)
    clear_stored_location
  end

  private

  def store_location
    session[:redirect_to] = request.fullpath
  end

  def clear_stored_location
    session[:redirect_to] = nil
  end

  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    cookies.signed[:remember_token] ||= [nil, nil]
  end


end
