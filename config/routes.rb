Rails.application.routes.draw do

  devise_for :users

  get '/sitemap' => "initiatives#sitemap", :as => :sitemap
  
  resources :initiatives, except: [:edit] do
    resources :contributions, controller: 'initiatives/contributions', only: [:index, :new, :create] do
      member do
        get "pay"
        put "activate"
        put "suspend"
        put "cancel"
      end
    end
    collection do
      get "sitemap"
    end
  end

  root "initiatives#index"

  get "/my_contributions" => "users#my_contributions", as: :my_contributions
  get "/my_initiatives" => "users#my_initiatives", as: :my_initiatives
  
  get "/:id" => "initiatives#show", as: :initiative_by_permalink

end
