Rails.application.routes.draw do
  resources :passwords, param: :token

  # トップページ
  root "homes#top"
  get "homes/about"

  # ユーザー登録・ログイン
  namespace :public do

    resources :users, only: [:new, :create, :index, :show, :edit, :update, :destroy]

    resource :session, only: [:new, :create, :destroy]

    get "mypage", to: "users#mypage"

    # 投稿
    resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
      resources :comments, only: [:create, :update, :destroy]
    end

    # グループ
    resources :groups, only: [:index, :show] do
      resource :membership, only: [:create, :destroy]
    end

    # 検索
    get "search", to: "searches#index"

  end


  # 投稿
  resources :posts do
    resources :comments, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
  end

#
#  # コミュニティ
#  resources :communities do
#    resources :community_users, only: [:create, :destroy]
#  end
#
#  # フォロー
#  resources :relationships, only: [:create, :destroy]
#
    # 管理者
    namespace :admin do
      root "dashboards#index"
      
      resource :session, only: [:new, :create, :destroy]
      
      resources :admins
      resources :comments, only: [:index, :destroy]
      resources :groups
    end
end