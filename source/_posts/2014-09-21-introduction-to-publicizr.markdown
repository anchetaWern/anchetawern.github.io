---
layout: post
title: "Introduction to Publicizr"
date: 2014-09-21 09:11
comments: true
categories: [projects]
---

A couple of weeks ago I started building a project called [Publicizr](https://github.com/anchetaWern/publicizr). I created it for the sole purpose of easily publishing a link to my Facebook, Twitter and LinkedIn profile whenever I publish a new post on this blog.

###Dependencies

This project depends on the following Ruby gems in order to work:

- [linkedin](https://github.com/hexgnu/linkedin) - used for connecting/publishing to Linkedin.
- [twitter](https://github.com/sferik/twitter) - used for connecting/publishing to Twitter.
- [koala](https://github.com/arsduo/koala) - used for connecting/publishing to Facebook.
- [em-resolv-replace](https://github.com/mperham/em-resolv-replace) - used for fixing the issue with koala not being able to publish to Facebook from the localhost.

###How to Install

You can install Publicizr by requiring the following Ruby gems in the Gemfile used by your static blogging engine:

```
gem 'linkedin', '~> 1.0.0'
gem 'twitter', '~> 5.11.0'
gem 'koala', '~> 1.10.1'
gem 'em-resolv-replace', '~> 1.1.3'
```

Once you've added those, save the changes to the Gemfile then execute `bundle install` on your terminal.

Once everything is installed, look for the `Rakefile` used in your static blogging engine. For Octopress/Jekyll its located in its root directory. Next add the following on the `Rakefile`. If the `Rakefile` is requiring other gems, just put these below those gems. If not then put it on the first line of the `Rakefile`:

```
require "twitter"
require "koala"
require "linkedin"
require "resolv-replace"
```

Next, put these on the last line of the `Rakefile`:

```
desc "Publish post to facebook, twitter and linkedin"
task :publish, :content do |t, args|

  if args.content
    post = args.content


    #start post to twitter
    tweet = Twitter::REST::Client.new do |config|
      config.consumer_key        = "{twitter-app-key}"
      config.consumer_secret     = "{twitter-app-secret}"
      config.access_token        = "{twitter-user-token}"
      config.access_token_secret = "{twitter-user-secret}"
    end

    tweet.update(post)
    #end post to twitter

    #start post to facebook
    @graph = Koala::Facebook::API.new("{facebook-user-token}")
    @graph.put_wall_post(post)
    #end post to facebook

    #start post to linkedin
    linked_in = LinkedIn::Client.new('{linkedin-app-key}', '{linkedin-app-secret}')
    linked_in.authorize_from_access('{linkedin-user-token}', '{linkedin-user-secret}')

    linked_in.add_share(:comment => post)
    #end post to linkedin

    puts "Your post has been shared!"

  else
    puts "Supply your post!"
  end


end
```

Basically what it does is declaring a rake task that will publish whatever content you pass into it. If you don't need to publish to all 3 (Facebook, Twitter, LinkedIn), feel free to comment out the lines between the lines which says '#start post to facebook' and '#end post to facebook'. Just replace 'facebook' with your social network of choice.

At this point the project still requires you to create your own app on each of the social networks. You can do that by visiting the following links and then look for the page for creating a new app:

- [Facebook](https://developers.facebook.com/)
- [Twitter](https://dev.twitter.com/)
- [LinkedIn](https://developer.linkedin.com/)

Once that's done, you also need to create an app using your language of choice (PHP, Ruby, or Python) that will allow you to retrieve user tokens. If you're primarily a PHP developer you can use the following libraries to ease the work that you need to do:

- [thephpleagues/oauth2-client](https://github.com/thephpleague/oauth2-client) - supports facebook and linkedin.
- [thmOAuth](https://github.com/themattharris/tmhOAuth) - supports twitter.

Once you've acquired the applications keys and user tokens you can now replace the values which says something like `{twitter-app-key}`, `{twitter-app-secret}` on the `publish` task in your `Rakefile`. Basically anything that's wrapped in curly brackets, you need to replace those in order for the plugin to fully function.

###How to Use

You can use publicizr by executing the `publish` task then supplying the content of your post as an argument:

```
rake publish["new blog post: newsletters I subscribe to http://wern-ancheta.com/blog/2014/09/07/newsletters-i-subscribe-to/"]
```

###Support

Any Ruby based static blogging engine is supported. You can check out this [big list of static blogging engines](http://blog.iwantmyname.com/2014/05/the-updated-big-list-of-static-website-generators-for-your-site-blog-or-wiki.html) and look for the ones that are built using Ruby.

###Future Plans

Publicizr is already useable but still requires a bunch of work in order to get setup and running. That's why I plan to add the following features in the future:

- automatically detect last post that was created and publish it automatically when the blog is deployed.
- website for retrieving user access tokens which you can then paste into the rake file. This removes the need for creating your own apps and retrieving your keys from it.