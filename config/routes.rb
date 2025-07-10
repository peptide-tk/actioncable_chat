Rails.application.routes.draw do
  root 'chat_rooms#index'
  resources :chat_rooms, only: [:index, :show, :create]
  mount ActionCable.server => '/cable'
end
