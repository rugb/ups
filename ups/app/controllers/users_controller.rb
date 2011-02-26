class UsersController < ApplicationController
   before_filter :load_user, :except => [ :index, :new ]
  
  filter_access_to :update, :create, :new
  filter_access_to :edit, :attribute_check => true

  filter_access_to :all
  
  def index
    @users = User.where "id > 0"
  end

  def show
  end

  def new
    @title = "new user"
    @user = User.new(:role_id => Role.find_by_int_name(:member).id)
  end

  def create
  end

  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
      flash[:success] = "user updated"
      if has_role?(:admin)
        redirect_to users_path
      else
        redirect_to user_path @user
      end
    else
      flash[:error] = "user update failed"
      render :action => :edit
    end
  end

  def edit
    @title = "edit user"
    @user = User.find(params[:id])
  end

  def destroy
  end

  private

     def load_user
       @user = User.find(params[:id])
     end

end
