---
layout: post
title: "Introduction to Portfolio plugin for Octopress"
date: 2013-08-18 20:19
comments: true
categories: [ruby, octopress, jekyll, projects]
publised: true
---

In this article I'm going to introduce Portfolio, an Octopress plugin that I created for easily creating portfolio pages based on the images on your filesystem.

The portfolio plugin is a liquid tag type of plugin which means that it gives you the ability to use the tag to generate a specific content. In this case the portfolio plugin allows you to generate image tags based on the images in a directory that you specify.


###How to Install

You can install the portfolio plugin by simply copying the `portfolio.rb` file into the `plugins` directory of your Octopress installation.


###How to Setup

You can setup the plugin by opening up the `_config.yml` file and specify the root directories in which the plugin will look for the files that it will be using.

```
portfolio_root: /portfolio
portfolio_img_root: /images/pages/portfolio
portfolio_path: /web_files/blog/octopress/source/images/pages/portfolio
portfolio_url: images/posts/pages/portfolio
```

The `portfolio_root` is the name of the directory where your portfolio is saved. 
The `portfolio_img_root` is where the images for your portfolio is saved. 
The `portfolio_path` is the actual path in your filesystem where your portfolio is saved. 
And the `portfolio_url` is the address where you can access your portfolio from the browser.


The plugin doesn't come with a default styling so you have to add them on your own. You can simply hook up to the markup that has been provided, 
that is the `gallery-item` class.
In the example above I gave it a default `width` and `height`. 
The `overflow` is set to hidden so that the image that it contains won't overflow. 
The `margin` is `10px` all around. Lastly, its floated to the left so it would align nicely. 
You can add this on the `sass/base/_layout.scss` file or anywhere you feel would be appropriate.

```css
#content .gallery-item {
    float: left;
    width: 390px;
    height: 150px;
    overflow: hidden;
    margin: 10px;
    border: 1px solid lightgray;
}
```

Next create a directory where the details of your projects will reside. The ideal location would be in the `octopress/source` directory. This should be the same as the value of the `portfolio_path` that you have included in your `_config.yml` file earlier. Each of your project will have its own directory, so if you have a project named `echo` then you have to create the following directory: `octopress/source/portfolio/echo`.

Also create the directory where the images for each of your project will reside. Following the path that we specified earlier we should have the following directory for project `echo`:

```
octopress/source/images/pages/portfolio/echo
```

The `echo` directory is where you will save your images. If you intend to use lightbox or any other alternative you can simply put `small-` as a prefix to the name of your image files. The images with this prefix will automatically be used as the initial image and the one without it will be larger image. So if you have an image file named `index.png` you also need to have `small-index.png` file. Of course this should also be resized. Having the browser do the resizing for you by setting the width and height of the image using css is not a good idea.


It's also recommended that you run your images through an image optimizer before you actually add them to the directory as Octopress won't optimize it automatically. This is to ensure that your project page will load faster.


###How to Use

You can use the plugin by using the `portfolio` liquid tag followed by a single space then the name of your project. Just put on underscores if you need spaces. Also there shouldn't be any special characters. For our imaginary `echo` project:

{% raw %}
```
{% portfolio echo %}
```
{% endraw %}


###Resources

[Jekyll Plugins](http://jekyllrb.com/docs/plugins/)



