Rails.application.routes.draw do
  get 'users/new'

  resources :event_results, :users

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#home'

  # Example of regular route:
  get '/results' => 'application#results'
  
  post '/results' => 'application#results'

  get '/whatdo' => 'application#do'
  
  get '/whateat' => 'application#eat'

  get '/random' => 'application#random'

  get '/home' => 'application#home'

  get '/error' => 'application#error'

  get '/count' => 'application#count'

  get '/all'  => 'application#all'



  get '/index' => 'event_results#index'

  get '/event' => 'event_results#index'

  get '/event/new' => 'event_results#new'

  get '/event/:id' => 'event_results#show'

  get '/event/:id/edit' => 'event_results#edit'



  get '/user_index' => 'users#index'

  get '/user' => 'users#index'

  get '/signup' => 'users#new'
  get '/user/new' => 'users#new'

  get '/user/:id' => 'users#show'

  get '/user/:id/edit' => 'users#edit'

end
