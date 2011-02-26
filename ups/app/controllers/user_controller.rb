class UserController < ApplicationController
   before_filter :load_user, :except => [ :index ]
  
  filter_access_to :update, :create, :new
  filter_access_to :edit, :attribute_check => true

  filter_access_to :all
  
  def index
    @users = User.where "id > 0"
  end

  def show
    #@user = User.find(params[:id])
  end

  def new
  end

  def create
  end

  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
      flash[:success] = "user updated"
      if has_role?(:admin)
        redirect_to user_index_path
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
