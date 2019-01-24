Rails.application.routes.draw do
  root 'event#index'
  get 'delete', to: 'event#delete'
  post 'pushhere', to: 'event#save'
  get 'load', to: 'event#load'
end
