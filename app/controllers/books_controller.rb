class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @user=@book.user
    @bookd=Book.new
    @book_comment=BookComment.new
    @book_tags = @book.tags
  end

  def index
    #ビューからの指示を受ける,paramsの中にあるのはviewでも記述したやつ#
    if params[:new]
    #ここのlatestはモデルに記述したスコープ名#
    @books = Book.latest
    elsif params[:star]
    @books = Book.star_count
    else
    #並び順に指定がない時は普通に表示するようにする#
    @books = Book.all
    end
    @book=Book.new
    @tag_list = Tag.all
    @book_tags = @book.tags
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    tag_list=params[:book][:tag_name].split(nil)
    @bookd=Book.new
    if @book.save
      @book.save_tags(tag_list)
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render "index"
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user_id != current_user.id
    redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def search
  #全てのタグを表示する
  @tag_list = Tag.all
  #クリックしたタグを取得する
  @tag = Tag.find(params[:tag_id])
  #クリックしたタグに紐づけられた投稿を全て表示
  @books = @tag.books.all
  end

  private

  def book_params
    params.require(:book).permit(:title,:body,:star)
  end

end
