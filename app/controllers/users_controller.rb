require_relative '../services/users_service'

class UsersController < ApplicationController
  before_action :authorize_request, except: [:list, :send_mail]

  def list
    data = Services::UsersService.new(params).list

    render json: {data: data}
  end


  def create
    data = Services::UsersService.new(params, session[:user_id]).create

    return render json: {errs: data[:errs]}, status: 500 if data[:has_error]

    render json: {data: data}
  end

  def update
    data = Services::UsersService.new(params, session[:user_id]).update

    return render json: {errs: data[:errs]}, status: 500 if data[:has_error]

    render json: {data: data}
  end

  def edit
    data = Services::UsersService.new(params, session[:user_id]).edit

    return render json: {errs: data[:errs]}, status: 500 if data[:has_error]

    render json: {data: data}
  end

  def destroy
    data = Services::UsersService.new(params, session[:user_id]).destroy

    return render json: {errs: data[:errs]}, status: 500 if data[:has_error]

    render json: {data: data}
  end

  def password_reset
    data = Services::UsersService.new(params, session[:user_id]).password_reset

    return render json: {errs: data[:errs]}, status: 500 if data[:has_error]

    render json: {data: data}
  end

  def send_mail
    data = Services::UsersService.new(params, session[:user_id]).send_mail

    return render json: {errs: data[:errs]}, status: 500 if data[:has_error]

    render json: {data: data}
  end

end
