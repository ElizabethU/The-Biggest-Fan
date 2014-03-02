require 'twitter'
require 'yaml'

class Kathy

  def initialize(config_file, hobbies, secondlist, last_thought, target, fave, retweet, tweet, response_percent)
    config_hash = YAML.load_file(config_file)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key    = config_hash['consumer_key']
      config.consumer_secret = config_hash['consumer_secret']
      config.access_token = config_hash['access_token']
      config.access_token_secret = config_hash['access_token_secret']
    end

    @topic = File.read(hobbies).split("\n").sample
    sleep(rand(250..1300))

    @recent_tweet = last_time(last_thought)
    @to_be_tweeted = filter_tweets(get_some_tweets)

    maybe_do_stuff(target, fave, retweet, tweet)
    response(target, response_percent)
    secondstring(secondlist)
    update_last_tweet(last_thought)

  end

  def percent_chance(x)
    rand(1..100) <= x
  end

  #Kathy will not tweet if it is between midnught and 8 am on her remote server
  def wakey_wakey
    Time.now.strftime('%k').to_i <= 8 || Time.now.strftime('%k').to_i >= 16
  end 

  #last tweet Kathy thought about, or last thing she said, if not.
  def last_time(last_thought)
    unless File.read(last_thought).strip.length == 0
      File.read(last_thought).strip 
    else 
      @client.user_timeline("katherynebutler").first.id
    end
  end

  #searches tweets for likely tweets
  def get_some_tweets
    tweet_array = []
    @client.search("#{@topic} -rt", {:lang => "en", :since_id => @recent_tweet, :result_type => "recent"}).each do |t|
      tweet_array << t
    end
    tweet_array
  end

  #returns an array of undesirable words
  def bad_words
    File.read('badwords.txt').split("\n")
  end

  #Checks for undesirable words in tweets
  def contains_stop_list?(text)
    bad_words.each do |bad_word|
      return true if text.include?(bad_word)
    end
    return false
  end

  #Filters tweets based on undesirable words, then selects one
  def filter_tweets(array)
    tweet_i_want = array.reject{ |tweet| contains_stop_list?(tweet.text)}.first
    tweet_i_want
  end

  #Gets the tweets of Kathy's favorite person, since the last tweet
  def get_targets_tweets(who)
    @client.user_timeline(who, since_id: @recent_tweet, include_rts: false)
  end

  #
  def maybe_do_stuff(who, fave, retweet, tweet)
    if wakey_wakey
      fave_retweet(who, fave, retweet)
      if percent_chance(tweet)
        @client.update("#{@to_be_tweeted.text.downcase}")
      end
    end
  end

  #Favorites and retweets primary target
  def fave_retweet(who, fave_chance, retweet_chance)
    tweets = get_targets_tweets(who)
    tweets.each do |t|
      if percent_chance(fave_chance)
        unless t.favorited
          @client.favorite!(t)
        end
      end
      if percent_chance(retweet_chance)
        unless t.retweeted
          @client.retweet!(t)
        end
      end
    end
  end

  #updates the last tweet
  def update_last_tweet(last_thought)
    open(last_thought, 'r+') { |f|
      f.puts "#{@to_be_tweeted.id}"
    }
  end

  def secondstring(secondlist)
    other = File.read(secondlist).split("\n")
    other.each do |person|
      begin
        maybe_do_stuff(person, 3, 1, 0)
      rescue
        puts "This account doesn't exist"
      end
    end
  end

  def response(who, response_percent)
    tweets = get_targets_tweets(who)
    if tweets.length >= 1
      tweets.each do |t|
        if percent_chance(response_percent)
          selected_response = File.read('responses.yml').split("\n").sample
          directed_response = "@#{who} " + selected_response
          @client.update(directed_response, :in_reply_to_status_id => t.id)
        end
      end
    end
  end
end