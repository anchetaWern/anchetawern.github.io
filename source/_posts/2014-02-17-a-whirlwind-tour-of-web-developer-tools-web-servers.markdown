---
layout: post
title: "A Whirlwind Tour of Web Developer Tools: Web Servers"
date: 2014-03-02 14:35
comments: true
categories: [web-servers, web-development, tools]
published: false
---

In this part four of the series A Whirlwind Tour of Web Developer Tools I'm going to walk you through web servers. Web servers are computers that commonly delivers web pages. But when talking about web development web server refers to the software used for serving up the web pages. In this blog post I'm going to talk about 4 web servers that you can use in serving up your web projects.

<!--more-->

###Python Simple HTTP Server

First on the list is the simple http server that is built-in to python. So in order to use this you would need to have Python installed. Python already comes pre-installed in Ubuntu and other Linux distributions so you already have the simple http server by default. For Mac OS X its also pre-installed. But for Windows you would need to get an installer from the [Python website](http://python.org/download/).
You can use it by opening up a terminal from any directory that you want to serve and execute the following command:

```
python -m SimpleHTTPServer
```

To test it out you can create a new `index.html` file on the directory where you executed the command above and access [http://localhost:8000](http://localhost:8000) from your browser. 

Note that the simple http server will simply list out all the files in that directory if you do not have an `index.html` file:

![simple http server](/images/posts/whirlwind_tour_webservers/simplehttpserver.png)

You can also implement your own web server by creating a new python file (`server.py`) and putting the following code:

```python
import SimpleHTTPServer
import SocketServer

PORT = 1234

Handler = SimpleHTTPServer.SimpleHTTPRequestHandler

httpd = SocketServer.TCPServer(("", PORT), Handler)

print "serving at port", PORT
httpd.serve_forever()
```
You can then execute the `server.py` file from the terminal to start the server. Note that the file must be inside the same directory that you want to serve.

####PHP Server

There is also the built-in server for PHP version 5.4.0 and above. This comes with PHP so you need to install it first before you can start using it. You can install PHP by executing the following command from your terminal

```
sudo apt-get install php5
```

Once you're done installing it you can now start using the server by navigating to the directory that you want to serve and executing the following command from the terminal:

```
php -S localhost:8000
```

This will serve up the current directory under port 8000 of your local machine so to access it from the browser you can open up the following url: [http://localhost:8000](http://localhost:8000).

Note that if you do not have a default file (either `index.html` or `index.php` file) in the directory that you are serving the PHP server is going to return a 404 not found:

![php-server](/images/posts/whirlwind_tour_webservers/php-server.png)

The advantage of using the PHP server over simple http server is that you can actually create some php files in the directory that you are serving, write some code in it and the server will also be able to interpret it for you. 

###Apache

Next is the Apache HTTP Server from the Apache Foundation. You can install it by executing the following command from the terminal:

```
sudo apt-get install apache2
sudo /etc/init.d/apache2 restart
```

For Windows users there is this thing called [WAMP](http://www.wampserver.com/en/) which you can install. Apache is packaged with it along with MySQL and PHP so you can start playing with it immediately without doing a lot of configuration. You can also have them installed separately but you will have to do some configuration before you can start playing with it. I've written a tutorial about it before: [How to install and configure apache, php, and mysql](http://kyokasuigetsu25.wordpress.com/2012/04/12/how-to-install-and-configure-apache-php-and-mysql/) so check that out if you do not want to use packaged versions. 

For MAC OS there's [MAMP](http://www.mamp.info/en/index.html).

There's also [XAMPP](http://www.apachefriends.org/index.html) which is a cross-platform solution for easily setting up Apache, PHP, and MySQL on your machine.

If you're a beginner I definitely recommend using either WAMP, MAMP or XAMPP as it can be sometimes frustrating to configure everything on your own.

Ok back to the main topic of this section which is Apache. If you're on Linux and you have installed Apache separately you might want to [configure the default web directory](http://anchetawern.github.io/blog/2014/02/05/fixing-the-forbidden-error-in-apache/) since the default web directory that is used by Apache isn't writeable if you do not access the file explorer as a super user. This becomes a problem when accessing the web directory from the browser as Apache throws you a forbidden error. If you haven't catch it the first time you can go ahead and use the following tutorial: [fixing the forbidden error in Apache]( [configure the default web directory](http://anchetawern.github.io/blog/2014/02/05/fixing-the-forbidden-error-in-apache/)) to properly configure Apache. Once you're done with that you can go back to this blog post.

After configuring the default web directory used by Apache you can now put some test files on the web directory. Something like `index.html` and put the following contents:

```html
<h1>Hello World from Apache!</h1>
```
Now if you go to [http://localhost](http://localhost) you can now see the `index.html` being served by Apache. Apache serves everything on port 80 by default so we didn't have to add the port when we access it from the browser. This is because the browser knows by default that web pages are served at port 80. If you already have PHP installed you can also serve php files. Apache already knows how to serve those by default so there's no need for further configuration.

###Nginx

Lastly there's Nginx one of the HTTP servers that's gaining market share lately. You can install it by executing the following command from your terminal:

```
sudo apt-get install nginx
```

If you're on Windows there's a guide from the Nginx website on [how to install Nginx on Windows](http://nginx.org/en/docs/windows.html).

For Mac you can install it via homebrew:

```
brew install nginx
```

Once Nginx is installed you can run it by executing `sudo nginx`. Note that if you already have Apache installed you would have a problem starting Nginx up. Most likely you would get an error similar to the one below:

![nginx port error](/images/posts/whirlwind_tour_webservers/nginx-port.png)

This is Nginx telling you that port 80 is already in use. We learned earlier that Apache uses port 80 by default so running another server which serves web pages at port 80 will lead to that issue.
What we need to do is to configure Nginx to listen to another port. And you can do that by navigating to the following path:

```
cd /etc/nginx/sites-available
```

Then open up the `default` file:

```
sudo gedit default
```

From there scroll down to the line which is similar to the following:

```
server {
	listen 80 default_server;
	listen [::]:80 default_server ipv6only=on;

	root /usr/share/nginx/html;
	index index.html index.htm;
```

There are 2 things that you can do from here. First replace the 2 instances of `80` which is the default port used by Nginx to something like `6789`. Then you can also change the default web directory. Nginx uses `/usr/share/nginx/html` as its default, you can change it to something like `/home/your_user_name/nginx_web_files`. After updating the `default` file it should now look like this:

```
server {
	listen 6789 default_server;
	listen [::]:6789 default_server ipv6only=on;

	root /home/your_user_name/nginx_web_files;
	index index.html index.htm;
```

After that save the file and restart Nginx using the following command:

```
sudo nginx -s reload
```

You can now go ahead and create a sample `index.html` file in your chosen web directory and put the following contents:

```html
<h1>hello world from nginx!</h1>
```

To access it from your browser go to [http://localhost:6789](http://localhost:6789).

####Configuring PHP in Nginx

Not unlike Apache, Nginx doesn't work with PHP by default so if you try serving up a PHP file Nginx won't understand it and it will give you a bad gateway error.

In order to make PHP work with Nginx you first have to install the `php5-fpm` package via the terminal:

```
sudo apt-get install php5-fpm
```

Once that's done you can now update the `default` file under the `/etc/nginx/sites-availble` directory. 

```
sudo gedit default
```

Scroll down to the line where you have something similar to the following:

```
#location ~ \.php$ {
#	fastcgi_split_path_info ^(.+\.php)(/.+)$;
# NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
#
#	# With php5-cgi alone:
#	fastcgi_pass 127.0.0.1:9000;
#	# With php5-fpm:
#	#fastcgi_pass unix:/var/run/php5-fpm.sock;
#	fastcgi_index index.php;
#	include fastcgi_params;
#}
```

Then uncomment the lines that are necessary to make PHP work:

```
location ~ \.php$ {
fastcgi_split_path_info ^(.+\.php)(/.+)$;
# NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
#
#	# With php5-cgi alone:
	fastcgi_pass 127.0.0.1:9000;
#	# With php5-fpm:
#	#fastcgi_pass unix:/var/run/php5-fpm.sock;
	fastcgi_index index.php;
	include fastcgi_params;
}
```

Save the changes and restart php5-fpm and Nginx:

```
sudo service php5-fpm restart
nginx -s reload
```

You can now request a PHP file from Nginx.

###Conclusion

You've learned how to serve up web pages using the following http servers:

- SimpleHTTPServer
- PHP Server
- Apache HTTP Server
- Nginx

Web Servers are flexible by default. They can serve up different types of content and they can also serve up interpreted language such as PHP. You can pretty much live with the just the defaults but if your web project is something that's used by many people across the world then its important that you configure your web server to accommodate the needs of every user. And that is to be able to access your website fast and securely.   

###Resources

- [Simple HTTP Server](http://docs.python.org/2/library/simplehttpserver.html)
- [PHP Built-in Web Server](http://www.php.net/manual/en/features.commandline.webserver.php)
- [Apache HTTP Server](http://httpd.apache.org/docs/)
- [Nginx](http://nginx.org/en/docs/