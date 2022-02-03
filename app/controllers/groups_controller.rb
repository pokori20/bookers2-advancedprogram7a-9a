class GroupsController < ApplicationController
  before_action :correct_user, only: [:edit, :update]
  def new
    @group = Group.new
  end

  def index
    @groups = Group.all
    @book = Book.new
    @user = current_user
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.users << current_user
    if @group.save
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      #owner_idカラムにグループを作成したユーザーのIDを保存
      @group.owner_id = current_user.id
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @book = Book.new
    @group = Group.find(params[:id])
  end

  def join
    # 引数が:group_idなのはroutingが /groups/:group_id/join(.:format) だから
    @group = Group.find(params[:group_id])
    # << は文字列演算子今回の場合、@group.usersという配列の末尾にcurrent_userという要素を破壊的に追加　appendでも可
    @group.users << current_user
    redirect_to groups_path
  end

  def destroy
    @group = Group.find(params[:id])
    # @group.users配列の中からcurrent_userという要素を消去
    @group.users.delete(current_user)
    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name, :image, :introduction)
  end

  def correct_user
    @group = Group.find(params[:id])
    redirect_to groups_path unless @group.owner_id == current_user.id
  end

end