class ConfController < ApplicationController
  def index
  end
  
  def update
    Conf.set_default_language(Language.find_by_any(params[:default_language]))
    Conf.set_default_page(Page.find(params[:default_page]))
    Conf.set_web_name(params[:web_name])
    flash[:success] = "settings saved."
    render :action => :index
  end
  
end
