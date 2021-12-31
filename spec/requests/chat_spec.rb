require 'rails_helper'

RSpec.describe "Chats", type: :request do
  
  def authenticated_header(user)
    token = Knock::AuthToken.new(payload: {id: user.id}).token
    {'Authorization': "Bearer #{token}"}
  end

  context 'Create new chats' do
    
    it "Expects success create new chats" do
      FactoryBot.create(:user, name: "M.Hakim Amransyah", username: "mhakim", phone: "081278172812", password: "12345")
      FactoryBot.create(:user, name: "Adebayo Akinfewa", username: "adebayo", phone: "081278172812", password: "12345")
      
      obj  = User.where(username: "mhakim").first
      obj2 = User.where(username: "adebayo").first

      param = {
        messages: "Halo pa kabz ?",
        id_users_sender: obj.id,
        id_users_receiver: obj2.id,
      }

      post "/v1/chats/", params: param ,headers: authenticated_header(obj)
      expect(response).to have_http_status(:created)
    end

    it "Expects failed create new chats, invalid senders" do
      FactoryBot.create(:user, name: "M.Hakim Amransyah", username: "mhakim", phone: "081278172812", password: "12345")
      FactoryBot.create(:user, name: "Adebayo Akinfewa", username: "adebayo", phone: "081278172812", password: "12345")
      
      obj  = User.where(username: "mhakim").first
      obj2 = User.where(username: "adebayo").first

      param = {
        messages: "Halo pa kabz ?",
        id_users_sender: 100,
        id_users_receiver: obj2.id,
      }

      post "/v1/chats/", params: param ,headers: authenticated_header(obj)
      expect(response).to have_http_status(:bad_request)
    end

    it "Expects failed create new chats, invalid specs" do
      FactoryBot.create(:user, name: "M.Hakim Amransyah", username: "mhakim", phone: "081278172812", password: "12345")
      FactoryBot.create(:user, name: "Adebayo Akinfewa", username: "adebayo", phone: "081278172812", password: "12345")
      
      obj  = User.where(username: "mhakim").first
      obj2 = User.where(username: "adebayo").first

      param = {
        id_users_sender: obj.id,
        id_users_receiver: obj2.id,
      }

      post "/v1/chats/", params: param ,headers: authenticated_header(obj)
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'Get data chat' do

    it 'Expects success get list chat' do  
      FactoryBot.create(:user, name: "M.Hakim Amransyah", username: "mhakim", phone: "081278172812", password: "12345")
      FactoryBot.create(:user, name: "Adebayo Akinfewa", username: "adebayo", phone: "081278172812", password: "12345")
      
      obj  = User.where(username: "mhakim").first
      obj2 = User.where(username: "adebayo").first
      
      FactoryBot.create(:chat, messages: "Hallo apa kabar ? ", 
        from_user: obj.id,
        to_user: obj2.id
       )

      get "/v1/chats/#{obj.id}", headers: authenticated_header(obj)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"].size).to eq(1)
    end

    it 'Expects failed get list chat, invalid id_users' do  
      FactoryBot.create(:user, name: "M.Hakim Amransyah", username: "mhakim", phone: "081278172812", password: "12345")
      FactoryBot.create(:user, name: "Adebayo Akinfewa", username: "adebayo", phone: "081278172812", password: "12345")
      
      obj  = User.where(username: "mhakim").first
      obj2 = User.where(username: "adebayo").first
      
      FactoryBot.create(:chat, messages: "Hallo apa kabar ? ", 
        from_user: obj.id,
        to_user: obj2.id
       )

      get "/v1/chats/66", headers: authenticated_header(obj)
      expect(response).to have_http_status(:not_found)
    end

    it 'Expects success get list chat detail' do 
      FactoryBot.create(:user, name: "M.Hakim Amransyah", username: "mhakim", phone: "081278172812", password: "12345")
      FactoryBot.create(:user, name: "Adebayo Akinfewa", username: "adebayo", phone: "081278172812", password: "12345")
      
      obj  = User.where(username: "mhakim").first
      obj2 = User.where(username: "adebayo").first

      FactoryBot.create(:chat, messages: "Hallo apa kabar ? ", 
        from_user: obj.id,
        to_user: obj2.id
       )

       FactoryBot.create(:chat, messages: "Baik ",
        id_group: 0, 
        from_user: obj.id,
        to_user: obj2.id
       )

       get "/v1/chats/#{obj.id}/read/0", headers: authenticated_header(obj)
       expect(response).to have_http_status(:ok)
       expect(JSON.parse(response.body)["data"].size).to eq(2)
    end

  end

  
end
