class ConfController < ApplicationController
  def index
  end
  
  def update
    Conf.default_language = Language.find_by_any(params[:default_language])
    Conf.default_page = Page.find(params[:default_page])
    Conf.web_name = params[:web_name]
    flash[:success] = "settings saved."
    render :action => :index
  end
  
end
