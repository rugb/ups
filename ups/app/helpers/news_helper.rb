module NewsHelper
  def news_path(news)
    show_news_path(news, news.int_title)
  end

  def browse_news_path(cat = nil, tags = nil)
    if cat.present? && tags.present? && tags.any?
      return news_index_path :category => cat.id, :tags => ((tags.map { |tag| tag.name }).join "+")
    end
    
    return news_index_path :category => cat.id if cat.present?
    
    return news_index_path :tags => ((tags.map { |tag| tag.name }).join "+") if tags.present? && tags.any?

    news_index_path
  end
end
