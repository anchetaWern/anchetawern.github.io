---
layout: post
title: "Digging into Octopress"
date: 2013-03-10 13:01
comments: true
categories: [octopress]
published: true
---

In this post I'll be sharing some of the things 
that I've discovered while working with Octopress. 


###Introduction

As you all know Octopress is a blogging framework much like Wordpress 
but only static and its powered by Jekyll which is a static site generator.
Static means that it generates html and other assets whenever you generate the site.
Every configuration are stored in files.
Therefore there's no database involved. 
There's no login and other dynamic things that you might find in Wordpress and other CMS. 


<!--More-->


**Pros**

- You own your content. Posts in octopress lives in your hard drive and then you just deploy them later on.

- Fully customizable and extensible. You get to write your own plugins and themes. And you can customize almost anything on your site.

- You can deploy anywhere. All you need are the files that were generated. No need for PHP, MySQL.


**Cons**

- More difficult setup. You have to install a bunch of stuff from the command line before you get it to work. But the docs are great so there's no need to worry.

- It takes time to generate the whole site when you're publishing something, probably a minute or two but that's just my computer. It might be faster on more powerful computers. 



##Themes

There's a bunch of [themes](https://github.com/imathis/octopress/wiki/3rd-Party-Octopress-Themes) available for Octopress. The one that I'm using for my site is the [Slash theme](http://zespia.tw/Octopress-Theme-Slash/) though I've done a bit of customization so that it won't look too Slashy.

The process for installing a theme is simply downloading the theme then extract it into the `.themes` directory and then execute the following command:

```
cd octopress
git clone GIT_URL .themes/THEME_NAME
rake install['THEME_NAME']
rake generate
```


##Plugins

There's also a bunch of [plugins](https://github.com/imathis/octopress/wiki/3rd-party-plugins) that you can use for Octopress. You can install the plugins on the `plugins` directory inside `octopress`. I personally use the following plugins:

- blockquote
- gist_tag
- video_tag (vimeo, youtube)
- backtick code block


###Customizing Octopress

Customizing Octopress is easy. 
All you have to do is to edit the files on the following directories:

- source - html templates, scripts, images and other site assets (E.g. fonts)
- sass - stylesheets
- plugins - plugin files which are mostly ruby files
- .themes - theme files

Here's a screenshot of the source directory where most of the files that Octopress uses to generate a site are stored.

![source](/images/posts/digging_into_octopress/source.jpg)


####Layouts

In Octopress there are site layouts which are basically just html files with templating logic.
Here's the default layout used in Octopress. Most of the time the default layout is the layout used in the index page of an Octopress blog. 

![default](/images/posts/digging_into_octopress/default_html.jpg)

There's also the `post` layout which just inherits from the default layout. 
And then loads the actual post inside the `article` section. 

![post](/images/posts/digging_into_octopress/post_html.jpg)


So where does Octopress know where to find the `article.html` that we are 
including inside the `article` section? It finds them inside the `_includes` directory.
All the files that are included by doing `include file.html` are stored in the `_includes` directory.

Opening up the `article.html` file we see something like this:

![article](/images/posts/digging_into_octopress/article_html.jpg)

Upon reading the code you will see that this actually does either of two things. 
First it checks if the current page is the `index` page. 
If its the `index` page then it doesn't load all the content of the blog post
but only if you have specified it in your post.

Going back to the Octopress documentation under the blogging basics section. 
You will see that in order to specify where your content will be cut in the index page 
you have to put the `<!-- more -->` comment right after the specific spot where you want 
the content to be cut. Someone might have written a plugin that automatically only loads a bit of the actual content in the index page but having a control on where the content will be cut is really good.

On the other hand if the current page is something other than the `index` page then it simply loads the whole content.


###Behaviors

Here are some of the behaviors that I noticed while I was using Octopress:

- If the source file (markdown) that you are trying to convert to html is not valid it will either return an error when you execute `rake generate` or it will simply fallback to the previously generated site without returning an error.

- Errors in plugins will return an error when executing `rake generate`

- Posts that are not published (published: false) will show up on `rake preview` but does not show up on `rake deploy`


###Commands

Here are some of the commands that I frequently used when working with Octopress:

- **rake generate** - used for generating the site

- **rake preview** - used for previewing the whole site on your browser. The common port is `4000`. So to access your Octopress site offline you would have to type in `localhost:4000` that is if you haven't setup a virtual host on your machine.

- **rake gen_deploy** - used for generating the whole site and then deploy it to your preferred hosting site (E.g Github pages, Heroku).


###Extending Octopress

You can easily extend the default functionality offered by Octopress. With a bit of knowlege in Ruby, Sass, HTML, JavaScript and templating you can already create your own Octopress plugins.
Like I said earlier Octopress is powered by Jekyll 
so anything that you have on Jekyll you also have on Octopress.
Most of the default plugins that you have when Octopress is installed are actually Jekyll plugins. 
Here's a tutorial on [how to create Jekyll Plugins](https://github.com/mojombo/jekyll/wiki/Plugins). 


##Resources

- [Octopress Documentation](http://octopress.org/docs/)
- [Customizing Octopress](http://anchetawern.github.com/blog/2012/11/29/customizing-octopress/)
- [Octopress Plugins](https://github.com/imathis/octopress/wiki/3rd-party-plugins)
- [Octopress Themes](https://github.com/imathis/octopress/wiki/3rd-Party-Octopress-Themes)
- [Jekyll Plugins](https://github.com/mojombo/jekyll/wiki/Plugins)
