---
layout: post
title: "Introduction to Laravel Bootstrap Starter"
date: 2014-10-04 19:10
comments: true
categories: [projects]
published: true
---

I'm still on side-project frenzy. This week its the [Laravel Bootstrap Starter](https://github.com/anchetaWern/laravel-bootstrap-starter). 
I created this project to make it easier for me to setup a Laravel project faster. I'm using Laravel in the company that I work for and every time I start a new project I have to install it via composer, configure it so that it doesn't show `/public` in the URL. From there I add the default controllers, add the sign up and login code, add the functionality for updating and resetting password, install node, grunt and then bower. And then install the grunt plugins that I need for front-end performance optimization. The list goes on, and just setting up a project may take a whole day. That's why I decided to create this project. 

###Features

Like most of the projects that I decided to do so far. It only contains the essential features:

- sign up and login
- resetting passwords
- admin (updating account information)

###Future Plans

As I move along with this project I'm gonna be adding the following features:

- **social login** - google, twitter, facebook, linkedin
- **database backup** - every project must have an automated database backup functionality. I'm thinking of using cron for running the backup script and then upload the backup to an Amazon s3 bucket.
- **generators** - there are 2 projects doing this already, one is [Jeffrey Way's Laravel 4 Generators](https://github.com/JeffreyWay/Laravel-4-Generators) and the other is [Wes Dollar's forked version](https://github.com/wdollar/Laravel-4-Generators-Bootstrap-3), both looks pretty good. I think I'll be able to get some ideas from these projects. Basically the plan here is to be able to use the terminal for generating boilerplate code which I can then build upon. 
- **build tool integration** - I want to be able to just hit one command and it will install and configure everything that I need to get the project started. Yeoman seems to be a very good fit for this. 
