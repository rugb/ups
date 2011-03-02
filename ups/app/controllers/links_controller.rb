class LinksController < ApplicationController
  filter_access_to :all
  
  def new
    @title = "create new link"
    @link = Link.new
    @link.extend
  end

  def create
    @title = "create new links"
    @link = Link.new(params[:link])
    
    if @link.save
      flash[:success] = "link created"
      redirect_to links_path
    else
      @link.extend
      flash.now[:error] = "link not created"
      render 'new'
    end
  end

  def update
    @link = Link.find(params[:id])

    if @link.update_attributes(params[:link])
      flash[:success] = "link updated."
      redirect_to links_path
    else
      @link.extend
      flash.now[:error] = "link update failed."
      render :action => :edit
    end
  end

  def destroy
    @link = Link.find(params[:id])

    @link.destroy

    flash[:success] = "link deleted."

    redirect_to links_path
  end

  def index
    @links = Link.all
  end

  def show
    @link = Link.find(params[:id])
  end

  def edit
    @title = "edit link"
    @link = Link.find(params[:id])
    @link.extend
  end
end
