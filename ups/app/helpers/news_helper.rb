module NewsHelper
  def news_path(news)
    show_news_path(news, news.int_title)
  end
end
