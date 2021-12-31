require 'jwt/json_web_token.rb'
class V1::AuthController < ApplicationController
  def login 
    response = Hash.new
    user = User.where(username: auth_params[:username]).first
    if user && user.authenticate(auth_params[:password])
       token = JsonWebToken.encode(id: user.id)
       response["messages"] = "Success"
       response["code"] = 200
       response["data"] = user
       response["token"] = token
       render json: response, status: 200, except: [:password_digest, :created_at, :updated_at]
    else
      response["messages"] = "Failed"
      response["code"] = 401
      render json: response, status: 401
    end
  end

  def auth_params
    params.permit(:username, :password)
  end
end
