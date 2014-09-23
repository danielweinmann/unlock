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

end
