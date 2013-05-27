Metallr::Application.routes.draw do
  
  # posts
  match "/replies" => "posts#replies"
  match "/posts/my" => "posts#my"
  match "/posts/idols" => "posts#idols"
  match "/posts/groupies" => "posts#groupies"
  resources :posts


  # users
  match "idols" => "users#idols"
  match "groupies" => "users#groupies"

  devise_for :users
  devise_scope :user do
    get '/login' => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
  end

  
  match "users/:id/idols" => "users#idols", :as => "user_idols"
  match "users/:id/idols/posts" => "posts#idols", :as => "user_idols_posts"

  match "users/:id/groupies" => "users#groupies", :as => "user_groupies"
  match "users/:id/groupies/posts" => "posts#groupies", :as => "user_groupies_posts"
  resources :users do
    member do
      get 'idolize'
      get 'unidolize'
      match "idols/posts" => "posts#idols"
      match "groupies/posts" => "posts#groupies"
    end
  end
  resources :users, :only => [:edit, :index, :show, :update, :destroy, :idolize, :unidolize]

  # search
  match "/search/results" => "search#results"

  # root 
  get "home/index"

  authenticated :user do
    root :to => "posts#idols"
  end

  root :to => "posts#index"

  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
