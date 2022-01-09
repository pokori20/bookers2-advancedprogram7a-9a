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
    
    # Time.current.at現在の時刻を取得つまり to = 今日の終わり
    to = Time.current.at_end_of_day
    # 6日前のはじめ
    from  = (to - 6.day).at_beginning_of_day
    # sizeでもcountでも表示は問題ないが、反応スピードの関係でsizeを使用
    # ...は範囲演算子例　1..5 は1～5 1...5は終端を含まないので1～4の意味
    # Book.allと書かない理由はincludes(引数)と記述した方が余分なsqlを発行しなくなるため軽くなる
    # Arrayオブジェクト.sort {|a, b| ... } Arrayは配列の意味　配列の中身をa bを用いてどのように比較するか可能
        @books = Book.includes(:favorited_users).
          sort {|a,b| 
          # a <=> b基本的な比較演算子　 a < b であれば -1、a == b であれば 0、a > b であれば 1、比較できない時は nil を返えす。
          # bを先に記述して降順にしている。
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
