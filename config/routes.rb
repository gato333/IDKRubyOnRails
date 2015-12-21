Rails.application.routes.draw do
  resources :event_results

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


  get '/event' => 'event_results#index'

  get '/event/:id' => 'event_results#show'

  get '/event/:id/edit' => 'event_results#edit'

  get '/event/new' => 'event_results#new'

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable
end
