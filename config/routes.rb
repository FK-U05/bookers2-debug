Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to:'homes#top'
  get 'home/about'=> 'homes#about',as:'home_about'
  #検索ボタンを押すとsearchesコントローラのsearchアクションを起こすルーティング#
  get 'search'=>'searches#search'
  get 'relationships/create'
  get 'relationships/destroy'

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
   resource :favorites, only: [:create, :destroy]
   resources :book_comments,only: [:create, :destroy]
  end
  #タグによって絞り込んだ投稿を表示するルーティング
  #これによってtag_books_path(tag_id: tag.id)という特定のタグに紐づけられた投稿ページへの移動が可能になる
  resources :tags do
    get 'books',to: 'books#search'
  end
  #usersにフォロー、フォロワー関係をネストさせる
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings'=>'relationships#followings',as: 'followings'
    get 'followers'=>'relationships#followers',as: 'followers'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end