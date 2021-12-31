require 'jwt/json_web_token.rb'
class ApplicationController < ActionController::API

    def authorize_request
        headers = request.headers['Authorization']
        headers = headers.split(' ').last if headers
        begin
            @decoded = JsonWebToken.decode(headers)
            @current_user = User.find(@decoded[:id]) 
        rescue JWT::DecodeError => e
            render json: {errors: e.message}, status: :unauthorized
        rescue ActiveRecord::RecordNotFound => e
            render json: {errors: e.message}, status: :unauthorized
        end
    end
end
