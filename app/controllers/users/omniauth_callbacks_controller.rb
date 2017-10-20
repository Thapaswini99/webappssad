class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "twitter") if is_navigational_format?
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")
      auth = request.env["omniauth.auth"].except("extra")
      session[:omniauth] = auth
      user = User.from_omniauth(auth)
      session[:user_id] = user.id
      redirect_to root_path, notice: "signed in successfully"
    end
  end

  def failure
    redirect_to root_path
  end
end
