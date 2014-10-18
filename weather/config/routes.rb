Rails.application.routes.draw do
  get 'weather', to: 'welcome#weather', format: :json

  root 'welcome#index'
end
