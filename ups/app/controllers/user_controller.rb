class UserController < ApplicationController
  
  def index
    @users = User.where "id > 0"
  end

  def show
  end

  def new
  end

  def create
  end

  def update
  end

  def edit
  end

  def destroy
  end

end
