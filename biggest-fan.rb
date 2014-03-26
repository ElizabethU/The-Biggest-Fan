require 'twitter'
require 'yaml'

class Kathy

  def initialize(config_file, hobbies, fave, retweet, tweet, response_percent)
    @client    = create_twitter_client(YAML.load_file(config_file))
    @topic     = File.read(hobbies).split("\n").sample

    @odds = {}
    @odds[:fave]             = fave
    @odds[:retweet]          = retweet
    @odds[:tweet]            = tweet
    @odds[:response_percent] = response_percent
  end

  def and_go!(secondlist, last_thought, target)
    #sleep(rand(250..1300))

    @recent_tweet  = last_time(last_thought)
    @to_be_tweeted = filter_tweets(get_some_tweets)

    if wakey_wakey
      fave_retweet(target, @odds[:fave], @odds[:retweet])
      new_tweet(@odds[:tweet])
      response(target)
      secondstring(secondlist)
    end

    update_last_tweet(last_thought)
  end

  # Kathy will not tweet if it is between midnight and 8 am on her remote server
  def wakey_wakey
    Time.now.strftime('%k').to_i <= 8 || Time.now.strftime('%k').to_i >= 16
  end 

  private

  def create_twitter_client(config_hash)
    Twitter::REST::Client.new do |config|
      config.consumer_key        = config_hash['consumer_key']
      config.consumer_secret     = config_hash['consumer_secret']
      config.access_token        = config_hash['access_token']
      config.access_token_secret = config_hash['access_token_secret']
    end
  end

  # last tweet Kathy thought about, or last thing she said, if not.
  def last_time(last_thought)
    last_thoughts_file = File.read(last_thought).strip

    if last_thoughts_file.length > 0
      last_thoughts_file 
    else 
      @client.user_timeline(@client.user.screen_name).first.id
    end
  end

  # searches tweets for likely tweets
  def get_some_tweets
    tweet_array = []
    @client.search("#{@topic} -rt", {:lang => "en", :since_id => @recent_tweet, :result_type => "recent"}).each do |t|
      tweet_array << t
    end
    tweet_array
  end

  def percent_chance(x)
    rand(1..100) <= x
  end

  def bad_words
    @bad_words ||= File.read('badwords.txt').split("\n")
  end

  # Checks for undesirable words in tweets
  def contains_stop_list?(text)
    bad_words.each do |bad_word|
      return true if text.include?(bad_word)
    end
    
    false
  end

  # Filters tweets based on undesirable words, then selects one
  def filter_tweets(array)
    array.reject{ |tweet| contains_stop_list?(tweet.text) }.first
  end

  #Gets the tweets of Kathy's favorite person, since the last tweet
  def get_targets_tweets(who)
    @client.user_timeline(who, since_id: @recent_tweet, include_rts: false)
  end

  # Favorites and retweets primary target
  def fave_retweet(who, fave_chance = 8, retweet_chance = 3)
    get_targets_tweets(who).each do |t|
      if percent_chance(fave_chance) && !t.favorited
        @client.favorite!(t)
      end

      if percent_chance(retweet_chance) && !t.retweeted
        @client.retweet!(t)
      end
    end
  end

  #updates status
  def new_tweet(tweet_chance)
    if percent_chance(tweet_chance)
      @client.update("#{@to_be_tweeted.text.downcase}")
    end
  end

  def response(who)
    tweets = get_targets_tweets(who)
    if tweets.length == 0
      return
    end
    tweets.each do |tweet|
      if percent_chance(@odds[:response_percent])
        selected_response = File.read('responses.yml').split("\n").sample
        directed_response = "@#{who} " + selected_response
        @client.update(directed_response, :in_reply_to_status_id => tweet.id)
      end
    end
  end

  #other people being followed
  def secondstring(secondlist)
    other = File.read(secondlist).split("\n")

    other.each do |person|
      begin
        fave_retweet(person)
      rescue
        puts "Something went wrong, probably, you've found an account that doesn't exist"
      end
    end
  end

  #updates the last tweet
  def update_last_tweet(last_thought)
    open(last_thought, 'r+') { |f|
      f.puts "#{@to_be_tweeted.id}"
    }
  end
end