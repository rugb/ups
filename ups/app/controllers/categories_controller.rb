class CategoriesController < ApplicationController
  filter_access_to :all

  before_filter :load_category, :only => [:edit, :update, :destroy]

  def new
    @title = "new category"
    @edit_category = Category.new
    @edit_category.extend
  end

  def create
    @edit_category = Category.new params[:category]

    if @edit_category.save
      flash[:success] = "category created."
      redirect_to categories_path
    else
      @edit_category.extend
      flash[:error] = "category creation failed."
      render :action => :new
    end
  end

  def edit
    @title = "edit category"
    @edit_category.extend
  end

  def update
    if @edit_category.update_attributes params[:category]
      flash[:success] = "category updated."
      redirect_to categories_path
    else
      @edit_category.extend
      flash[:error] = "category creation failed."
      render :action => :new
    end
  end

  def destroy
    if @edit_category.destroy
      flash[:success] = "category deleted."
      redirect_to categories_path
    else
      flash[:error] = "category cannot be deleted until it has no reference."
      redirect_to categories_path
    end
  end

  def show
    @category = Category.find params[:id]
  end

  def index
    @edit_categories = Category.all
  end

  private
  def load_category
    @edit_category = Category.find_by_id params[:id]
  end

end
