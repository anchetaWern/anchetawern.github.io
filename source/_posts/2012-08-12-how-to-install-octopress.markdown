---
layout: post
title: "How to install Octopress"
date: 2012-08-12 15:05
comments: true
categories: [octopress]
---

In this tutorial I'm going to show you how I've installed Octopress. 
Installing Octopress was a fun experience especially for those without
prior knowledge of Ruby tools such as gems, rake and stuff.

As you might probably know Octopress is a blogging framework for hackers
and the customizability(I don't know if that word exists) is pretty flexible
you can almost do anything that you want.

The [documentation for Octopress](http://octopress.org/docs/) is actually pretty readable and easy to follow.
You can actually go ahead and read it up and see if you can follow. Just come back here if you think you cannot
and I'll make things easier for you. I promise.

###Tools you're going to need

 * [Ruby](http://rubyinstaller.org/downloads) 
 * [Ruby Gems](http://rubygems.org/pages/download)
 * [Ruby Dev Kit](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit)
 
Download and install the first 2 tools(Ruby and Ruby Gems). It's not that difficult. 
The third one(Ruby Dev Kit) is a little bit harder in my opinion so I'm going to show it to you. 

####Installing the Ruby Dev Kit

Extract the zip file anywhere then open up a new terminal inside the root directory where its contents has been extracted.

Execute this command:

```
ruby dk.rb init
```

Edit the ```config.yml``` file that it has generated. On the last line specify the directory where Ruby is installed:

```
- D:/web_files/github/yari/ruby-1.9.3-p194-i386-mingw32
```

Execute the following command(still inside the ruby dev kit folder):

```
ruby dk.rb install
```

Once that's done you can actually go ahead and follow the [Octopress Setup Guide](http://octopress.org/docs/setup/).

The Octopress docs will pretty much guide you what to do next so it's actually pretty easy and straightforward.

Just go through the following guides in order. The following steps assumes that you have already installed Git on your computer.
If you haven't done it yet just follow this [guide from Github](https://help.github.com/articles/set-up-git/) on setting up Git. 
If you're on Windows its actually a lot more easier because all you have to do is to download the Github installer for Windows
and install it just like how you install most of the programs on Windows(click next until you hit finish). 

 * [Deploying Octopress on Github](http://octopress.org/docs/deploying/github/)
 * [Blogging](http://octopress.org/docs/blogging/)
 
 If you're having trouble you can seek [help](http://octopress.org/help/) at Stackoverflow(don't forget to use the octopress tag),
 Twitter(they're pretty fast at responding) or [Octopress Github Page](https://github.com/imathis/octopress/) and post an issue. 
 
 Good luck and happy hacking!