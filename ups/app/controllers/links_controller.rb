class LinksController < ApplicationController
  filter_access_to :all
  
  def new
    @link = Link.new

    Category.all.each do |cat|
      @link.link_categories.build(:category_id => cat.id)
    end
  end

  def create
    @link = Link.new(params[:link])
    
    if @link.save
      flash[:success] = "link created"
      redirect_to links_path
    else
      flash[:error] = "link not created"
      render 'new'
    end
  end

  def update
    @link = Link.find(params[:id])

    @link.update_attributes(params[:link])

    
  end

  def destroy
    @link = Link.find(params[:id])

    @link.destroy

    redirect_to links_path
  end

  def index
    @links = Link.all
  end

  def show
    @link = Link.find(params[:id])
  end

  def edit
    @link = Link.find(params[:id])
  end

end
