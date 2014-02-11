---
layout: post
title: "Introduction to Postr"
date: 2012-10-01 21:10
comments: true
categories: [projects, app]
published: true
---

I finally got the time to post something to my blog. These past 2 weeks I have been busy with my side project which I call Postr.
The main topic of this post is basically the Postr App which is now accessible at [postr-wern.rhcloud.com](https://postr-wern.rhcloud.com/)
It may still have a few bugs but I think its already usable. Postr is an app that will allow you to simultaneously update your
status on Facebook which includes your facebook profile, groups where you are a member, and pages which you have liked. It can also post
to Twitter.

####Some Mistakes
I've also made some mistakes while I was creating the app. Here are some of those:

 * First I wrote too much repeated code. It was so easy at first because I was
just copy pasting things here and there but I remembered the Don't Repeat Yourself policy for programmers so I've done 
some refactoring to reduce the lines of code especially on the client side. What I've done is to encapsulate the logic inside a single 
method and supplied different arguments to alter the results. 

 * Second, I underestimated how much the codebase will grow. My plans 
were pretty small at first, just simultaneously post to social networking sites. Boom! Done! That's what I thought. I also thought that
it will only keep me busy for a week but that was a mistake. Because of that mistake I also wrote the backend code (PHP) in procedural form.
That was really a stupid mistake and I ended up having to replace almost every procedural code that I've written and converted it to OOP.

 * Third, I was too eager to finish it at the shortest time possible which was probably the root of all the problems that I encountered.
I worked on the project full time 7 days a week (or maybe not cause I also watched some anime and read some blogs for 2 or more hours).
This was probably a good thing cause I was really focused in finishing it. But it has also caused me to write some crappy code which I had
to replace later on.

 * Fourth is the lack of planning. I didn't even created a mockup as a basis for the app that I'm trying to create. I didn't even sketched or 
wrote anything on paper. I started typing codes immediately.

####Problems Encountered

Like any other human person I also encountered some problems.

 * First is the problems with inputs (arguments). I didn't double-checked what I was typing and that lead to output that I didn't expect.
 
 * Second is a problem regarding version control. I'm using Git and I'm very happy with it. 
And yes I only know the commands that I use daily like ```git add [some file]``` , ```git commit -m "[what did I do?]"```, ```git push```, ```git branch```, ```git checkout```, ```git rm```.
There are times when I just Google things up and I just mindlessly execute the first command that I see (probably from Stackoverflow).
There was a time when I suddenly execute ```git rm *.php```. Guess what happened. I'll give you 3 seconds (though your probably already know if you're using Git daily).
The command deleted all the php files in my project. Thankfully I was able to commit my changes before doing that dreadful mistake. 
Another Google search and I found the command ```git reset --hard HEAD``` which saved my life. What it does is to revert back to the previous commit.

 * Third is the problem with deployment. I've deployed the Postr app to ```Openshift``` which is a free application platform. 
I'm on Windows so I guess its only natural that I will have problems when I push my code to a Linux Server. 
The problem that I had was that its not loading the resources from a ```CDN``` specifically ```JQuery UI``` at first I thought that there
was a problem with my input but the problem was simply that the resource were not being loaded. Because of this I had to download ```JQuery UI``` to the app folder.

####Things I learned
 
 * I learned about the Facebook SDK a lot. I learned about ```fql``` and that you could join tables using ```fql.multiquery```.
I also learned that you cannot do ```SELECT *``` using ```fql``` you really have to explicitly tell facebook the fields that you need.
I also learned that client side can read the current session even if the user has logged in to Facebook using PHP. This is by setting the ```cookie``` property to ```true```
when initializing Facebook via the ```FB.init``` method.

 * I also learned how to create Facebook, Twitter, LinkedIn, Google, and Tumblr apps. Basically the only thing that's common to them is that 
they have an access token and access secret which you can then paste into the library that you are going to use to connect to the ```API's``` that
they provide. The libraries are mostly using ```curl``` to communicate with the ```API``` that the service provides.

 * I also learned about a super awesome PHP library called [eden](http://eden.openovate.com/) which is used for rapid prototyping. 
It has some really nice classes for connecting to Twitter, Facebook, Google Plus and other online services which you can easily use to connect to those
services easily.
   
 
####Walkthrough

Here's a little walkthrough of the app. 

Index page.

  ![postrIndex](/images/posts/postr/index.jpg)
  
  
Postr main age where you can create your status updates.

  ![postrMain](/images/posts/postr/postr.jpg)  
  
  
Main settings.

  ![mainsettings](/images/posts/postr/postrsettings.jpg)  

Facebook settings

  ![fbSettings](/images/posts/postr/fbsettings.jpg)    
  
  
####Features to be Added in the Future
Of course this doesn't end here. Here are some features that I would certainly add in the future:
 
 * Posting status updates to LinkedIn, Google Plus, and Tumblr
 * Fetching old status updates from Facebook, Twitter, Google Plus and Tumblr and allow the user to post it to other social networking sites.
 * Scheduling of posts - Openshift also supports Cron Jobs but the main problem will be expiring access tokens. I love twitter cause their access tokens doesn't expire. 

####Conclusion
That's pretty much everything I wanted to say about Postr. If anyone is interested in testing it out please go to [postr-wern.rhcloud.com](http://postr-wern.rhcloud.com) and let me know if it breaks for you. Thanks!