---
layout: post
title: "How to perform cross-domain AJAX requests"
date: 2013-10-24 18:30
comments: true
categories: [ajax, jquery, php, quick-tip]
published: true
updated: 2014-07-12
---

In this article I'm going to show you how you can perform cross-domain AJAX requests.

<!-- more -->

When making AJAX requests you would normally do something like this:

```javascript
$.get('http://xyz.com/get_data', {'data' : 'abc'}, function(response){
	//do something with the response
});
```

But if you're making the request from a domain different than the current domain your script is being called then it wouldn't work.

####JSONP

The first method if via JSONP. If you have control over the code that returns the response that you need, all you need to do is to convert the data that you're returning to JSON string and then wrap it up with a function call. Here's an example:

```php
<?php
$data = array('fname' => 'haru', 'lname' => 'tora');
echo "parse_results(" . json_encode($data) . ")";
?>
``` entry_title

When calling the method from `abc.com` all you have to do is to use the `$.getJSON()` method and declare the same function that you used on `xyz.com`. In this case the name of the function is `parse_results()`:

```javascript
function parse_results(response){
	//do something with the response
}

$.getJSON('http://xyz.com/get_data', {'data' : 'abc'});
```

You can also use the more robust `$.ajax()` method if you want:

```
function parse_results(response){
	//do something with the response
}

$.ajax({
	url : 'http://xyz.com/get_data',
	type : 'GET',
	dataType: 'jsonp',
	data : {
		'data' : 'abc'
	}
});
```

####CSS HTTP Request

If the first method doesn't work for you. You can also use the [csshttprequest](https://github.com/nbio/csshttprequest) library. What this library does is to convert the data that you're passing to another server to something similar to css. Css isn't subjected to the same domain origin policy so this works. The only downside is that you can only send `GET` requests:

```
CSSHttpRequest.get(
    "http://somewhere/in/the/interwebs",
    function(response){ 
		//do something with the response
    }
);
```

If you want to pass in arguments:

```
var title = $('#title').val();

CSSHttpRequest.get(
    "http://somewhere/in/the/interwebs?title=" + title,
    function(response){ 
		//do something with the response
    }
);
```

####Enable Cross Origin Resource Sharing

Lastly if you have access to the server you are making the request to then you can just enable cross domain resource sharing or CORS. There's a whole [website](http://enable-cors.org/index.html) dedicate to it. And instructions on how you can set it up on the [server](http://enable-cors.org/server.html). If you are using PHP its as simple as setting the following header information:

```php
<?php
header("Access-Control-Allow-Origin: *");
?>
```

Note that the code above tells the client (browser) that the resource returned is available to all. Which means that the request can be made from any server and the browser would happily utilize the returned data. If you do not want that then you can also specify a specific domain from which access is allowed:

```
<?php
header("Access-Control-Allow-Origin: http://my-awesomesite.com");
?>
```

