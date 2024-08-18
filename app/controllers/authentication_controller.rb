# frozen_string_literal: true

class AuthenticationController < ApplicationController
  def login
    user = User.find_by(email: params[:email])

    if user && user.valid_password?(params[:password])
      token = JsonWebTokenService.encode(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end
