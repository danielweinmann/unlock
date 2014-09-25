Rails.application.routes.draw do

  devise_for :users

  get '/sitemap' => "initiatives#sitemap", :as => :sitemap
  
  resources :initiatives, except: [:edit] do
    resources :contributions, controller: 'initiatives/contributions', only: [:new, :create]
    collection do
      get "sitemap"
    end
  end

  root "initiatives#index"

  get "/:id" => "initiatives#show", as: :initiative_by_permalink
  # put "/:id" => "initiatives#update", as: :update_initiative_by_permalink

end
