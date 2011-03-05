class PagesController < ApplicationController
  before_filter :load_page
  before_filter :load_comment, :only => [ :edit_comment,        :update_comment, :destroy_comment ]

  filter_access_to :edit_comment, :update_comment, :destroy_comment, :model => Comment, :load_method => :load_comment, :attribute_check => true
  filter_access_to :all

  include PagesHelper
  include ConfHelper

  helper_method :path_type, :index_path, :edit_path, :show_path

  def preview
    @html = preview_html(PageContent.new(:language => Language.find_by_short(params[:short]), :text => params[:text].encode("UTF-8", "ISO-8859-1")))
    @field = "#preview_" + params[:short]
  end

  def my_logger
    @@log_file = File.open("#{RAILS_ROOT}/log/my.log", File::WRONLY | File::APPEND)
    @@my_logger ||= Logger.new(@@log_file)
  end

  def path_type
    return :page if /^\/pages/ =~ request.fullpath
    return :news if /^\/news/ =~ request.fullpath
    return :news if /^\/blog/ =~ request.fullpath
  end

  def index_path
    return "/news" if path_type == :news
    return "/pages" if path_type == :page
  end

  def edit_path(page)

  end

  def show_path(page)
    return "/blog/#{page.id}" if path_type == :news
    return "/page/#{page.id}/#{page.int_title}" if path_type == :page
  end

  def index
    if path_type == :page
      @pages = editable_children_pages nil
    elsif path_type == :news
      if params[:category].present?
        @browse_category = Category.find_by_id params[:category]
      end

      if params[:tags].present?
        @browse_tags_names = params[:tags].split "+"
        @browse_tags = @browse_tags_names.map do |tag_name|
          Tag.find_by_name tag_name
        end.compact
      end

      @pages = Page.news.select do |page|
        (@browse_category.nil? || page.categories.index(@browse_category)) && (page.tags & @browse_tags).size == @browse_tags.size
      end

      render 'index_news' and return
    end
  end

  def show
     if path_type == :news
       render 'show_news'
       return
     end

#    if !has_role_with_hierarchy?(@page.role.int_name)
#      permission_denied
#    else
      http_404 and return if(@page.nil? || !@page.visible?)

      redirect_to show_page_path(@page.id, @page.int_title) and return if (params[:int_title] != @page.int_title)
      set_session_language params[:language_short] if params[:language_short].present?

      redirect_to @page.forced_url if @page.forced_url.present?
#    end
  end

  def new
    @title = "create new #{path_type_name}"
    @edit_page = Page.new(:page_type => path_type, :enabled => false, :role => Role.find_by_int_name(:guest))
    @edit_page.extend
    @edit_page.user = @current_user
  end

  def create
    @title = "create new #{path_type_name}"
    @edit_page = Page.new_by_params_and_page_type_and_user params[:page], path_type, @current_user

    if path_type == :page
      @edit_page.position_select = params[:position_select]
      update_edit_role
    end

    if @edit_page.valid? && @edit_page.page_contents.any? &&  @edit_page.save
      cache_html!(@edit_page)

      flash[:success] = "#{path_type_name} created."

      if path_type == :news
        @edit_page.enabled = true
        @edit_page.save

        redirect_to edit_news_path @edit_page
      else
        redirect_to edit_page_path @edit_page
      end

    else
      @edit_page.extend
      flash.now[:error] = "#{path_type_name} creation failed."

      if path_type == :news
        render 'new_news'
      else
        render 'new'
      end
    end
  end

  def edit
    @title = "edit #{path_type_name}"
    @edit_page = Page.find params[:id]
    @edit_page.extend
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    Tag.all.each do |tag|
      tag.destroy if tag.pages.empty?
    end

    flash[:success] = "#{path_type_name} deleted."

    redirect_to index_path
  end

  def update
    @title = "edit #{path_type_name}"
    @edit_page = Page.find params[:id]

    if path_type == :page
      @edit_page.position_select = params[:position_select]

      update_edit_role

      recalc_page_positions_for_page @edit_page
    end

    if @edit_page.update_attributes params[:page].merge(:user => @current_user)
      cache_html! @edit_page
      flash.now[:success] = "#{path_type_name} updated."
    else
      flash.now[:error] = "#{path_type_name} update failed."
    end

    @edit_page.extend

    if path_type == :news
      render 'edit_news'
    else
      render 'edit'
    end
  end

  def activate
    @edit_page = Page.find params[:id]
    @edit_page.enabled = true
    if @edit_page.save
      flash[:success] = "activated."
    else
      flash[:error] = "this page cannot be activated."
    end

    redirect_to pages_path
  end

  def deactivate
    @edit_page = Page.find params[:id]
    @edit_page.enabled = false
    @edit_page.save
    if @edit_page.save
      flash[:success]= "deactivated."
      redirect_to pages_path
    else
      flash[:error] = "this page cannot be deactivated."
      redirect_to pages_path
    end
  end

  def create_comment
    @page = Page.find params[:id]
    @comment = Comment.new(params[:comment].merge(:page => @page, :user => @current_user))

    if @comment.save
      flash[:success] = "comment created"
    else
      flash[:error] = "comment not created"
    end
    if @page.page_type == :page
      redirect_to make_page_path @page
    else
      redirect_to show_news_path @page
    end
  end

  def edit_comment
  end

  def update_comment
    @comment = Comment.find params[:comment_id]

    if @comment.update_attributes(params[:comment].merge(:page => @page, :user => @current_user))
      flash[:success] = "comment updated"

      if @page.page_type == :page
        redirect_to make_page_path @page
      else
        redirect_to show_news_path @page
      end
    else
      flash.now[:error] = "error on updating a comment"
      render :edit_comment
    end
  end

  def destroy_comment
    @comment.destroy

    flash[:success] = "comment deleted"

    if @page.page_type == :page
      redirect_to make_page_path @page
    else
      redirect_to show_news_path @page
    end
  end

  def home
    default_page = Conf.default_page
    if default_page.nil?
      redirect_to setup_path
    else
      redirect_to make_page_path(default_page), :flash => flash
    end
  end

  def credits
  end

  def setup
  end

  def rss
    @news = Page.news.limit(10)
    render :layout => false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end

  private
  def update_edit_role
    if @edit_page.edit_role.present?
      @edit_page.edit_role_id = @current_user.role.id

      if has_role_with_hierarchy?(:admin) && params[:page][:edit_role_id].present?
        @edit_page.edit_role_id = params[:page][:edit_role_id]
      end
    end
  end

  def path_type_name
    path_type == :news ? "post" : "page"
  end

  def load_page
    @page = Page.find_by_id(params[:id]) if params[:id].present?

    @browse_tags = []
  end

  def load_comment
    @comment = Comment.find params[:comment_id]
  end

  def recalc_page_positions_for_page(page)
    if page.parent.present?
      pages = Page.find_all_by_parent_id(page.parent_id)
    else
      pages = Page.find_all_by_parent_id(nil)
    end

    pages.each_with_index do |page, i|
     (page.position = (i+1) * 10) and page.save if page.position.present?
    end
  end
end