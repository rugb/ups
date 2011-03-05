require 'kramdown'

class ApplicationController < ActionController::Base
  include SessionHelper

  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, :with => :http_404

  helper_method :select_by_language_id, :current_user, :cache_html!

  before_filter :current_user
  before_filter :current_page

  helper_method :select_by_language_id

  def http_404
    @title = "404 - page not found"
    render 'errors/404', :status => 404
  end

  def http_500
    @title = "500 - internal server error"
    render 'errors/500', :status => 500
  end

  def cache_html!(page)
    page.file_uploads.each do |file_upload|
      file_upload.update_attribute :visible, true
    end
    page.page_contents.map do |page_content|
      update_html(page_content)
    end

    page.save
  end

  def preview_html(page_content)
    update_html(page_content).html
  end

  def select_by_language_id(elements)
    select_by_languages(elements, wanted_languages)
  end

  def select_by_languages(elements, languages)
    languages.each { |language|
      elements.each { |element|
        return element if element.language_id == language.id
      }
    }

    elements.first
  end

  # returns a prioritised array of Languages wich should be used to render the page content
  def wanted_languages
    wanted_languages = []

    # explicit selected in url
    wanted_languages << Language.find_by_short(params[:language_short])

    # session/user
    #wanted_languages << Language.find_by_short(cookies.signed[:user_language]) if cookies.signed[:user_language].present?
    wanted_languages << Language.find_by_short(get_session_language) if get_session_language.present?

    # wanted by browser
    wanted_languages |= accepted_languages.map do |lang|
      Language.find_by_short(lang)
    end

    # default language
    wanted_languages << Conf.default_language

    # cleanup
    wanted_languages.compact
  end

  # by http://mashing-it-up.blogspot.com/2008/10/parsing-accept-language-in-rails.html
  # Returns the languages accepted by the visitors, sorted by quality
  # (order of preference).
  def accepted_languages
    # no language accepted
    return [] if request.env["HTTP_ACCEPT_LANGUAGE"].nil?

    # parse Accept-Language
    accepted = request.env["HTTP_ACCEPT_LANGUAGE"].split(",")
    accepted = accepted.map { |l| l.strip.split(";") }
    accepted = accepted.map { |l|
      if (l.size == 2)
        # quality present
        [ l[0].split("-")[0].downcase, l[1].sub(/^q=/, "").to_f ]
      else
        # no quality specified =&gt; quality == 1
        [ l[0].split("-")[0].downcase, 1.0 ]
      end
    }

    # sort by quality
    accepted.sort { |l1, l2| l2[1] - l1[1] }

    # reduce to short
    accepted.map do |a|
      a[0]
    end
  end

  protected

  # neccessary for declarative_authorization model permissions
  def set_current_user
    # current_user should be defined somewhere as the logged in used
    Authorization.current_user = @current_user
  end

  def current_page
    page = Page.find(:first, :conditions => {:forced_url => request.path})
    @page = page if page.present? && page.visible?
  end

  private

  def update_html(page_content)
    if page_content.text.present?
      kramdown = page_content.text
      kramdown = kramdown_internal_files page_content.page, kramdown, page_content.language
      kramdown = kramdown_internal_img page_content.page, kramdown, page_content.language
      kramdown = kramdown_internal_links kramdown, page_content.language
      page_content.html = Kramdown::Document.new(kramdown).to_html
    end
    return page_content
  end

  LINK_REGEX = /(^|[^!])\[\[([^\[\]]+)\]\]/
  FILE_REGEX = /(\[\[\[)([^\[\]]+)\]\]\]/
  IMG_REGEX = /(!\[\[)([^\[\]]+)\]\]/

  # idea by dmke
  def kramdown_internal_files(page, text, language)
    text.gsub FILE_REGEX do |match|
      file_id, title = $2.split '|', 2
      if file_id.to_i > 0
        file = FileUpload.find_by_id file_id
      else
        file = FileUpload.find_by_filename file_id
      end

      css_class = "intfile"
      if file.present?
        file.update_attribute :visible, false
        title = file.filename if title.nil?
        link = download_file_path file
      else
        title = file_id if title.nil?
        link = ""
        css_class += " unknown"
      end

      "[#{title}](#{link}){: class=\"#{css_class}\"}"
    end
  end

  def kramdown_internal_img(page, text, language)
    text.gsub IMG_REGEX do |match|
      file_id, title = $2.split '|', 2
      if file_id.to_i > 0
        file = FileUpload.find_by_id file_id
      else
        file = FileUpload.find_by_filename file_id
      end

      css_class = "intimg"
      if file.present?
        file.update_attribute :visible, false
        title = file.filename if title.nil?
        link = download_file_path file
      else
        title = file_id if title.nil?
        link = ""
        css_class += " unknown"
      end

      "![#{title}](#{link}){: class=\"#{css_class}\"}"
    end
  end

  def kramdown_internal_links(text, language)
    text.gsub LINK_REGEX do |match|
      page_id, title = $2.split '|', 2
      if page_id.to_i > 0
        page = Page.find_by_id page_id
      else
        page = Page.find_by_int_title page_id
      end
      css_class = "intlink"
      if page.present?
        title = select_by_languages(page.page_contents, [language, Conf.default_language]).title if title.nil?
        link = make_page_path page
      else
        title = page_id if title.nil?
        link = ""
        css_class += " unknown"
      end

      "[#{title}](#{link}){: class=\"#{css_class}\"}"
    end
  end
end
