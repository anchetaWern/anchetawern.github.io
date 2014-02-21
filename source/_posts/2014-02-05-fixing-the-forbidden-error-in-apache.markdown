---
layout: post
title: "Fixing the Forbidden Error in Apache"
date: 2014-02-05 11:33
comments: true
categories: [apache, quick-tip]
published: true
---


Every time I reformat my machine I always seem to be stuck with the forbidden error in Apache when changing the default web directory. But that ends today since I'm going to share the solution that works for me. 

<!-- more -->

First you have to edit the `apache2.conf` file which is stored in the following directory:

```
/etc/apache2
```

Open up the file with elevated privileges by executing the following command:

```
sudo gedit apache2.conf
```

Then look for the default web directory which is in most cases is `/var/www`. When you look at the file it looks something like this:

```
<Directory /var/www>
	...
	...
	...
</Directory>
```

Now change it to your preferred location. For me its in the `web_files` directory inside `/home/wern`. Also change the directives to follow symbolic links and use multiviews, also set the `AllowOverride` option to `All` so `.htaccess` files can override the default options. Then set the `Order` option to `allow,deny` so that the allow directives would be evaluated first before the deny directives. Lastly, set to `allow from all` option to allow access from all hosts:

```
<Directory /home/wern/web_files>
	Options FollowSymLinks MultiViews
    AllowOverride All
    Order allow,deny
    allow from all
</Directory>
```

Next edit the the `000-default.conf` file inside the `etc/apache2/sites-available` directory and add the same directives that we added on the `apache2.conf` file:

```
DocumentRoot /home/wern/web_files
<Directory />
    Options FollowSymLinks
    AllowOverride None
</Directory>
<Directory /home/wern/web_files>
    Options FollowSymLinks
    AllowOverride All
    order allow,deny
    allow from all
</Directory>
```

Next enable the Apache `userdir` module by executing the following command in the terminal:

```
sudo  a2enmod userdir
```

Make the necessary changes on the `/etc/apache2/mods-enabled/userdir.conf` file by changing the directory path to your desired web directory:

```
<IfModule mod_userdir.c>
	UserDir web_files
	UserDir disabled root

	<Directory /home/wern/web_files>
		AllowOverride FileInfo AuthConfig Limit Indexes
		Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
		<Limit GET POST OPTIONS>
			Require all granted
		</Limit>
		<LimitExcept GET POST OPTIONS>
			Require all denied
		</LimitExcept>
	</Directory>
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
```

Finally, open up the `/etc/apache2/mods-enabled/php5.conf` file and comment out the following lines by adding the pound sign (#) right before each line:

```
#<IfModule mod_userdir.c>
#    <Directory /home/*/public_html>
#        php_admin_value engine Off
#    </Directory>
#</IfModule>
```

To apply your changes to the current Apache instance simply restart the service:

```
sudo service apache2 restart
```

If this doesn't work make sure that your file permissions are ok, then restart Apache:

```
sudo chmod -R 755 /home/wern/web_files
```
