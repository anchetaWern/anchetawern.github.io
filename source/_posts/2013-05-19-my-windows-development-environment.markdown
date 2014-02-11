---
layout: post
title: "My Windows Development Environment"
date: 2013-05-19 15:37
comments: true
categories: [windows, development-environment]
published: true
---

In this article I'm going to share some of the applications and development tools that I install on my Windows machine.

<!--More-->

###HeidiSQL

HeidiSQL is a database manager for MySQL and MSSQL Databases. 
[Download](http://www.heidisql.com/)



###Peazip

Not really a development tools but its useful for extracting archives for software packages. 
[Download](http://peazip.sourceforge.net/)


###PHP

PHP is a server-side scripting language that I currently use to take care of the back-end stuff for the web applications that I build.

[Download](http://php.net/downloads.php)


###MySQL

MySQL is a database management system commonly used with PHP to build dynamic web applications. 

[Download](http://dev.mysql.com/downloads/)


###Apache

Apache is an HTTP Server used to access the PHP applications from the browser.

[Download](http://httpd.apache.org/download.cgi)


###CURL

CURL is a command line tool for transferring data using the FTP or HTTP protocol. I commonly use it to install packages which uses CURL. For Windows users the latest file under the Win32 - Generic section should be downloaded.

[Download](http://curl.haxx.se/download.html)


###Chrome Canary

To get access and play around with the most cutting edge stuff in Google's Chrome browser I always use the Canary Build. It's a very useful tool to learn which features will be coming to the future versions of the Chrome Developer tools.

[Download](https://www.google.com/intl/en/chrome/browser/canary.html)


###Chrome Plugins

I also use some plugins to further improve my productivity when using the Chrome Browser.

- [MeasureIt](https://chrome.google.com/webstore/detail/measureit/pokhcahijjfkdccinalifdifljglhclm)
- [JSONView](https://chrome.google.com/webstore/detail/chklaanhfefbnpoihckbnefhakgolnmc)
- [PageSpeed Insights](https://chrome.google.com/webstore/detail/pagespeed-insights-by-goo/gplegfbjlmmehdoakndmohflojccocli)
- [EyeDropper](https://chrome.google.com/webstore/detail/eye-dropper/hmdcmlfkchdmnmnmheododdhjedfccka)


###Octopress

Octopress is a framework built on top of the Jekyll static site generator. I use it on my blog so I also consider it a s a development tool.

[Download](http://octopress.org/)


###Ruby

When I need a break from PHP I also play with Ruby. I use the installer from rubyinstaller.org to install ruby on my machine.

[Download](http://rubyinstaller.org/)


###Node.js

I haven't really played around with Node.js because I only have it installed on my machine to have access to the Node Package Manager which I can use to install development tools like Coffeescript, Bower, Hogan.js, and Grunt.


[Download](http://nodejs.org/download/)



###Chocolatey

Chocolatey is a package manager for Windows much like the `apt-get` that we use on linux distributions like Ubuntu or Linux Mint. Chocolatey can be installed by simply pasting the following commands in the command-line.

```
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%systemdrive%\chocolatey\bin
```

After that you can just paste in commands to install applications on your machine. So for example if you want to install notepad++ you simply execute the following command:

```
cinst notepadplusplus
```

Or if you want Sublime Text 2 instead:

```
cinst sublimetext2
```

Nice and easy!

[Download](http://chocolatey.org/)


###Sublime Text 2

Yes I also use Sublime Text just like many of us. It's like the text-editor of the century. I believe I won't switch to any text-editor soon.

[Download](http://www.sublimetext.com/2)


###Sublime Text 2 Packages

Sublime Text 2 is already awesome but its even more awesome with some packages installed.
To install packages you must first install the package manager. You can do that by executing the following command in the Sublime Text console. You can access the console by pressing ctrl + `:

```
import urllib2,os; pf='Package Control.sublime-package'; ipp=sublime.installed_packages_path(); os.makedirs(ipp) if not os.path.exists(ipp) else None; urllib2.install_opener(urllib2.build_opener(urllib2.ProxyHandler())); open(os.path.join(ipp,pf),'wb').write(urllib2.urlopen('http://sublime.wbond.net/'+pf.replace(' ','%20')).read()); print('Please restart Sublime Text to finish installation')
```

Here are some of the packages that I currently have on Sublime Text:

- [Alignment](https://github.com/wbond/sublime_alignment)
- [Clipboard History](https://github.com/kemayo/sublime-text-2-clipboard-history)
- [Bracket Highlighter](https://github.com/facelessuser/BracketHighlighter)
- [Dayle Rees Color Schemes](https://github.com/daylerees/colour-schemes)
- [DocBlockr](https://github.com/spadgos/sublime-jsdocs)
- [Emmet](http://emmet.io/)
- [PHPTidy](https://github.com/welovewordpress/SublimePhpTidy)
- [SidebarEnhancements](https://github.com/titoBouzout/SideBarEnhancements)


If you want more sublime text 2 goodness you can check out Alex Maccaw's article: [Setting Up Sublime Text 2](http://blog.alexmaccaw.com/sublime-text) or Drew Barontini's [Sublime Text 2 Setup](http://drewbarontini.com/setup/sublime-text/)

[Package Control Installation](http://wbond.net/sublime_packages/package_control/installation)


###Git

Git is a version control software which I primarily use to keep track of the changes and to push to a remote repository for the projects that I'm working on.

[Download](http://git-scm.com/)


###Wordpress

Wordpress is a content management system that I used for the past few months to create plugins for. It's built on top of PHP and uses MySQL as its database.

[Download](http://wordpress.org)


###POEdit

POEdit is a cross-platform gettext catalogs editor. I use it to easily create translations for Wordpress plugins. The way it works is simple, you simply open the file that you want to create translations for and it will automatically scan it for the groups of text which are wrapped in `__('')` and `_e()`. After that you can just use Google translate to translate the text that its lists out.

[Download](http://www.poedit.net/)


###Everything

Not really a development tool but its a very useful software for quickly finding and opening files that I want to edit.

[Download](http://www.voidtools.com/)


###Composer

Composer is like the NPM equivalent for PHP. It's also a package manager used for installing different tools for PHP.
You have 3 options if you want to install it on Windows. First is using CURL:

```
curl -sS https://getcomposer.org/installer | php
```

Another is by simply creating a new PHP file and putting the following code then execute it.

```
php -r "eval('?>'.file_get_contents('https://getcomposer.org/installer'));"
```

The third option is by using the [Windows installer](http://getcomposer.org/Composer-Setup.exe)

Once you're done installing Composer you can go ahead and search from the [packagist](https://packagist.org/) site to search for some packages. In the screenshot below we have the `eher/phpunit` package. You can see all the information regarding its requirements, suggestions and conflicts be sure to read it before trying to install anything.

![package](/images/posts/windows_dev_environment/php_unit.PNG)

You can install packages by simply copying the string under the `dev-master` or the top-level section. In the example above we have `"eher/phpunit": "dev-master"`. Just wrap it in curly braces and put in the `require` property.

```
{	
  "require": {
      "eher/phpunit": "dev-master"
  }
}
```

After that just save the file as `composer.json` and then execute `composer install` on the same directory where you have that file. It may take a while depending on the package so be patient and don't close the command-line.
If the package that you installed can be executed from the command-line simply add it to the environment variables so that you can easily execute it from the command-line regardless of the path where you are currently in.

[Download](http://getcomposer.org/download/)
