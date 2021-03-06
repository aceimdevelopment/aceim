Aceim::Application.routes.draw do

  resources :archivos

  resources :material_apoyo

  resources :tipo_actividades do
    resources :actividades
  end

  resources :parte_examenes do
    resources :parte_examen_actividades
  end

  resources :parte_examen_actividades do
    resources :actividades
  end

  resources :estudiante_examenes

  resources :examenes do
    resources :parte_examenes
    resources :estudiante_examenes
  end

  resources :actividades do
    resources :preguntas
    resources :textos
    resources :adjuntos    
  end

  resources :preguntas do
    resources :opciones
    resources :respuestas
  end

  resources :opciones

  resources :respuestas

  resources :textos

  resources :adjuntos

  resources :facturas do
    resources :detalle_facturas

    collection do
      get 'nueva'
      post 'actualizar'
      get 'registrar'
      get 'actualizar_idioma_select'
    end
  end
  
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
   root :to => 'inicio#index'
   
   # match 'nuevos' => 'inscripcion#paso0' 
   
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id(.:format)))'
end
