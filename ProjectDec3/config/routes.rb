Sample::Application.routes.draw do
  # Route root to login page
  root :to => 'login#index'

  # Home page
  get "home/index"
  
  # Login/logout
  get "/login/index"
  get "/login/validate"
  post "/login/validate"
  get "/login/logout"
  match "/login/" => redirect("/login/index")
  match "/logout/" => redirect("/login/logout")
  get "/login/forget_password"
  post "/login/send_password_reset"
  get "/login/password_reset"
  post "/login/password_reset_update"
  
  # User details
  get "/users/change_details"
  post "/users/update_details"
  
  # Mark
  get "marks/index"
  get "marks/edit"
  post "marks/save_mark"
  get "results/index"
  
  # Booking
  get "make_booking/index"
  get "make_booking/view_experiment"
  post "make_booking/update_booking"
  get "bookings/index"

  # permission
  get "/permissions/index"
  post "/permissions/update_permission"
  
  # calendar
  get "/calendars/index"
  post "/calendars/update_calendar"
  get "/calendars/toggle_calendar"
  post "/calendars/update_experiment"
  
  # credit point
  get "/credit_points/index"
  post "/credit_points/index"
  post "/credit_points/update"
  get "/credit_points/destroy"
  
  # settings
  get "/settings/index"
  post "/settings/update_setting"
  
  #csv
  get "/csv_export/index"
  get "/csv_export/mark"
  post "/csv_export/mark"
  post "/csv_export/export_mark"
  get "/csv_export/booking"
  post "/csv_export/booking"
  post "/csv_export/export_booking"
  get "/csv_import/index"
  get "/csv_import/student_list"
  get "/csv_import/mark"
  post "/csv_import/upload_student_list"
  post "/csv_import/upload_mark"
  
  #upload/download report
  get "/upload_reports/index"
  post "/upload_reports/upload"
  get "/download_reports/index"
  get "/download_reports/detail"
  
  resources :experiments
  resources :experiment_availabilities
  resources :settings
  resources :student_semesters
  resources :students
  resources :tutors

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
