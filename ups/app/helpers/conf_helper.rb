module ConfHelper

  include GoogleHelper

  def twitter_update(tweet)
    twitter_auth
    begin
      ::Twitter.update(tweet)[0..139] if tweet.present?
      return true
    rescue
      return false
    end
  end

  def twitter_check
    twitter_auth
    begin
      tweet = ::Twitter.update("works")
      ::Twitter.status_destroy tweet.id
      return true
    rescue
      return false
    end
  end

  def twitter_auth
    ::Twitter.configure do |config|
      config.consumer_key = Conf.twitter_consumer_key
      config.consumer_secret = Conf.twitter_consumer_secret
      config.oauth_token = Conf.twitter_oauth_token
      config.oauth_token_secret = Conf.twitter_oauth_secret
    end
  end

  def google_check
    return google_auth.nil? ? false : true
  end
end
