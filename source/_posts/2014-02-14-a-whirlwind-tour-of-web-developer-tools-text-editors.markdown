---
layout: post
title: "A whirlwind Tour of Web Developer Tools: Text Editors"
date: 2014-02-15 11:00
comments: true
categories: [text-editors, web-development, tools]
published: true
updated: 2014-03-02
---

This is part two of the series A Whirlwind Tour of Web Developer Tools. This time I'll be talking about text editors and related tools.

Text editors are used by web developers to write code. Text editors are not the same thing as word processors because anything written on a text editor is saved as a plain text file and it normally uses a simple character set such as ASCII to represent different characters (letters, numbers, etc). On the other hand word processors saves formatted text which enables tables, symbols and other form of graphical information to be represented without having to use any form of markup like HTML.

<!--more-->


####Sublime Text

When you say text editor the first thing that comes to mind these days is [Sublime Text](http://www.sublimetext.com/). It's like the sexiest text editor these days. So this whole blog post is primarily going to be about Sublime Text and some of the plugins that I found useful.


#####Plugins

In order to install plugins for Sublime Text you first have to install [package control](https://sublime.wbond.net/) which is a package manager for Sublime Text that allows you to easily install plugins. To install package manager copy the following code in the Sublime Text console which can be accessed by pressing `ctrl + back tick` on your keyboard. After that restart the editor to finish the installation:

```
import urllib2,os,hashlib; h = '7183a2d3e96f11eeadd761d777e62404e330c659d4bb41d3bdf022e94cab3cd0'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); os.makedirs( ipp ) if not os.path.exists(ipp) else None; urllib2.install_opener( urllib2.build_opener( urllib2.ProxyHandler()) ); by = urllib2.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); open( os.path.join( ipp, pf), 'wb' ).write(by) if dh == h else None; print('Error validating download (got %s instead of %s), please try manual install' % (dh, h) if dh != h else 'Please restart Sublime Text to finish installation')
```

Note that the code above is for Sublime Text 2, if you're using Sublime Text 3 then use the following code:

```
import urllib.request,os,hashlib; h = '7183a2d3e96f11eeadd761d777e62404e330c659d4bb41d3bdf022e94cab3cd0'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)
```

After restarting sublime text you can now press `ctrl + shift + p`, select 'install package' and press `enter`, this will load all the available plugins from the plugin repository. From there you can just search for the plugin that you want to install. 

And now for the plugins:

- [PHPCS](https://github.com/benmatselby/sublime-phpcs) - a PHP code quality tool.
- [Emmet](http://emmet.io/) - previously known as Zen Coding. If that doesn't ring a bell then Emmet is basically a tool for improving productivity by implementing shortcuts for generating code that you would normally write out by hand. All you have to do is to write something like this:

```
html:5
```

And right after pressing `tab` you get a whole bunch of code written out for you:

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Document</title>
</head>
<body>
	
</body>
</html>
```

- [Sidebar Enhancements](https://github.com/titoBouzout/SideBarEnhancements) - allows you to create a new file and it will immediately ask you the filename, duplicating or copying files and folders from the sidebar, and a bunch of other good stuff that the default sublime text sidebar doesn't allow you to do. 
- [Bracket Highlighter](https://github.com/facelessuser/BracketHighlighter) - allows for easier visualization of where the ending bracket is.
- [Clipboard History](https://github.com/kemayo/sublime-text-2-clipboard-history) - keeps a history of clipboard items so you can just paste them in later.
- [Docblockr](https://github.com/spadgos/sublime-jsdocs) - pretty much like emmet but only for document blocks. Useful for writing comments.
- [Alignment](https://github.com/wbond/sublime_alignment) - allows for easy alignment of code. All you have to do is press `ctrl + alt + a` on your keyboard.
- [Sublime Linter](https://github.com/SublimeLinter/SublimeLinter-for-ST2) - inline linting for a bunch of languages (PHP, HTML, CSS, Ruby, etc). If you don't know what linting is, its basically a process of analyzing code to determine potential errors. In most cases its used by web developers to check their code quality against a specific coding standard. For example, when coding in JavaScript its not usually required to put semi-colons but if you're using Sublime linter it will remind you to put those semi-colons in if you forget it. If you have unused variables in your code the linter will also complain and it will tell you that variable `z` isn't actually used in your code.
- [EditorConfig](https://github.com/sindresorhus/editorconfig-sublime) - tool for implementing coding conventions. You can use this to specify whether to use tabs or spaces for specific file types (`.js`, `.css`) or whether to use double quotes or single quotes for the quote type. You can do all that by installing the editorconfig plugin for the text editor that you're using. Then create a `.editorconfig` file in the root of your project directory or any directory in your project if you want to use different rules for different directories. Here's a sample `.editorconfig` file:

```
root = true

[*]
end_of_line = lf
insert_final_newline = false
charset = utf-8
trim_trailing_whitespace = true
quote_type = double

[*.php]
indent_style = space
indent_size = 4

[*.py]
indent_style = space
indent_size = 4

[*.js]
indent_style = space
indent_size = 2

[*.css]
indent_style = space
indent_size = 5
```

As you can see from the sample above you can specify a whole bunch of settings. You can also have different rules for different file types.

####IDE

There's also this thing called the IDE or Integrated Development Environment which is basically text editors on steroids. They have huge install size since they allow you to do more than just writing code. IDE's packs a bunch of features which you would not normally find in a text editor such as compiling code. Some IDE's such as Visual Studio also allows you to build the GUI of applications by simply dragging and dropping GUI elements (text boxes, buttons, etc.) from a toolbox. Other features include code completion (intellisense), debugger, integrated services (allows viewing and manipulating the database right from the IDE).


###Conclusion

Text editors and IDEs are the main weapons of every web developer. Without it they won't be able to produce any code. So its important to learn the ins and outs of the text-editor or IDE that you are using to maximize your productivity when using it. Be sure to check out the resources below for more Sublime Text awesomeness.

###Resources

- [Sublime Text Tips and Tricks](http://www.hongkiat.com/blog/sublime-text-tips/)
- [Perfect Workflow in Sublime Text 2](https://tutsplus.com/course/improve-workflow-in-sublime-text-2/)
- [Popular Sublime Text Plugins](https://sublime.wbond.net/browse/popular)
- [Compariosn of Text Editors](http://en.wikipedia.org/wiki/Comparison_of_text_editors)
- [Comparison of Integrated Development Environments](http://en.wikipedia.org/wiki/Comparison_of_integrated_development_environments)