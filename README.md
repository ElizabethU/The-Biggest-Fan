Biggest Fan Bot
===============
by Elizabeth Uselton
The Author: [@lizuselton](https://twitter.com/lizuselton)
The Bot in Action: [@katherynebutler](https://twitter.com/katherynebutler)
Github: ElizabethU

This project is a basic twitterbot I built to prank my classmates. The bot superficially appears to be a weird human who is really determined to be friends with you. It's kind of like the eperience of being facebook friends with your parents. It is one of my first toy projects playing around with APIs, and is not refactored at all, which I hope to change upon having any actual free time.

The bot does three things, mainly.

1. Favorites and retweets an adjustable percentage of tweets of a primary target, and fewer tweets for a text file of secondary targets.

2. Tweets random but sensical tweets on a variety of subjects. The subject is read randomly from a text file, and the searches for a tweet with the topic, and steals the text, sometiems with suprising results. Tweets are filtered for undesirable words read from another text file. It is suggested that you add the @ symbol and the tiny pic url, as the bot tweeting replies or pictures would cause problems and spam people you are not trying to prank.

3. Replies with a random reply from an additional text file.

Pranks are fun, but please don't use this bot for evil. Evil, I will loosely describe as spamming people you don't know, and/or scaring people into thinking they have a stalker.

You will need to use a cronjob to get the bot to post automatically. The bot is programmed to not post between midnight and 8 am PST, if on a server se to UTC. Otherwise, this time will need to be adjusted.

To get this code to work, you will need te following text files:

1. A hobbies file with a list of hobbies

2. A last tweeted file which will start blank

3. A list of people for the twitterbot to favorite and retweet things of

4. A list of possible responses

5. A list of words you want to censor. People say some awful things on twitter, and also you'll want to filter anything with pictures or directly talking to other users.

Additionally, you will need a yaml file with your twitter configurations.