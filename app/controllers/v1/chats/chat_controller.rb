class V1::Chats::ChatController < ApplicationController

    before_action :find_user, except: %i[new_chats]
    before_action :authorize_request
    
    def list_chats
        response = Hash.new
        id_users = params[:id_user]
        group = Chat.where(from_user: id_users).or(Chat.where(to_user: id_users)).order("created_at DESC").select(:id_group)
       
        # puts "grup #{group}"
        unique = group.uniq{|x| x.id_group}

        list_chats = []
        unique.each_with_index do |item,key|
            
            chat_preview = {}
            chats = Chat.where(id_group: item.id_group).order("created_at DESC").first
        
            # @chat_preview["chats"] = @chats
            chat_preview["id_group"] = chats.id_group
            chat_preview["messages"] = chats.messages
            chat_preview["unread"] = Chat.where(id_group: item.id_group,is_read: 0, to_user: id_users.to_i).count
            chat_preview["created_at"] = chats.created_at


            if id_users.to_i == chats.from_user.to_i
                # @chat_preview["profile_id"] = @chats.from_user 
                user_in_chat = User.find_by_id(chats.to_user)
                chat_preview["name"] = user_in_chat.name
                chat_preview["user_id"] = user_in_chat.id   
            else
                # @chat_preview["profile_id"] = @chats.to_user 
                user_in_chat = User.find_by_id(chats.from_user)
                chat_preview["name"] = user_in_chat.name
                chat_preview["user_id"] = user_in_chat.id  
            end
            list_chats.push(chat_preview)
        end 

        response["messages"] = "Success"
        response["code"] = 200
        response["data"] = list_chats
        render json: response, status: 200
    end

    def detail_chats
        response = Hash.new
        id_users = params[:id_user]
        id_group = params[:id_group]
        # set all chat read

        Chat.where(id_group: id_group.to_i, to_user: id_users.to_i).update_all(is_read: 1)
    
        chats = Chat.where("id_group = ? AND (to_user = ? OR from_user = ?)",id_group,id_users,id_users).order("created_at ASC")

        list_chats = []
        chats.each_with_index do |item,key|
            chat_preview = {}
            chat_preview["id"] = item.id
            if !item.replies_id.blank?
                replies_chat = Chat.find_by_id(item.replies_id.to_i)
                chat_preview["replies"] = {
                    "id" => replies_chat.id,
                    "messages" => replies_chat.messages,
                    "type" => (replies_chat.from_user == id_users.to_i)? "send" : "receive",
                    "is_read" => replies_chat.is_read,
                    "sent_at" => replies_chat.created_at
                }
            end
            chat_preview["message"] = item.messages
            chat_preview["sent_at"] = item.created_at
            chat_preview["type"]    = (item.from_user == id_users.to_i)? "send" : "receive"
            chat_preview["is_read"] = item.is_read
            list_chats.push(chat_preview)
        end

        response["messages"] = "Success"
        response["code"] = 200
        response["data"] = list_chats
        render json: response, status: 200
    end

    def new_chats
        response = Hash.new
        
        id_group = params[:id_group]
        id_sender= params[:id_users_sender]
        id_receiver = params[:id_users_receiver]
        messages = params[:messages]
        id_chat = params[:id_chats_replies]

        chats = Chat.new(messages: messages,id_group: id_group,from_user: id_sender, 
            to_user: id_receiver, replies_id: id_chat)
        sender = User.find_by_id(id_sender)
        receiver = User.find_by_id(id_receiver)

        if sender.present? && receiver.present?

            if id_group.blank?
                chats.id_group = Chat.maximum("id_group").to_i + 1        
            end

            if chats.save
                response["messages"] = "Success, data created"
                response["code"] = 201
                render json: response, status: 201
            else
                response["messages"] = "Failed, Invalid Request"
                response["code"] = 400
                render json: response, status: 400
            end
        else
            response["messages"] = "Failed, Unknown users Id"
            response["code"] = 400
            response["id"] = id_sender
            render json: response, status: 400
        end
    end

    def find_user
       response = Hash.new
       @user = User.find_by_id(params[:id_user])
       if @user.blank?
            response["messages"] = "Failed, User not found"
            response["code"] = 404
            response["id"] = params[:id_user]
            render json: response, status: :not_found
       end 
    end 

end
