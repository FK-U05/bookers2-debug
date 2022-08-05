class SearchesController < ApplicationController
  def search
    @range = params[:range]
    if @range == "User"
    @users=User.looks(params[:search],params[:word])
    elsif @range == "Book"
    @books=Book.looks(params[:search],params[:word])
    else
    @model = params[:model]
    @tags=Tag.looks(params[:search],params[:word])
    end
  end

end
