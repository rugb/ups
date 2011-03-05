class LinksController < ApplicationController
  filter_access_to :all

  before_filter :load_link, :only => [:update, :destroy, :show, :edit]

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
    @link.destroy

    flash[:success] = "link deleted."

    redirect_to links_path
  end

  def index
    @links = Link.all
  end

  def show
  end

  def edit
    @title = "edit link"
    @link.extend
  end

  private
  def load_link
    @link = Link.find_by_id params[:id]
  end
end
