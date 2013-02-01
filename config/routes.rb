Corobook::Application.routes.draw do
  resources :songbooks


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
