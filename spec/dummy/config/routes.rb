Dummy::Application.routes.draw do
  namespace :contests do
    resources :questionnaires
  end


  root :to => "welcome#index"
  resources :users
end
