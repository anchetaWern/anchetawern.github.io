---
layout: post
title: "Introduction to Contact plugin for Octopress"
date: 2014-08-02 21:01
comments: true
categories: [jekyll, octopress, plugin, projects, ruby]
published: true
---

In this blog post I'll be introducing the [Contact plugin for Octopress](https://github.com/anchetaWern/jekyll-contact). 
This plugin allows you to create contact forms with ease. Its using the [pooleapp.com](http://pooleapp.com/) for saving the data for the forms that are submitted.

###Create a Pooleapp account

First lets go through pooleapp. Poole is a free, hosted data store for static sites. It allows you to post data into it and then later on you can retrieve the data using a simple API. 

You don't have to register to start using pooleapp but its recommended so that you can keep track of the forms that you create. Another bonus feature is that when someones submits a data to your contact form, pooleapp will immediately notify you via email.

Once you've registered an account, you can now create a new form. Just give your form a unique name and click on the 'create form' button. Once created, pooleapp will ask you for the email in which you want the notifications to be sent to.


###Installing the plugin

Octopress doesn't really have a plugin system so we'll have to do things manually. First thing that you need to do is to add the `contact.rb` file into the `octopress/plugins` directory. 

So that we can show a success message once the visitor submits his data through the contact form, we also need to add the `contact.js` file inside the `source/javascripts` directory. Basically what it does is to check for the existence of the `form` query parameter. If it exists then it makes the success message visible. 

For the styling, add the `_contact.scss` file inside the `sass/partials` directory. Then in your `sass/_partials.scss` file, import the css for the contact form by adding the following on the last line:

```
@import "partials/contact";
```

Lastly, under the `source/_includes/custom` directory, add a script tag that points out to the `contact.js` file on the last line:

```
<script src="{{ root_url }}/javascripts/contact.js"></script>
```

###Using the plugin

To use the plugin in any of your pages, simply use the `contact` liquid tag then supply your pooleapp API key as the first argument, and the redirect URL for when the form is submitted:

{% raw %}
```
{% contact YOUR_POOLE_APP_API_KEY http://YOURSITE.COM/PAGE?form=ok#alert-box %}
```
{% endraw %}

###Demo

You can try out the demo on the [about me page of this blog](http://wern-ancheta.com/aboutme).