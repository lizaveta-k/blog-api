# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :v1 do
    resources :posts, only: %i[index create] do
      resource :rating, only: %i[create]
    end

    resources :ips, only: %i[index]
  end
end
