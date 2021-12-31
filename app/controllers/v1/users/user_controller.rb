class V1::Users::UserController < ApplicationController
    
    before_action :authorize_request

    def getUser
        username = params[:username]
        response = Hash.new
    
        if username.blank?
            @users = User.all
            response["total_rows"] = @users.count
            response["messages"] = "Success"
            response["code"] = 200
            response["data"] = @users
            render json: response, status: 200, except: [:password_digest]
        else
            @users = User.where(username: username)
            if @users.count > 0
                response["username"] = username
                response["messages"] = "Success"
                response["code"] = 200
                response["data"] = @users.first
                render json: response, status: 200, except: [:password_digest]
            else 
                response["username"] = username
                response["messages"] = "Failed"
                response["code"] = 400
                response["data"] = nil
                render json: response, status: 400, except: [:password_digest]
            end
        end

    end

    def register
        response = Hash.new
        user = User.new(user_params)
        if user.save
            response[:messages] = "Success, data created"
            response[:code] = 201
            render json: response, status: 201
        else
            response[:messages] = "Failed"
            response[:desc] = user.errors.full_messages.first
            response[:code] = 400

            render json: response, status: 400
        end
    end

    def user_params
        params.permit(:name, :username, :phone, :password)
    end
end
