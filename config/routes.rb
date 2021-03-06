Hallieandamiel::Application.routes.draw do
  resources :tags
  
  resources :photos do |pho| #sho
    resources :tags
    collection do
      get :unapproved
    end
  end
  
  match "/categories", :to => 'tags#index' # Because tags is a scary word.
  match "/albums", to: 'tags#index', as: 'albums' # Because tags is a scary word.
  
  match "/thanks", to: 'photos#thanks', as: 'thank_you' # Because shut up REST is why
  
  root :to => 'details#index'
end
