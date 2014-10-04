---
layout: post
title: "Introduction to Ahead"
date: 2014-09-28 09:20
comments: true
categories: [projects]
published: true
---

I've been in side-project frenzy these past few weeks. And this time I'm writing again about another side-project that I've been working on, its called [Ahead](https://github.com/anchetaWern/ahead). Ahead is an app that allows you to schedule posts to your facebook, twitter and linkedin accounts. Pretty much like Buffer. But Buffer has limits for free accounts, that's why I built this app so I can schedule posts without limits.

###How to Use

You can use Ahead by going to its [demo website](http://ec2-54-68-251-216.us-west-2.compute.amazonaws.com/). Create and account then login. Once logged in, go to the networks page and connect the accounts where you want to publish by clicking on the connect button:

![networks](/images/posts/intro_to_ahead/networks.png)

Once your accounts has been connected, you can now start scheduling posts:

![schedule new post](/images/posts/intro_to_ahead/schedulenew_post.png)

You can check the time in which your post will be published from the posts page. From the published column you can also see if your post has already been published or not:

![posts](/images/posts/intro_to_ahead/posts.png)

If you don't want to select the networks in which you want to publish all the time, you can visit the settings page and then select the networks which you want to select by default:

![settings](/images/posts/intro_to_ahead/settings.png)

If you don't want your posts to be published one hour after another you can also add custom schedules by visiting the schedules page:

![new schedule](/images/posts/intro_to_ahead/schedule.png)

Just select an interval that you want and it will be available as an option when you schedule a new post. Of course you can also select a default schedule from the settings page once you're done creating a schedule. Currently only the following intervals are supported:

- every 1 hour
- every 2 hours
- every 3 hours
- every 4 hours
- every 5 hours
- random time in the next 72 hours (3 days)
- random time in the next 168 hours (1 week)

###Future Plans

Ahead is still in early stages of development. Its already quite functional but I'm planning to add the following features in the future:

- **Publish posts without links** - currently it can only publish posts with links in it. I originally envisioned this project for my personal use only and I don't really schedule posts without links in it.
- **Add social login** - currently you can only start using the app by signing up with your email.
- **Email verification** - currently you can use fake emails when signing up.
- **Editing and deleting posts** - currently you can no longer edit posts that has already been scheduled. I'm planning to add an edit or delete feature in order for users to be able to make changes to their scheduled posts.
- **Immediate publishing** - currently only scheduled posts are supported. 
- **Add custom intervals to schedules** 
