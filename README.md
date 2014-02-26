Biggest Fan Bot
===============
by Elizabeth Uselton
twitter: @lizuselton
Github: ElizabethU

This project is a basic twitterbot used for pranking classmates with a bot that superficially appears to be a weird human. It is one of my first toy projects playing around with APIs, and is not refactored at all, which I hope to change upon having any actual free time.

The bot does two things, mainly.

1. Favorites and retweets an adjustable percentage of tweets of a primary target, and fewer tweets for a text file of secondary targets.

2. Tweets random but sensical tweets on a variety of subjects. The subject is read randomly from a text file, and the searches for a tweet with the topic, and steals the text, sometiems with suprising results. Tweets are filtered for undesirable words read from another text file. It is suggested that you add the @ symbol and the tiny pic url, as the bot tweeting replies or pictures would cause problems and spam people you are not trying to prank.

The third function of replying with a random reply read from an additional text file is included for your perusal, but it is recommended you do not use it, as it has a nasty habit of replying multiple times to the same tweet. Awkward.

Pranks are fun, but please don't use this bot for evil. Evil, I will loosely describe as spamming people you don't know, and/or scaring people into thinking they have a stalker.

You will need to use a cronjob to get the bot to post automatically. The bot is programmed to not post between midnight and 8 am PST, if on a server se to UTC. Otherwise, this time will need to be adjusted.