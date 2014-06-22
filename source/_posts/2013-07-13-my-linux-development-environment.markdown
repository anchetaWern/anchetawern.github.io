---
layout: post
title: "My Linux Development Environment"
date: 2013-07-13 21:34
comments: true
categories: [ubuntu, tools]
published: true
---

A few months ago I shared some of the [development tools that I use in Windows](http://anchetawern.github.io/blog/2013/05/19/my-windows-development-environment/). This time I'm going to share some of the tools that I use for developing in Linux.

<!--More-->

##Curl

Curl is a command line tool for getting resources from the internet. I commonly use it for installing other command line tools such as `composer` and testing access for different API's directly from the command line.

###How to Install

```
sudo apt-get install curl
sudo apt-get update
sudo apt-get install libcurl3 php5-curl
```

###Sample Usage

```
curl -sS https://getcomposer.org/installer | php
```

##Node JS

Node JS is basically server-side JavaScript. I don't currently use Node.js for my projects but I use it for installing NPM packages such as `grunt` and `bower`. NPM is short for Node Package Manager just like `apt-get` for Ubuntu you can use it for installing different command line tools. What's cool is that you don't really have to be using Node JS in order to make use of the awesomeness that's offered by NPM since most of the packages that are available from NPM aren't necessarily tools that are exclusive to be used for developing Node JS applications.  

###How to Install

```
sudo apt-get install python-software-properties python g++ make
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install nodejs
```

###Sample Usage

You can install packages from the terminal using the `npm install` command. You can use the `-g` option to install the package globally, meaning you can directly use the commands available for the specific package that you installed from any terminal Window.

```
sudo npm install -g grunt-cli
```


##Ruby

I'm not really into Ruby (not yet). I mainly install it because its required by Octopress which is the platform that I use for blogging.


###How to Install

The easiest way to install Ruby is by using [RVM](https://rvm.io/), a command line tool that was specifically created to install, manage and work with multiple ruby environments. 

```
curl -L https://get.rvm.io | bash -s stable
rvm install 1.9.3
rvm use 1.9.3
rvm rubygems latest
```

If RVM doesn't work for you you can also try [YARI](https://github.com/scottmuc/yari) (short for Yet Another Ruby Installer). 


##Composer

Composer is a package manager for PHP. Much like `PEAR` but `PEAR` is already old school so composer is the way to go if you want to easily install PHP packages directly from the command line.


###How to Install

```
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
```


##Git 

Git is a distributed version control system. I mainly use it for maintaining sane snapshots of the applications that I develop. But its also useful for cloning existing tools directly into your machine.

###How to Install

```
sudo add-apt-repository ppa:pdoes/ppa
sudo apt-get update
sudo apt-get install git-core
```

##Apache 

Apache is the Web server that I use for serving the PHP applications that I create.

###How to Install

```
sudo apt-get install apache2
sudo /etc/init.d/apache2 restart
```

##PHP

PHP is the main language that I use for developing web applications.

###How to Install

```
sudo apt-get install php5
sudo apt-get install libapache2-mod-php5
```

##MySQL

MySQL is the database management system that I use with PHP developing dynamic applications.

###How to Install

```
sudo apt-get install mysql-server
sudo apt-get install php5-mysql
```


##Octopress

Octopress is the platform that I use for blogging. But aside from that it also installs a bunch of tools that I use for developing web applications (haml, sass, compass, etc.) so I'm hitting 2 birds with one stone when I install Octopress.

###How to Install

Octopress requires `Ruby 1.9.3` so you must install that one first. After that you can execute the following commands to install Octopress:

```
git clone git://github.com/imathis/octopress.git octopress
cd octopress
gem install bundler
bundle install
rake install
```

##Sublime Text

Sublime Text is the text editor that I use since its very extensible because of the [package control](http://wbond.net/sublime_packages/package_control). 

###How to Install

```
add-apt-repository ppa:webupd8team/sublime-text-2
sudo apt-get update
sudo pt-get install sublime-text
```

###Sublime Text Plugins

- [Alignment](https://github.com/wbond/sublime_alignment)
- [Clipboard History](https://github.com/kemayo/sublime-text-2-clipboard-history)
- [Bracket Highlighter](https://github.com/facelessuser/BracketHighlighter)
- [Dayle Rees Color Schemes](https://github.com/daylerees/colour-schemes)
- [DocBlockr](https://github.com/spadgos/sublime-jsdocs)
- [Emmet](http://emmet.io/)
- [PHPTidy](https://github.com/welovewordpress/SublimePhpTidy)
- [SidebarEnhancements](https://github.com/titoBouzout/SideBarEnhancements)
- [PHPCs](https://github.com/benmatselby/sublime-phpcs)


##Koala

Koala is a tool for automatically compiling and minifying less, sass, coffeescript, and compass files. 

###How to Install

You can install it by downloading directly from the website: [koala-app](http://koala-app.com/).
If you're having an issue with launching the app you can install `libudev 0`:

- [libudev 0 for 32bit](https://launchpad.net/ubuntu/+source/udev/175-0ubuntu19/+build/4325790/+files/libudev0_175-0ubuntu19_i386.deb)
- [libudev 0 for 64bit](https://launchpad.net/ubuntu/+source/udev/175-0ubuntu19/+build/4325788/+files/libudev0_175-0ubuntu19_amd64.deb)


##Chromium

Chromium is the alternative for Google's Chrome browser in Linux. What's great about it is that it still has the Chrome Developers tools and you can also install some of the extensions that you already install on Chrome. You can install Chromium directly from the Ubuntu Software Center.
Here are some of the extensions that I usually install on Chromium to aid in my development:

- **[Axure RP Extension](https://chrome.google.com/webstore/detail/axure-rp-extension-for-ch/dogkpdfcklifaemcdfbildhcofnopogp?hl=en)** - useful for viewing RP Prototypes directly from the browser

- **[PageSpeed Insights](https://chrome.google.com/webstore/detail/pagespeed-insights-by-goo/gplegfbjlmmehdoakndmohflojccocli?hl=en)** - an extension from Google which gives you some suggestions regarding what you can do to improve the performance of the website that you're developing.

- **[Session Buddy](https://chrome.google.com/webstore/detail/session-buddy/edacconmaakjimmfgnblocblbcdcpbko?hl=en)** - I usually use this to create a snapshot of my current browser session so that I can always go back to them at a later time.

- **[Web Developer](https://chrome.google.com/webstore/detail/web-developer/bfbameneiokkgbdmiekhjnmfkcnldhhm?hl=en)** - this extension adds a bunch of web developer tools to Chromium such as tools for validating HTML and CSS, displaying ARIA roles (useful for website accessibility purposes), and displaying the current browser size (useful for targeting a specific breakpoint when you're doing responsive design).


##Filezilla

Filezilla is an FTP client that I use for accessing the files for the websites that I work on. You can install it directly from the Ubuntu Software Center.


##Everpad

My Evernote client of choice for Ubuntu. This is where I write all my todos for each day. Once I'm done with a specific task I put a strikethrough in the list item to indicate that its already done. 

###How to Install

```
sudo add-apt-repository ppa:nvbn-rm/ppa
sudo apt-get update
sudo apt-get install everpad
```

###Apt-Fast

I use `apt-fast` as a replacement for `apt-get` for downloading and installing packages in Ubuntu. `apt-fast` is like `apt-get` on roller blades in that its very fast in downloading packages. You can use it by simply replacing the usual `apt-get` with `apt-fast`. 


###How to Install

```
sudo add-apt-repository ppa:apt-fast/stable
sudo apt-get update
sudo apt-get install apt-fast
```

##Virtualbox

Virtualbox is an open-source OS virtualization application which you can use to install and use different Operating Systems right inside Ubuntu. Its very useful for when you need to use an application that's not available on Ubuntu (E.g. IE 9 and 10). You can install Virtualbox via the Ubuntu Software Center.


##Skype

Skype is the instant messaging application that I use for collaborating with co-employees since I'm working remotely. As of the time of writing Skype is available for Ubuntu 10.04 32-bit on the [Skype website](http://www.skype.com/en/download-skype/skype-for-computer/) but you can also install it on higher versions of Ubuntu.


##Dropbox

Dropbox is the application that I use for easily sharing files. I mostly use it for work when I have to share a screenshot or a text file. I use it over Skype file sharing because the receiver doesn't have to download the file on their machine just to view it. With Dropbox I can simply share the link via Skype and the receiver can simply open it up on their browser. You can install Dropbox directly from the Ubuntu Software Center.

