class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def select_by_language_id(elements)
    wanted_languages.each { |language|
      elements.each { |element|
        return element if element.language_id == language.id  
      }
    }
    
    elements.first
  end
  
  def wanted_languages
    wanted_languages = []
    
    # explicit selected in url
    wanted_languages << Language.find_by_short(params[:language_short])
    
    # session/user
    
    # wanted by browser
    wanted_languages |= accepted_languages.map do |lang|
      Language.find_by_short(lang)
    end
    
    # default language
    wanted_languages << Conf.get_default_language
    
    # cleanup
    wanted_languages.delete_if{ |lang| lang.nil? }
  end
  
  ##
  # Returns the languages accepted by the visitors, sorted by quality
  # (order of preference).
  ##
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
  
end
