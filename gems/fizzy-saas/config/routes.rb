Fizzy::Saas::Engine.routes.draw do
  resource :session do
    scope module: "sessions" do
      resource :launchpad, only: %i[ show update ], controller: "launchpad"
    end
  end

  namespace :signup do
    get "/" => "accounts#new"
    resources :accounts, only: %i[ new create ]
    get "/session" => "sessions#create" # redirect from Launchpad after mid-signup authentication
    resources :completions, only: %i[ new create ]
  end

  Queenbee.routes(self)
end
