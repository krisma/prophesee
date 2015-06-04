Rails.application.routes.draw do
  
  post 'stocks/watch'
  get 'draw_month' => 'stocks#draw_month'
  get 'draw_days' => 'stocks#draw_days'
  get 'draw_months' => 'stocks#draw_months'
  get 'draw_year' => 'stocks#draw_year'
  get 'draw_all' => 'stocks#draw_all'
  get 'static/index'
  get 'stocks/up'
  get 'stocks/down'
  get 'stocks/neutral'
  root:to => "static#index"
  get 'market' => 'static#market'
  get 'community' => 'static#community'
  get 'dashboard' => 'static#dashboard'
  get 'show_sign' => 'static#show_sign'
  post 'search' => 'stocks#search'
  get 'switch_sign_in' => 'static#switch_sign_in'
  get 'switch_sign_up' => 'static#switch_sign_up'
  resources :posts
  resources :stocks
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
