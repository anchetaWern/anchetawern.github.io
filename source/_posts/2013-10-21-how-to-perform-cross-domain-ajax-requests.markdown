---
layout: post
title: "How to perform cross-domain AJAX requests"
date: 2013-10-24 18:30
comments: true
categories: [ajax, jquery, php, quick-tip]
published: true
updated: 2013-02-03
---

In this article I'm going to show you how you can perform cross-domain AJAX requests.
There's really no bullet-proof method of doing this. It might work, it might not since AJAX requests should only be performed within the same domain due to security concerns.

<!-- more -->

Note that I'm not going to show how to perform an AJAX request to any domain from any domain. What I'm going to show you is how to perform an AJAX request to a different domain which you have control over the code.

For example you want to get some data via AJAX from `xyz.com`. You are making the request from `abc.com` so it wouldn't work if you do something like:

```javascript
$.get('http://xyz.com/get_data', {'data' : 'abc'}, function(response){
	//do something with the response
});
```

If you have control over the code that returns the response that you need, all you need to do is to convert the data that you're returning to JSON string and then wrap it up with a function call. Here's an example:

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

If this doesn't work you can also use the [csshttprequest](https://github.com/nbio/csshttprequest) library:

```
CSSHttpRequest.get(
    "http://somewhere/in/the/interwebs",
    function(response){ 
		//do something with the response
    }
);
```

Note that you can only use this library to pass in arguments using GET:

```
var title = $('#title').val();

CSSHttpRequest.get(
    "http://somewhere/in/the/interwebs?title=" + title,
    function(response){ 
		//do something with the response
    }
);
```

