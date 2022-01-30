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

  private

  def group_params
    params.require(:group).permit(:name, :image, :introduction)
  end

  def correct_user
    @group = Group.find(params[:id])
    redirect_to groups_path unless @group.owner_id == current_user.id
  end

end