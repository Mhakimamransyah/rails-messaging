require 'rails_helper'

RSpec.describe "Users Request", type: :request do

  def authenticated_header(user)
    token = Knock::AuthToken.new(payload: {id: user.id}).token
    {'Authorization': "Bearer #{token}"}
  end


  describe 'Get data users' do
    it 'Expects success get data users' do
      FactoryBot.create(:user, name: "M.Hakim Amransyah", username: "mhakim", phone: "081278172812", password: "12345")
      FactoryBot.create(:user, name: "Jack komboy", username: "jack", phone: "081278172822", password: "12345")
      obj = User.where(username: "mhakim").first
      
      get '/v1/users',headers: authenticated_header(obj)
      
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["data"].size).to eq(2)
      # puts response.body
    end

    it 'Expects success get data user by username' do
      FactoryBot.create(:user, name: "M.Hakim Amransyah", username: "mhakim", phone: "081278172812", password: "12345")
      obj = User.where(username: "mhakim").first

      get '/v1/users/', params: {username: "mhakim"} ,headers: authenticated_header(obj)
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["data"]["name"]).to eq("M.Hakim Amransyah")
      expect(JSON.parse(response.body)["data"]["username"]).to eq("mhakim")
      expect(JSON.parse(response.body)["data"]["phone"]).to eq("081278172812")
    end

    it 'Expects failed get data user by invalid username' do
      FactoryBot.create(:user, name: "M.Hakim Amransyah", username: "mhakim", phone: "081278172812", password: "12345")
      obj = User.where(username: "mhakim").first

      get '/v1/users/', params: {username: 12} ,headers: authenticated_header(obj)
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'Create data user' do
    it 'Expects success create new users' do 
      FactoryBot.create(:user, name: "M.Hakim Amransyah", username: "mhakim", phone: "081278172812", password: "12345")
      obj = User.where(username: "mhakim").first
      param = {
        name: "Emanuel Adebayor",
        username: "adebayor",
        phone: "0812378273823",
        password: "12345",
      }
      post '/v1/users/', params: param ,headers: authenticated_header(obj)
      expect(response).to have_http_status(:created)
    end
    it 'Expects failed create new users, invalid specs' do 
      FactoryBot.create(:user, name: "M.Hakim Amransyah", username: "mhakim", phone: "081278172812", password: "12345")
      obj = User.where(username: "mhakim").first
      param = {
        phone: "0812378273823",
        password: "12345",
      }
      post '/v1/users/', params: param ,headers: authenticated_header(obj)
      expect(response).to have_http_status(:bad_request)
    end
  end



end
