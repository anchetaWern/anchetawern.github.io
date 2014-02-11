---
layout: post
title: "Using localtunnel to share your localhost to the rest of the world"
date: 2012-08-12 14:07
comments: true
published: true
categories: [tools]
---

In this tutorial I'm going to show you how to install and use a tool called localtunnel
to make your localhost accessible to the rest of the world. 

Localtunnel is a ruby gem so you will need ruby in order to install it.
You can go to [rubyinstaller.org](http://rubyinstaller.org/downloads) to downlad an installer for ruby.
Just install just like how you install most of the programs(click next a couple of times until you reach finish).

Make sure that you can use ruby from the command line by executing the following command in the command line(terminal) 

```
ruby --version
```

After that you can install ruby gems. You can go to the [rubygems download page](http://rubygems.org/pages/download)
and follow the instructions on how to install it. Basically you're going to download a zip or tgz file then extract it
somewhere then execute the following command on the folder where you have extracted the files: 

```
ruby setup.rb
```

Then go to the [localtunnel site](http://progrium.com/localtunnel/) and follow the instructions there. It's
quite simple all you have to do is execute the following command: 

```
gem install localtunnel
```

After it has installed open up a new command line and change the directory to where your public ssh key is
then execute the following command: ```localtunnel id_rsa.pub 80```

The ```id_rsa.pub``` is the filename of your public ssh key. You can easily determine your public ssh key by its 
file extension(.pub). 

If you don't have a public ssh key go to [help.github.com](https://help.github.com/articles/generating-ssh-keys) 
and follow the guide on how to generate a new key.

Apache is normally running at port 80 but if you have modified where its running and you're not sure what port it
is then look for the httpd.conf file(Google what its called for Linux or Mac, not really sure). 
Then search for: ```Listen```

If you're running Nginx, IIS or something else. Then Google it because I have no experience running those servers yet and I 
can't really tell what port do they normally run.

If you see a 2 to 4 digit number beside it then that's the port where Apache is running. 
That is what you will use for the localtunnel command. So for example you found ```Listen 8020```
then your localtunnel command will be ```localtunnel 8020```

After that it will prompt you to type in your passphrase, the one that you typed when you generated your public ssh key.

After that you will see something like this:

```
Port 8020 is now publicly accessible from http://8bv2.localtunnel.com ...
```

Just copy the url and paste it into the address bar of your browser. 