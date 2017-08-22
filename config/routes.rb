Rails.application.routes.draw do
  constraints(:id => /[^\/]+/) do
    resources :hosts do
      member do
        get 'maskindb'
      end
    end
  end
end
