Rails.application.routes.draw do
  get 'sessions/new'

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

  get '/access_denied' => 'application#access_denied'

  get '/unknown' => 'application#unknown'



  get '/admin/index' => 'event_results#index'

  get '/admin/all'  => 'event_results#all'

  get '/admin/count' => 'event_results#count'

  get '/event/new' => 'event_results#new'

  get '/event/:id' => 'event_results#show'

  get '/event/:id/edit' => 'event_results#edit'



  get '/admin/user_index' => 'users#index'

  get '/signup' => 'users#new'
  get '/user/new' => 'users#new'

  get '/user/:id' => 'users#show'

  get '/user_events/:id' => 'users#events'

  get '/user/:id/edit' => 'users#edit'

  get '/user_photo/:id' => 'users#edit_photo'

  get '/password_reset/:id' => 'users#new_password'

  post '/password_reset/:id' => 'users#change_password'


  get    '/login'   => 'sessions#new'

  post   '/login'   => 'sessions#create'

  delete '/logout'  => 'sessions#destroy'

  #catch all
  get '*path' => 'application#unknown'

end
