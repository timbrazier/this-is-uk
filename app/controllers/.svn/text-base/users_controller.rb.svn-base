class UsersController < ApplicationController
  
  before_filter :get_city

  def login
    if request.get?
      session[:user_id] = nil
      @user = User.new
    else
      @user = User.new(params[:user])
      logged_in_user = @user.try_to_login
      if logged_in_user
        session[:user_id] = logged_in_user.id
        flash[:notice] = "You have logged in successfully!"
        redirect_to(session[:destination])
      else
        flash[:notice] = "Invalid user/password combination!"
      end
    end
  end
  
  def register
    if request.post?
      @user = User.new(params[:user])
      if @user.save
        session[:user_id] = @user.id
        flash[:notice] = "You have successfully registered!"
        redirect_to(session[:destination])
      end
    end
  end
  
  def logout
    session[:user_id] = nil
    flash[:notice] = "You have now logged out."
    redirect_to(:controller=>"guide",:action=>"index")
  end
end
