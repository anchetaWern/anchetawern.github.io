---
layout: post
title: "Playing with Emmet"
date: 2012-11-24 10:57
comments: true
categories: ['sublime-text plugins', 'tools']
published: true
---

The next generation ZenCoding has been released recently so I tried to play with it as soon as I had the time.
Just to give a bit of a background ZenCoding is a plugin for most text-editors that is used for faster generation
of html and css code. Emmet is like the next level of it, smarter and more powerful.

You can install Emmet through the [Sublime Text 2 package manager](http://wbond.net/sublime_packages/package_control)
which isn't included in Sublime text by default at the time of writing of this blog post.

I'm on Windows so I had to press ```ctrl+shift+p``` on the keyboard to bring out the command pallete then search for ```install``` then press ```enter```
which loads the sublime text plugins. Once that's done go ahead and hit ```ctrl+shift+p``` again then press ```enter```
which then brings out the packages that are currently on package control. Search for ```emmet``` remember to uninstall ```Zen Coding``` before trying to use
Emmet because it will most likely have some conflicts with emmet. 
To uninstall ZenCoding just go to the ```Data\Packages``` directory in sublime and look for the zencoding folder then delete it.

Once that's done were ready to play with Emmet.

If you're familiar with ZenCoding and CSS selectors there's pretty much Zero learning curve when using Emmet
because the syntax is almost the same.

####Syntax

```javascript
.dog //can expand to any element with the class of dog

#cat //can expand to any element with the id of cat depending on context

p.imaparagraph //expands to: <p class="imaparagraph"></p>

p{text inside paragraph} //expands to: <p>text inside paragraph</p>
```


####Tag Names

I've noticed that Emmet is smarter than ZenCoding (or maybe I just haven't noticed this while using ZenCoding)
When expanding an abbreviation which doesn't specify the element to be used Emmet does some magic in 
determining which element should be used by checking out the elements inside the block where its written.
For example if the sibling that came before it is a div then its also going to expand as a div:

```html
 <body>
    <div class="row">
	</div>
	#imadiv //expands to: <div id="imadiv"></div>
 </body>
```

But when the abbreviation is inside a ```<ul>``` element it simply uses the ```<li>``` tag:

```
  <ul>
    <li></li>
	.what_am_i //expands to: <li class="what_am_i"></li>
  </ul>
```

The default element in which it expands to if it can't determine which element should be used is either ```<span>``` or ```<div>```


####Abbreviations

Checkout the ```snippets.json``` file for the abbreviations and their corresponding values:

```
"abbreviations": {
	"!": "html:5",
	"a": "<a href=\"\">",
	"a:link": "<a href=\"http://|\">",
	"a:mail": "<a href=\"mailto:|\">",
	"abbr": "<abbr title=\"\">",
	"acronym": "<acronym title=\"\">",
	"base": "<base href=\"\" />",
	"bdo": "<bdo dir=\"\">",
	"bdo:r": "<bdo dir=\"rtl\">",
	"bdo:l": "<bdo dir=\"ltr\">",
	"link": "<link rel=\"stylesheet\" href=\"\" />",
	"link:css": "<link rel=\"stylesheet\" href=\"${1:style}.css\" media=\"all\" />",
	"link:print": "<link rel=\"stylesheet\" href=\"${1:print}.css\" media=\"print\" />",
	"link:favicon": "<link rel=\"shortcut icon\" type=\"image/x-icon\" href=\"${1:favicon.ico}\" />",
	"link:touch": "<link rel=\"apple-touch-icon\" href=\"${1:favicon.png}\" />",
	"link:rss": "<link rel=\"alternate\" type=\"application/rss+xml\" title=\"RSS\" href=\"${1:rss.xml}\" />",
	"link:atom": "<link rel=\"alternate\" type=\"application/atom+xml\" title=\"Atom\" href=\"${1:atom.xml}\" />",
	"meta:utf": "<meta http-equiv=\"Content-Type\" content=\"text/html;charset=UTF-8\" />",
	"meta:win": "<meta http-equiv=\"Content-Type\" content=\"text/html;charset=windows-1251\" />",
	"meta:compat": "<meta http-equiv=\"X-UA-Compatible\" content=\"${1:IE=7}\" />",
	"style": "<style>",
	"script": "<script>",
	"script:src": "<script src=\"\">",
	"img": "<img src=\"\" alt=\"\" />",
	"iframe": "<iframe src=\"\" frameborder=\"0\">",
	"embed": "<embed src=\"\" type=\"\" />",
	"object": "<object data=\"\" type=\"\">",
	"param": "<param name=\"\" value=\"\" />",
	"map": "<map name=\"\">",
	"area": "<area shape=\"\" coords=\"\" href=\"\" alt=\"\" />",
	"area:d": "<area shape=\"default\" href=\"\" alt=\"\" />",
	"area:c": "<area shape=\"circle\" coords=\"\" href=\"\" alt=\"\" />",
	"area:r": "<area shape=\"rect\" coords=\"\" href=\"\" alt=\"\" />",
	"area:p": "<area shape=\"poly\" coords=\"\" href=\"\" alt=\"\" />",
	"form": "<form action=\"\">",
	"form:get": "<form action=\"\" method=\"get\">",
	"form:post": "<form action=\"\" method=\"post\">",
	"label": "<label for=\"\">",
	"input": "<input type=\"\" />",
	"input:hidden": "<input type=\"hidden\" name=\"\" />",
	"input:h": "<input type=\"hidden\" name=\"\" />",
	"input:text": "<input type=\"text\" name=\"\" id=\"\" />",
	"input:t": "<input type=\"text\" name=\"\" id=\"\" />",
	"input:search": "<input type=\"search\" name=\"\" id=\"\" />",
	"input:email": "<input type=\"email\" name=\"\" id=\"\" />",
	"input:url": "<input type=\"url\" name=\"\" id=\"\" />",
	"input:password": "<input type=\"password\" name=\"\" id=\"\" />",
	"input:p": "<input type=\"password\" name=\"\" id=\"\" />",
	"input:datetime": "<input type=\"datetime\" name=\"\" id=\"\" />",
	"input:date": "<input type=\"date\" name=\"\" id=\"\" />",
	"input:datetime-local": "<input type=\"datetime-local\" name=\"\" id=\"\" />",
	"input:month": "<input type=\"month\" name=\"\" id=\"\" />",
	"input:week": "<input type=\"week\" name=\"\" id=\"\" />",
	"input:time": "<input type=\"time\" name=\"\" id=\"\" />",
	"input:number": "<input type=\"number\" name=\"\" id=\"\" />",
	"input:color": "<input type=\"color\" name=\"\" id=\"\" />",
	"input:checkbox": "<input type=\"checkbox\" name=\"\" id=\"\" />",
	"input:c": "<input type=\"checkbox\" name=\"\" id=\"\" />",
	"input:radio": "<input type=\"radio\" name=\"\" id=\"\" />",
	"input:r": "<input type=\"radio\" name=\"\" id=\"\" />",
	"input:range": "<input type=\"range\" name=\"\" id=\"\" />",
	"input:file": "<input type=\"file\" name=\"\" id=\"\" />",
	"input:f": "<input type=\"file\" name=\"\" id=\"\" />",
	"input:submit": "<input type=\"submit\" value=\"\" />",
	"input:s": "<input type=\"submit\" value=\"\" />",
	"input:image": "<input type=\"image\" src=\"\" alt=\"\" />",
	"input:i": "<input type=\"image\" src=\"\" alt=\"\" />",
	"input:reset": "<input type=\"reset\" value=\"\" />",
	"input:button": "<input type=\"button\" value=\"\" />",
	"input:b": "<input type=\"button\" value=\"\" />",
	"select": "<select name=\"\" id=\"\"></select>",
	"option": "<option value=\"\"></option>",
	"textarea": "<textarea name=\"\" id=\"\" cols=\"${1:30}\" rows=\"${2:10}\">",
	"menu:context": "<menu type=\"context\">",
	"menu:c": "<menu type=\"context\">",
	"menu:toolbar": "<menu type=\"toolbar\">",
	"menu:t": "<menu type=\"toolbar\">",
	"video": "<video src=\"\">",
	"audio": "<audio src=\"\">",
	"html:xml": "<html xmlns=\"http://www.w3.org/1999/xhtml\">",
	
	"bq": "blockquote",
	"acr": "acronym",
	"fig": "figure",
	"figc": "figcaption",
	"ifr": "iframe",
	"emb": "embed",
	"obj": "object",
	"src": "source",
	"cap": "caption",
	"colg": "colgroup",
	"fst": "fieldset",
	"btn": "button",
	"optg": "optgroup",
	"opt": "option",
	"tarea": "textarea",
	"leg": "legend",
	"sect": "section",
	"art": "article",
	"hdr": "header",
	"ftr": "footer",
	"adr": "address",
	"dlg": "dialog",
	"str": "strong",
	"prog": "progress",
	"fset": "fieldset",
	"datag": "datagrid",
	"datal": "datalist",
	"kg": "keygen",
	"out": "output",
	"det": "details",
	"cmd": "command",
	
	"ol+": "ol>li",
	"ul+": "ul>li",
	"dl+": "dl>dt+dd",
	"map+": "map>area",
	"table+": "table>tr>td",
	"colgroup+": "colgroup>col",
	"colg+": "colgroup>col",
	"tr+": "tr>td",
	"select+": "select>option",
	"optgroup+": "optgroup>option",
	"optg+": "optgroup>option"
}
```

As you can see its geared towards html5:

```
! //expands to a basic html template with the html5 doctype (sweet!)

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

And they've already removed the ```type``` attribute for ```<script>``` and ```<style>``` tags as well (double sweet!!)

Specifying input types using colon (triple sweet!!!):

```
input:text //expands to <input type="text" name="" id="">

```

And when you press tab it automatically goes inside the name and id for you to specify the values for those attributes (How cool is that?)

I remember having done this in ZenCoding like:
```
input[type=text]
```

That saves my fingers from typing 6 more characters for every form input.

The good thing is that you can customize these abbreviations the way you want it. 
You can definitely save your fingers from typing some characters by specifying shorter abbreviations. 
But remember not to sacrifice readability and memorizability (does that word exists? sorry grammar natzis, please don't kill me).
But its probably ok to have abbreviations like 	```i:t``` or ```i:r``` or ```i:c``` if you can remember what they mean after an hour.

You can even add your own snippets (if you're not a fan of the default feature in sublime text for storing code snippets). 
Here are some of the default snippets that are available in Emmet (mostly doctypes and code for dealing with ie6).

```
"snippets": {
			"c": "<!-- |${child} -->",
			"cc:ie6": "<!--[if lte IE 6]>\n\t${child}|\n<![endif]-->",
			"cc:ie": "<!--[if IE]>\n\t${child}|\n<![endif]-->",
			"cc:noie": "<!--[if !IE]><!-->\n\t${child}|\n<!--<![endif]-->",
			"html:4t": "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\n<html lang=\"${lang}\">\n<head>\n\t<meta http-equiv=\"Content-Type\" content=\"text/html;charset=${charset}\">\n\t<title>${1:Document}</title>\n</head>\n<body>\n\t${child}${2}\n</body>\n</html>",
			"html:4s": "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">\n<html lang=\"${lang}\">\n<head>\n\t<meta http-equiv=\"Content-Type\" content=\"text/html;charset=${charset}\">\n\t<title>${1:Document}</title>\n</head>\n<body>\n\t${child}${2}\n</body>\n</html>",
			"html:xt": "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"${lang}\">\n<head>\n\t<meta http-equiv=\"Content-Type\" content=\"text/html;charset=${charset}\" />\n\t<title></title>\n</head>\n<body>\n\t${child}${2}\n</body>\n</html>",
			"html:xs": "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"${lang}\">\n<head>\n\t<meta http-equiv=\"Content-Type\" content=\"text/html;charset=${charset}\" />\n\t<title>${1:Document}</title>\n</head>\n<body>\n\t${child}${2}\n</body>\n</html>",
			"html:xxs": "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">\n<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"${lang}\">\n<head>\n\t<meta http-equiv=\"Content-Type\" content=\"text/html;charset=${charset}\" />\n\t<title>${1:Document}</title>\n</head>\n<body>\n\t${child}${2}\n</body>\n</html>",
			"html:5": "<!doctype html>\n<html lang=\"${lang}\">\n<head>\n\t<meta charset=\"${charset}\">\n\t<title>${1:Document}</title>\n</head>\n<body>\n\t${child}${2}\n</body>\n</html>"
		}
```

If you're using Zurb's Foundation or Twitter Bootstrap and you plan to use it for your future projects. 
Maybe you can store snippets to make your life easier (css frameworks are notorious at using a lot of html to have a foundation for styling):

```
"d:6c" : "<div class=\"six columns\">",
"d:10c3mc" : "<div class=\"ten mobile-three columns\">"
```


####Other Fun Stuff

Of course there's a lot more stuff that you can do in Emmet (Lorem ipsum generators, vendor prefixes) but time is limited and those cool stuff are all
in the documentation. There's also a text-editor in the site which you can play with Emmet as much as you want.

###Resources

- [Emmet](http://docs.emmet.io/)

