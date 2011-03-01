module NewsHelper
  def news_path(news)
    show_news_path(news, news.int_title)
  end

  def browse_news_path(cat = nil, tags = nil)
  	a = ["&", "?"]
  	path = news_index_path
  	if cat.present?
  		path += a.pop
  		path += "category=" + cat.id.to_s
  	end
  	if tags.present? && tags.any?
  		path += a.pop
  		path += "tags=" + ((tags.map { |tag| tag.name }).join "+")
  	end

  	return path
  end
end
