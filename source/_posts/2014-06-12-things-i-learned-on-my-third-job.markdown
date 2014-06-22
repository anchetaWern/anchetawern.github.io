---
layout: post
title: "Things I learned on my third job"
date: 2014-06-12 20:51
update: 2014-06-22
comments: true
categories: [job, learnings]
published: true
---

Its been 3 months since I joined [Islick Media](http://islickmedia.com/), a Web Development shop based in Palm Desert, California. Just like with my previous jobs I work for them as a remote worker. In this blog post I'll be sharing some of the things I've learned on the job.


###Wordpress Theme Customization API

I've worked with the Wordpress Theme Customization API on my first project on the company. I've used it to give the users of the Wordpress theme that I've created a simple way of customizing the look and feel of the theme. Things like customizing the color of links, header and background images can go a long way in making your Wordpress theme easily customizable to non-programmers.

###Zillow

Zillow is a home and real estate marketplace dedicated to helping homeowners, home buyers, sellers, renters, real estate agents, mortgage professionals, landlords and property managers find and share vital information about homes, real estate, mortgages and home improvement. 
I've used their API in providing zestimates (zillow estimates) for real properties.

###Laravel

This is not the first time that I've learned about Laravel. Its some sort of a reacquaintance since I first used it in the year 2012 where it was only newly released. Fast-forward to 2014 there's already a bunch of stuff that has changed and improved. Some of my previous knowledge were still of use but I also had to learn new stuff and new way of doing things. I've learned about the IoC container, and how to make use of external classes the laravel way. I also learned about the authentication class which makes writing the login functionality for your app a breeze.


###Mailing Services

Mandrill and Mailgun are mailing services that I've used for sending out emails for my projects. Yes you can pretty much use the built-in mailing server on the server where your app is hosted. But the main advantage of using a mailing service over the built-in mailing server is authentication. With mailing services such as Mandrill or Mailgun you get the benefit of having your email come from a reputable server. This leads to a higher rate of the emails actually making it into your customers inbox and not the spam.


###SPF and DKIM

SPF and DKIM is a way to authenticate mailing services such as Mandrill and Mailgun to send on behalf of your server. So you can get a cool looking email like: awesomeness@coolness.com to work and actually make it to your customers inbox.


###Amazon EC2

Short for Amazon Elastic Compute Cloud. Its basically a cloud computing platform. You can use it to host web applications and scaling is already taken care of. You can start with a fairly low performance and storage capacity server instance. And once you've met a certain point where the current instance is no longer performing well. You can just upgrade your current instance and all your stuff would still be in there.


###Stripe

Stripe is a company that provides a set of APIs for enabling businesses to accept and manage online payments. They have SDKs (Software Development Kit) available for different programming languages. Which is nice since no matter what programming language you're using to write your app you can use the SDK to easily talk with the Stripe API. Stripe uses credit card for payments. One time payment and subscription based payments are automatically handled for you. 


###Twilio

Twilio is a cloud communications company. They allow developers to provide SMS and Voice functionality to websites. I used twilio in my second project (Vmonial) with the company. Vmonial is an app that allows businesses to accept voice testimonials from their clients. I used the Twilio Voice API on the project. You can basically control the flow using XML files (TwiML) which uses tags like `<Say>`, `<Record>`, `<Play>`, `<Gather>` and `<Response>`.


###WHM

WHM is sort of the big mama of cpanel. This is where you can manage cpanel instances, users, third party extensions, and lots of other stuff for managing a server.


###Elastic Search

Elastic search is an open source, distributed and RESTful search engine. Its like Apache Solr which I've written about a few times in this blog. Lots of people says really good things about Elastic Search that's why I gave it a try on my third project (Roof99) to handle the search. MySQL was not a choice since its a database and it would be terribly slow for searching. Elastic search on the other hand is a search index. Documents are stored in JSON format and querying can be done by using REST (Representational state transfer) calls.


###Prediction IO

Prediction IO is an open source machine learning server. You can use it for creating personalized applications. With Prediction IO you can predict your users behavior, offer personalized content (E.g news, ads, jobs), help them discover things that they might like. All of this can be done by having the server silently record the users activity within your app such as viewing, liking, disliking, and rating something. 


That's it! for now. In the coming months I'll be updating this post and share some more of the things I've learned on my current job.
