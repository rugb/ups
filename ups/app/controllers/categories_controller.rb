class CategoriesController < ApplicationController
  def new
    @edit_category = Category.new({})
    @edit_category.category_names = Language.all.map do |language|
      CategoryName.new(:language => language)
    end
  end
  
  def create
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
  
  def show
  end
  
  def index
  end
  
end
