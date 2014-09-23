Rails.application.routes.draw do

  devise_for :users

  get '/sitemap' => "initiatives#sitemap", :as => :sitemap
  
  resources :initiatives, except: [:edit] do
    collection do
      get "sitemap"
    end
  end

  root "initiatives#index"

end
