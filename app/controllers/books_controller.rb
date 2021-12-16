class BooksController < ApplicationController
  def new
    @book = book.new
  end

  def create
    @book = PostImage.new(book_params)
    @book.user_id = current_user.id
    @book.save
    redirect_to books_path
  end

  def index
    @books = Book.all

  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
    @book = PostImage.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
