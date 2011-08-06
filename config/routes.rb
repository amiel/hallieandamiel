Hallieandamiel::Application.routes.draw do
  resources :tags
  
  resources :photos do |pho| #sho
    resources :tags
    collection do
      get :unapproved
    end
  end
  
  match "/categories", :to => 'tags#index' # Because tags is a scary word.
  
  root :to => 'details#index'
end
