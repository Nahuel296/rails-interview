Rails.application.routes.draw do
  namespace :api do
    resources :todo_lists, only: %i[index show create update destroy], path: :todolists do
      resources :todo_list_item, only: %i[index create update destroy], path: :todos
    end
  end

  resources :todo_lists, only: %i[index new], path: :todolists
end
