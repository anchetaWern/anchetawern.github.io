---
layout: post
title: "Getting Started with Supervisor"
date: 2014-08-15 19:32
comments: true
published: true
categories: [supervisor, process-manager]
---

Recently in my work I had this node.js script that I had to run persistently. Its basically a server that will generate images based on some JSON data that's passed from the client side. So I did some searching and found [Supervisor](http://supervisord.org/), a process control system. It allows you to run programs persistently.

###Installation

You can install install Supervisor by executing the following command in your terminal:

```
sudo apt-get install supervisor
```

###Configuration

Once the installation is done, you can now create the config file. This is where you specify which script you want to run, the directory in where you want to run it, and a log file in which the output is redirected.

```
sudo nano /etc/supervisor/conf.d/image-creator.conf
```

Here's what a config file looks like:

```
[program:imagecreator]
command=node image-creator.js
directory=/home/ubuntu/www
stdout_logfile=/home/ubuntu/logs/image-creator.log
redirect_stderr=true
```

Breaking it down. This is where we set the name of the program. Yes the `program:` is always there, only the thing that comes after it is updated. In this case the name of the program that I gave is `imagecreator`.

```
[program:imagecreator]
```

Next is the command that you execute when you're running the program in the terminal. In this case were executing the script via the `node` command:

```
command=node image-creator.js
```

Next is the directory where the program is stored. This can also be the directory where you want to execute the program:

```
directory=/home/ubuntu/www
```

This is where you specify the file where you want to redirect the output of the program:

```
stdout_logfile=/home/ubuntu/logs/image-creator.log
```

Lastly, we specify whether to send back the `stderr` output to supervisord on its stdout file descriptor:

```
redirect_stderr=true
```

That's pretty much all we need for the configuration file. You can go ahead and save it. If you want to specify more settings, check out the [docs on configuration](http://supervisord.org/configuration.html)


###Adding the Process

Now that we have a configuration file in place we can now tell supervisor to add it to the list of processes that it currently manages. You can do that by using `supervisorctl`:

```
sudo supervisorctl
```

Executing the command above will let you enter the supervisor program. Next execute the following commands in order:

```
reread
add imagecreator
start imagecreator
```

Breaking it down:

- `reread` tells supervisor to read the configuration files that are available. 
- `add` tells supervisor to add the program into the list of programs that it will manage.
- `start` tells supervisor to run the program.


##Conclusion

That's it! Supervisor is a neat little program that allows you to run programs persistently. Just be sure that errors are handled accordingly because supervisor wouldn't continue running your program if an error occurs while its running.


