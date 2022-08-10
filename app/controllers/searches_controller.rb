class SearchesController < ApplicationController
  def search
    #検索モデルbookかuserかをrangeで送られてくる#
    #または検索がタグの場合はmodelで送られてくる？#
    @range = params[:range]
    @model = params[:model]
    if @range == "User"
    #searchは検索手法、検索ワードはwordとして送られてくる#
    #検索内容をlooksメソッドで取得、@usersや@booksに代入する#
    @users=User.looks(params[:search],params[:word])
    elsif @range == "Book"
    @books=Book.looks(params[:search],params[:word])
    #検索したのがタグのとき#
    #タグのモデルが送られてきたら?#
    elsif @model == "tag"
    @tags=Tag.looks(params[:method],params[:word])
    @books=Book.looks(params[:search],params[:word])
    end
  end

end
