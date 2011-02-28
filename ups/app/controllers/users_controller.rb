class UsersController < ApplicationController
   before_filter :load_user, :except => [ :index, :new, :create ]
  
  filter_access_to :update, :create, :new
  filter_access_to :edit, :attribute_check => true

  filter_access_to :all
  
  def index
    @users = User.where "id > 0"
  end

  def show
    http_404 if @user.nil?
  end

  def new
    @title = "new user"
    @user = User.new(:role_id => Role.find_by_int_name(:member).id)
  end

  def create
    @user = User.new params[:user]

    if @user.save
      flash[:success] = "user created"
      redirect_to users_path
    else
      flash.now[:error] = "user not created"
      render 'new'
    end
  end

  def update
    @user = User.find params[:id]
    
    if has_role? :admin
      @user.role_id = params[:user][:role_id]
    end
    
    if @user.update_attributes(params[:user])
      set_session_language @user.language.short if @user.language.present?
      
      flash[:success] = "user updated"
      if has_role? :admin 
        redirect_to users_path
      else
        redirect_to user_path @user
      end
    else
      flash.now[:error] = "user update failed"
      render :action => :edit
    end
  end

  def edit
    @title = "edit user"
    @user = User.find params[:id]
  end

  def destroy
    @user.destroy

    redirect_to users_path
  end

  private

     def load_user
       @user = User.find params[:id] if params[:id].present?

       @user = nil if @user.id == 0
     end
end
