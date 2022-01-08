class BooksController < ApplicationController
  before_action :correct_user, only: [:edit, :update]


  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice]="You have created book successfully."
      redirect_to book_path(@book.id)
    else
     @books = Book.all
     render :index
    end
  end

  def index
    
    @book = Book.new
    @user = current_user
    
    to = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
        @books = Book.includes(:favorited_users).
          sort {|a,b| 
        b.favorited_users.includes(:favorites).where(created_at: from...to).size <=> 
        a.favorited_users.includes(:favorites).where(created_at: from...to).size
      }
    @book = Book.new
    # @all_ranks = Book.find(Favorite.group(:book_id).order('count(book_id) desc').pluck(:book_id))
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_new  = Book.new
    @book_comment= BookComment.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
  # noticeとalertがキーの場合下記のように省略できます。
      redirect_to book_path(@book.id), notice:"You have updated book successfully."
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    redirect_to(books_path) unless @user == current_user
  end
end
