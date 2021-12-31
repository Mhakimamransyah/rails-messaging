require 'rails_helper'

RSpec.describe "Auths Request", type: :request do

  context "Invalid Authentication" do
    it "Expects invalid JWT" do
      get '/v1/users/', params: {username: "mhakim"}
      expect(response).to have_http_status(:unauthorized)
    end
    
    it "Expects invalid JWT Payload User Id" do
      token = Knock::AuthToken.new(payload: {id: 1}).token
      get '/v1/users/', params: {username: "mhakim"},headers: {'Authorization': "Bearer #{token}"}
      expect(response).to have_http_status(:unauthorized)
    end
  end
  
  describe "Users do Login" do
    
    it "Expects users not input username when login" do
      headers = { "ACCEPT" => "application/json" }
      post '/v1/login', :params => {:password => "1234"}, :headers => headers
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:unauthorized)
    end
    
    it "Expects users not input password when login" do
      headers = { "ACCEPT" => "application/json" }
      post '/v1/login', :params => {:username => "xxx"}, :headers => headers
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:unauthorized)
    end
    
    it "Expects users not input valid username and password" do
      headers = { "ACCEPT" => "application/json" }
      post '/v1/login', :params => {:username=>"xxxx" ,:password => "1234"}, :headers => headers
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:unauthorized)
    end
    
    it "Expects users input valid username and password" do
      FactoryBot.create(:user, name: "Admin", username: "admin", phone: "081278172812", password: "12345")
      headers = { "ACCEPT" => "application/json" }
      post '/v1/login', :params => {:username=>"admin" ,:password => "12345"}, :headers => headers
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end
  end

end
