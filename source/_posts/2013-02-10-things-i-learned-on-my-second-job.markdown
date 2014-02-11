---
layout: post
title: "Things I learned on my second job"
date: 2013-02-10 15:58
updated: 2013-10-20 12:45
comments: true
categories: [job, learning]
published: true
---


In this blog post I'm going to share some of the things that I learned on my second job.


<!--More-->


###Apache Solr

Apache Solr is a search platform that's available for different languages like Ruby, PHP, and Java.
Solr's main feature is that its very fast. It returns either XML or JSON. 
There's a library available for PHP which is the one that I used. It's called [solr php client](http://code.google.com/p/solr-php-client/)

Here's a sample query for accessing data that's available in the Solr server:

```
http://localhost/solr/select/?q=id:%search&wt=json&rows=%max_results
```  

As you can see its just like accessing data from an API like the one provided by Twitter or Facebook.
You can use Solr via server-side or client side.

If you want to access its data via the server-side you can use the ```file_get_contents()``` php function or ```curl```.
If you want to access its data via the client-side you can use the ```$.ajax``` jQuery function.
But if the Solr server is located on a different server you can use the ```jsonp``` data type. 


###Wordpress Plugin Development

I've also learned about Wordpress Plugin Development and the Wordpress platform as a whole. 
[Codex](http://codex.wordpress.org/), the main documentation site for Wordpress has some really good guides and reference for the different functions that are available from Wordpress.

When developing Wordpress plugins you will almost always have to hang out in these 2 pages:

- [Filter Reference](http://codex.wordpress.org/Plugin_API/Filter_Reference)
- [Action Reference](http://codex.wordpress.org/Plugin_API/Action_Reference)

In Wordpress filters are used for processing the things that are already outputted by Wordpress like the content of a blog post or the title of your blog. Filters are used to modify, add, or hide content.
This is very useful for filtering out things like profanity in blog posts.

Actions in Wordpress are events that happen inside wordpress like publishing a new blog post or creating a new page or activating a plugin. You can hook into these actions to execute a specific function that will do something when these events happen.

There's also a built-in class for accessing the Wordpress database which is the [WPDB](http://codex.wordpress.org/Class_Reference/wpdb) which you will most likely use if the plugin that you're trying to build needs to persist data in a database (E.g for storing settings that your plugin will use).


###API's

I've also learned how to use API's like the [Flickr API](http://www.flickr.com/services/api/), [Amazon Product Advertising API](http://docs.aws.amazon.com/AWSECommerceService/latest/DG/CHAP_ApiReference.html), [Ebay API](http://developer.ebay.com/common/api/), and [Freebase API](http://wiki.freebase.com/wiki/Freebase_API). 
Since this will be used by the Wordpress plugin that I'm developing. 


####Ebay API

The Ebay API was particularly easy to use since they have a very good documentation. 
And by good documentation I mean things are easy to find. 
The documentation also has everything that a developer who is just getting started with using the API wants to know.


####Amazon Product Advertising API

The documentation for Amazon Product Advertising API was the exact opposite of the Ebay API documentation.
Things were hard to find and you can't even find examples on how to use the API on languages like PHP.
Thankfully I found this blog post on [how to access the product advertising API in PHP](http://www.codediesel.com/php/accessing-amazon-product-advertising-api-in-php/) which made life easier.


####Freebase API

The Freebase API was also easy to use because the API itself is relatively simple.
The Freebase API was divided into different services like Search, Image, Text, Topic, etc.
Each of those returns different sets of data in JSON format.
Freebase is already owned by Google so you can basically acquire an API key or access key from the Google API console.


####Flickr API

The Flickr API is also comparable to the Amazon Product Advertising API when it comes to difficulty.
Though the documentation is very good it lacks some examples on how to access the API using different languages.
But the [PHPFlickr](http://phpflickr.com/) library made my life easier. 
All I had to do was to specify the App ID and App secret for my Flickr App which can be created at the [App Garden](http://www.flickr.com/services/apps/create/) and then I can just call the methods which I need.


####Coinbase API

Coinbase is sort of like Paypal but for Bitcoins. Bitcoin is a digital currency that can be used to pay for goods and services. Coinbase is a service that allows you to buy, use and accept bitcoins for payments.
The Coinbase API is used to interact with the Coinbase service. You can do a bunch of stuff with it like listing out all the changes on your Coinbase account, get the current balance in BTC (Bitcoin Currency), generate buttons to be used for paying for services and goods, retrieve contacts, orders, transactions any many more. 
The things that you can do with the Coinbase API are all listed in the [API Documentation](https://coinbase.com/api/doc).

Authenticating API calls can be done using either the API Key or [OAuth2](http://oauth.net/2/).

YOu can also use the [Coinbase PHP](https://github.com/coinbase/coinbase-php) library to easily communicate with the Coinbase service.


###Drupal Custom Module Development

I also learned a bit about custom module development in Drupal. I can say that its tough, you can't just hack your way out to produce a working solution. But the good thing is that most of the problems is more or less already solved by an existing module. All you have to do is install it and figure out how to integrate your own custom module with it.


###Responsive Web Design

I also learned a bit of responsive web design. [The Advanced HTML & CSS guide](http://learn.shayhowe.com/advanced-html-css/) by Shay Howe really helped me a lot in learning responsive web design.


###Shopify App and Theme Development

Recently I also learned about Shopify app and theme development. Shopify is an online e-commerce platform, you can use Shopify to create online stores to sell goods and services. Its sort of like Wordpress, Magento, Drupal, Joomla or other CMS (Content Management System) but only focused on e-commerce and you cannot actually download the platform and host it in a server somewhere. Shopify takes care of everything, that includes installing, upgrading and maintaining the software. But you have the freedom to choose your own domain. 

Shopify really did a great job with their documentation, you can get up and running in a short time. Here are some links to get you started with Shopify development:

- [http://docs.shopify.com/api](Shopify API)
- [http://docs.shopify.com/themes](Shopify Themes)


That's all for this blog post. I will continue to update this blog post once I learn more things from my second job.

 
