class AuthenticationController < ApplicationController
  def sign_in
    @user = User.new
  end

  def login
    @user = User.new
    username_or_email = params[:user][:username]
    password = params[:user][:password]

    if username_or_email.rindex('@')
      email = username_or_email
      user = User.authenticate_by_email(email, password)
    else
      username = username_or_email
      user = User.authenticate_by_username(username, password)
    end

    if user
      session[:user_id] = user.id
      flash[:notice] = 'Welcome.'
      redirect_to :root
    else
      flash.now[:error] = 'Unknown user or incorrect password.'
      render :action => 'sign_in'
    end

  end

  def signed_out
    session[:user_id] = nil
    flash[:notice] = 'You have been signed out.'
  end

  def account_settings
    @user = current_user
  end

  def set_account_info
    old_user = current_user

    # verify the current password
    unless User.authenticate_by_username(old_user.username, params[:user][:password]).nil?
      # set the new_password of the user object to the new_password from the PUT
      @user = current_user
      puts '------------'
      puts '@user.nil?: ' + @user.nil?.to_s
      puts '@user.username.nil?: ' + @user.username.nil?.to_s
      puts '@user.username: ' + @user.username.to_s
      puts '@user.email.nil?: ' + @user.email.nil?.to_s
      puts '@user.email: ' + @user.email.to_s
      puts '@user.password.nil?: ' + @user.password.nil?.to_s
      puts '@user.new_password.nil?: ' + @user.new_password.nil?.to_s
      puts '@user.password: ' + @user.password.to_s
      puts '@user.new_password: ' + @user.new_password.to_s
      puts '------------'

      @user.new_password = params[:user][:new_password]
    else
      @user = nil
    end

    # provide an error message or update the user record
    if @user.nil?
      @user = current_user
      @user.errors[:password] = 'Password is incorrect.'
      render :action => 'account_settings'
    else
      if @user.valid?
        # If there is a new_password value, then we need to update the password.
        puts '------------'
        puts '@user.nil?: ' + @user.nil?.to_s
        puts '@user.username.nil?: ' + @user.username.nil?.to_s
        puts '@user.username: ' + @user.username.to_s
        puts '@user.email.nil?: ' + @user.email.nil?.to_s
        puts '@user.email: ' + @user.email.to_s
        puts '@user.password.nil?: ' + @user.password.nil?.to_s
        puts '@user.new_password.nil?: ' + @user.new_password.nil?.to_s
        puts '@user.password: ' + @user.password.to_s
        puts '@user.new_password: ' + @user.new_password.to_s
        puts '------------'
        @user.password = @user.new_password unless @user.new_password.nil? || @user.new_password.empty?
        @user.save
        flash[:notice] = 'Account settings have been changed.'
        redirect_to :root
      else
        render :action => 'account_settings'
      end
    end

  end

  def change_password

  end


  def forgot_password

  end


  def new_user
    @user = User.new
  end

  def register
    @user = User.new(params[:user])

    if @user.valid?
      @user.save
      session[:user_id] = @user.id
      flash[:notice] = 'Welcome.'
      redirect_to :root
    else
      render :action => 'new_user'
    end
  end

  def password_sent

  end

end