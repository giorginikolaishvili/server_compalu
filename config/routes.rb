Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope defaults: { :format => :json } do
    post 'users/list'
    get 'users/get_current_user'
    get 'users/:id/edit' => 'users#edit'
    post 'users/send_mail'
    post 'users/password_reset'
    resources :users, except: :show

    post 'auth/login', to: 'authentication#login'
    get '/*a', to: 'application#not_found'
  end
end

