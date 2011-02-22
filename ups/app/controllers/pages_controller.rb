class PagesController < ApplicationController
  def index
  end

  def show
    @page = Page.find_by_id(params[:id])
  end

  def new
  end

  def edit
  end

  def create
  end

  def destroy
  end

  def update
  end

  def home
  end

end
