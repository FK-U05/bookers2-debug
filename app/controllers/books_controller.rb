class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @user=@book.user
    @bookd=Book.new
    @book_comment=BookComment.new
    @book_tags = @book.tags
  end

  def index
    if params[:new]
    @books = Book.latest
    elsif params[:star]
    @books = Book.star_count
    else
    @books = Book.all
    end
    @book=Book.new
    @tag_list = Tag.all
  end

  def create
    @book = Book.new(book_params)
    tag_list=params[:book][:tag_name].split(',')
    @book.user_id = current_user.id
    @bookd=Book.new
    if @book.save
      @book.save_tag(tag_list)
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
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @books=@tag.books.all
  end

  private

  def book_params
    params.require(:book).permit(:title,:body,:star,:tag_name)
  end

end
