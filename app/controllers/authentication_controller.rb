class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @user = User.find_by_email(params[:email])

    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 1.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                     user_id: @user.id, profile: @user.profile.as_json }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private
  def login_params
    params.permit(:email, :password)
  end
end