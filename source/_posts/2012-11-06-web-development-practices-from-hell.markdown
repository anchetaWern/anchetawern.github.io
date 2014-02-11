---
layout: post
title: "Web Development Practices From Hell"
date: 2012-11-06 00:02
comments: true
categories: [webdev, practices]
published: true
---

In this article we'll explore some of the web development practices that I have observed both as a user of the internet
and a web developer.

*Disclaimer: This post is highly opinionated and may not reflect what's truly a bad web development practice*


**Pagination**

Not only that you have to wait for the page to reload when you click on the next button you also have no idea
what you'll be reading next. Sometimes readers will get turned off when they see a paginated article and will immediately close the browser tab.

![pagination](/images/posts/webpractices_hell/pagination.jpg)


**Using tags from hell**

Still remember the ```<blink>``` and ```<marquee>``` tags? How about the ```<bgsound>``` that makes you want to kill
the website developer for suddenly playing creepy audio when you visit the website? 


**Frames**

By using frames, users have no idea on what pages they're currently viewing, it might be some shady site and they're still not aware of it because its accessed via a frame. 
Yes you can probably do some black magic to actually change the url in the address bar of the browser so that
it reflects which page is currently being viewed but most of the time this is not the case.


**Cool background images**

Have you seen a website with a HUGE background image lately? How about a GIF background-image that twinkles like a star? 


**Copy-pasted code**

There's also this practice of just merely Googling stuff and whatever comes up that matches your needs you just copy it into your project without 
totally understanding what it does and how it works.


**Pop-up Windows**

Yet another practice that makes a website shady. Oftentimes you will only see these pop-up windows on sites that wants to make a lot of money on ads 
that they'll even pop-up ads in front of your face.


**Inline all the things!**

Inline styling such as these:
```
<div style="background-color:green;"></div>
```

And inline JavaScript such as:
```
<a href="#" onclick="alert('boom!');">boom</a>
```

And in case you're not aware there's also:
```
<a href="javascript:alert('double boom!!'); alert('double boom!!');">double boom</a>
```

I won't go ahead and enumerate what's bad about inline styles and scripts since it has already been written before, I've compiled the links in the resources.


**Tables for layout**

I've included a link on the resources but the biggest reason why you would want to avoid tables for layouts is performance.
As it was mentioned in the links, tables takes longer to download and nothing is actually seen by the user
not unless the whole table is already downloaded (prevents incremental rendering).

**Websites that looks like they were designed using MS Word**

The screenshot speaks for itself:

![msword](/images/posts/webpractices_hell/msword.jpg)


**Plugins Galore**

Remember that time when you visited a website and it says something like:

![javaplugin](/images/posts/webpractices_hell/java.jpg)

Some things just aren't for the browser. Browser plugins that accesses the hardware really looks shady.
Tools like that are better off written as a native app.

**Websites that are best viewed with a specific browser**

Were not in the 90's man. There's a bunch of tools that were created to deal with cross-browser testing at ease.
Here's an [article from Smashing Magazine listing some of the cross-browser testing tools](http://www.smashingmagazine.com/2011/08/07/a-dozen-cross-browser-testing-tools/)

![best_viewed](/images/posts/webpractices_hell/bestviewed_ie.jpg)


**Code Obfuscation**

Code obfuscation is certainly useful to help prevent piracy and protect your intellectual property
but sometimes were just too damn proud of the code that we've written and even if we don't really need
to obfuscate it we still do since we don't want others to see our little secret. 
Sometimes its the incompetent developers who does this kind of thing because they don't want
people to see how crappy their code is, they don't want to share their knowledge by making code readable,
and they believe that their code is so perfect that it won't break. 
Or perhaps they want to own the responsibility of maintaining the application that they've written so that they'll get paid again when they maintain or extend it.
Code obfusaction is plain evil especially if you're a web developer.


If you want to see some of these practices live, visit [Websites from hell](http://websitesfromhell.net/)


####Resources

- [Why website frames are bad](http://www.reubenyau.com/top-10-reasons-why-website-frames-are-bad/)
- [HTML Hell Page](http://catb.org/esr/html-hell.html)
- [Why inline css and JavaScript code is such a bad thing](http://robertnyman.com/2008/11/20/why-inline-css-and-javascript-code-is-such-a-bad-thing/)
- [Why pop-up ads are bad for internet users](http://www.ehow.com/about_6651498_pop_up-ads-bad-internet-users.html)
- [Why tables are bad for layout](http://phrogz.net/css/WhyTablesAreBadForLayout.html)
- [Best Practices for Speeding Up Your Web Site](http://developer.yahoo.com/performance/rules.html)