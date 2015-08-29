Corobook::Application.routes.draw do

  resources :anniversaries


  resources :settings


  mount Ckeditor::Engine => '/ckeditor'

  resources :group_collaborators
  resources :groups
  resources :diapos
  resources :presentations do 
    member do 
      get :live
    end
  end

  resources :user_groups


  resources :songbooks do 
    member do 
      get :send_email
    end
  end


  resources :songs do
    member do 
      get :live
    end

    collection do
      get :vote_add
      get :songbook_add
      get :songbook_remove
    end
  end


  # authenticated :user do
  #   root :to => 'songs#index'
  # end
  root :to => "songs#index"
  devise_for :users
  resources :users
end
