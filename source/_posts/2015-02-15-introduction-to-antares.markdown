---
layout: post
title: "Introduction to Antares"
date: 2015-02-15 17:05
comments: true
categories: projects
published: true
---

As a developer there's no question as to why we need to [keep ourselves updated](http://programmers.stackexchange.com/questions/161099/why-do-developers-need-to-keep-up-to-date-with-technologies-and-methodologies). And that is why reading blogs is really important. There's no shortage of the most important people to follow on twitter, newsletters, podcasts and screencasts that helps us to keep up to date. But as the years pass the amount of resources that we use to keep ourselves updated tends to grow. This results in a browser window that looks like this:

![too many tabs](/images/posts/antares/tabs.png)  

Just the act of opening the interesting links in new tabs can take up to 30 minutes or more (I know, I've been there). All because of the sheer amount of resources that were trying to maintain. I've been doing that for years, and as my collection of resources grew larger, it only became harder and harder to read all of those things that are seemingly important. That is when I had the idea of creating an app which would still allow me to keep up to date, but will save me the time in opening all those links in a new tab. That is what Antares is all about. Its essentially a news app for developers. It collects content from interesting places such as Hacker News, Github, Designer News, Medium, Readability Top Reads, Slashdot, EchoJS, SidebarIO, and Product Hunt. It also collects all the content linked from popular developer newsletters such as JavaScriptWeekly, HTML5Weekly, PHPWeekly, CSSWeekly, Web Design Weekly and many others. Its basically an all in one tool for keeping up to date. As for me, it also have the effect of just letting go. Because having all those newsletters sent in my email has this mental effect that its something I need to open no matter what. The kind of feeling that its your responsibility to read through all those articles being pointed out in the newsletter. The feeling that you'd miss out on something really important if you don't. Antares isn't like that. You can just install it and let it sit there. And you only really open it if you have some free time. The news just keeps on flowing in there but it doesn't make you feel that you'll miss out on one half of your life as a developer if you don't.

For the technical side of things, I used [Ionic framework](http://ionicframework.com/) to build the app. Under the hood it uses HTML, CSS and JavaScript. Ionic is tied with Angular.js so there's really not much choice about what JavaScript framework to use. For the back-end I used Laravel to scrape the necessary data from all the relevant resources. It is then stored in a MySQL database. The data (mainly a title and a URL) is then requested via AJAX from the mobile app. Ionic then handles the presentation. To give you an idea, here's a couple of screenshot of how the app looks like:

![hacker news](/images/posts/antares/hn.jpg)

![article](/images/posts/antares/news.jpg)

As a developer who loves working on the back-end, I didn't really bother customizing the look and feel of the app.

This blog post is getting rather long for an introduction. Here's the [link to the app on Google Play Store](https://play.google.com/store/apps/details?id=com.wern.antares). If you got a Windows Phone, I also have the `.xap` file which you can use to install Antares. Antares doesn't have a version for apple devices. Mainly because it costs around $99 per year to be included in their developer program. As someone who doesn't really plan to make any money out of this. I think its unwise to pay for that amount. I'm already paying $10 per month for the server costs and I paid $25 to put the app in the Google Play Store so I guess that's enough expenses on my part.