class CategoriesController < ApplicationController
  def new
    @title = "new category"
    @edit_category = Category.new
    Language.all.map do |language|
      @edit_category.category_names.build(:language_id => language.id)
    end
  end
  
  def create
    @edit_category = Category.new params[:category]
    
    if @edit_category.save
      flash[:success] = "category created."
      redirect_to categories_path
    else
      flash[:error] = "category creation failed."
      render :action => :new
    end
  end
  
  def edit
    @edit_category = Category.find(params[:id])
    #@edit_category_names = []
    Language.all.map do |language|
      given = false
      @edit_category.category_names.each do |category_name|
        given = true if category_name.language == language
        #@edit_category_names[language.id] = category_name.name
      end
      @edit_category.category_names.build(:language_id => language.id) unless given
    end
    @edit_category.category_names.sort! { |a, b| a.language_id <=> b.language_id }
  end
  
  def update   
    @edit_category = Category.find params[:id]
    
    if @edit_category.update_attributes params[:category]
      flash[:success] = "category updated."
      redirect_to categories_path
    else
      flash[:error] = "category creation failed."
      render :action => :new
    end
  end
  
  def destroy
    @edit_category = Category.find params[:id] 
    
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
  
end
