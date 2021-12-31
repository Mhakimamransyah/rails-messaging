Rails.application.routes.draw do
  get 'auth/login'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
    
    namespace :chats do
      get '/:id_user/read/:id_group'=> 'chat#detail_chats'  
      get '/:id_user'=> 'chat#list_chats'
      post ''=> 'chat#new_chats'
    end

    namespace :users do
      get '' => 'user#getUser'
      get '/:username' => 'user#getUser'
      post '' => 'user#register'
    end

    post '/login' => 'auth#login'

  end

end
