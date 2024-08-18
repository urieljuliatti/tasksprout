
class AdminController < ApplicationController
  before_action :authenticate_request

  private
    def authenticate_request
      token = request.headers['Authorization']
      if token.present?
        begin
          decoded_token = JsonWebTokenService.decode(token.split(' ').last)
          user_id = decoded_token['user_id']
          @current_user = User.find_by(id: user_id)
          unless @current_user
            render json: { error: 'Not Authorized' }, status: :unauthorized
          end
        rescue => e
          render json: { error: 'Invalid Token' }, status: :unauthorized
        end
      else
        render json: { error: 'Missing Authorization Header' }, status: :unauthorized
      end
    end
end
