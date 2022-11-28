# frozen_string_literal: true

Rails.application.routes.draw do
  constraints(id: %r{[^/]+}) do
    resources :hosts do
      member do
        get 'maskindb'
      end
    end
  end
end
