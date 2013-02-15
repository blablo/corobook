Corobook::Application.routes.draw do
  resources :group_collaborators


  resources :groups


  resources :user_groups


  resources :songbooks do 
    member do 
      get :send_email
    end
  end


  resources :songs do
    collection do
      get :songbook_add
      get :songbook_remove
    end
  end


  authenticated :user do
    root :to => 'songs#index'
  end
  root :to => "songs#index"
  devise_for :users
  resources :users
end
