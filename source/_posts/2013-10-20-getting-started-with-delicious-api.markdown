---
layout: post
title: "Getting Started with Delicious API"
date: 2013-10-20 13:17
comments: true
categories: [delicious-api, api, php]
published: true
---

In this article I'll be showing you how to get the links that you have bookmarked using Delicious using the Delicious API.

The Delicious API unlike other Web API's that's using either OAuth, OAuth2 or their custom Authentication method is using [Basic Access Authentication](http://en.wikipedia.org/wiki/Basic_access_authentication). This means that performing API calls requires the username and the password of the user whose bookmarks you want to have access to.
This means that there's no confidentiality with this Authentication method. Without you knowing, the application that's going to do the talking with the Delicious API can just save your username and password in a database and the developers can have access to the links that you've bookmarked in your account whether public or private. So as a user its recommended that you only bookmark links that doesn't contain any confidential or classified information.


###Delicious Class

First let's go ahead and create the class that we will be using to access the Delicious API. Let's name it `class.delicious.php`. Then declare the 4 private variables that we will be using throughout the class:

```php
<?php
class delicious{

    private $curl;
    private $curl_options; //options that will be used for curl
    private $username; //delicious username
    private $password; //delicious password
?>
```

The constructor will accept 2 arguments, the delicious username and password. We'll also initialize `curl` so we don't have to initialize it on every method call.

```
<?php
public function __construct($username, $password){

    $this->username = $username;
    $this->password = $password;
    $this->curl = curl_init();
}
?>
```

Next, create the `set_options()` method. This method will simply set the curl options.

```
<?php
public function set_options(){
    $this->curl_options = array(
        CURLOPT_RETURNTRANSFER => 1, //return the response from the delicious API.
        CURLOPT_SSL_VERIFYPEER => false, //disable verification of the peer's certificate 
        CURLOPT_USERPWD => $this->username . ':' . $this->password //set the username and password to be used for authentication
    );
}
?>
```

Next is the `execute()` method. This method is called from every method calls that are responsible for calling a specific method from the API. What it does is to assign the curl options to the curl object, executes it and then returns the response.

```
<?php
public function execute(){
    curl_setopt_array($this->curl, $this->curl_options);

    $response = curl_exec($this->curl);
    if(!$response){
    	//terminate the execution of the script if there's no response
        die('Error: "' . curl_error($this->curl) . '" - Code: ' . curl_errno($this->curl));
    }
    curl_close($this->curl); //close the connection              
    return $response;
}
?>
```

####Getting all Bookmarks

We can now create the methods for actually getting the bookmarks. The first method that we will create is the `get_all()` method. As the name suggests, the `get_all()` method simply gets everything that you have ever bookmarked on your delicious account. This might take some time to execute depending on the number of links that you have bookmarked. 

```
<?php
public function get_all(){

    $this->set_options();
    $this->curl_options[CURLOPT_URL] = 'https://api.del.icio.us/v1/posts/all';
    $response = $this->execute();
    $xml = simplexml_load_string($response); //converts the string response into an xml object      
    return $xml;
}
?>
```

Before we proceed with the next method, I'd like you to take a few minutes to observe what were doing here. 
Because the pattern that we've used here will be used on other methods that we will be creating later.

As you can see, were calling the `set_options()` method to set the arguments that will be needed for the request.

```
<?php
$this->set_options();
?>
```

Next, we set the main URL that were requesting from. In this cae were requesting the `https://api.del.icio.us/v1/posts/all` url. At the time of writing of this article, the main request url is `https://api.del.icio.us` The version of the API is `v1` and the method is `posts/all`. You can see the full list of API methods that you can call [here](https://github.com/avos/delicious-api/blob/master/APIs.md).

```
<?php
$this->curl_options[CURLOPT_URL] = 'https://api.del.icio.us/v1/posts/all';
?>
```

Next, we execute the request. The `execute()` method returns the response from the API. The response is basically in string format so we have to process it further to really get into the details that we want.

```
<?php
$response = $this->execute();
?>
```

In order to do that we call the `simplexml_load_string()` method. It's a built-in PHP method which you can call to convert a string response into an XML object. You can read more about it [here](http://php.net/manual/en/function.simplexml-load-string.php).

```
<?php
$xml = simplexml_load_string($response);
?>
```

After converting the response to an XML object, we simply return it.

```
<?php
return $xml;
?>
```


####Getting Bookmarks by Tag

We can also get bookmarks by tag name. All we have to do is to specify the `tag` argument to the `posts/all` method and supply a url encoded value as the query.

```
<?php
public function get_by_tag($tag){

    $this->set_options();
    $request_url = 'https://api.del.icio.us/v1/posts/all?tag=' . urlencode($tag);
    $this->curl_options[CURLOPT_URL] = $request_url;
    $response = $this->execute();
    $xml = simplexml_load_string($response);        
    return $xml;
}
?>
```

####Getting Bookmarks by Offset

We can also get by a certain limit and offset. All we have to do is supply a value for the `start` argument (offset), and the `results` argument (limit).

```
<?php
public function get_by_offset($start, $limit){

    $this->set_options();
    $request_url  = 'https://api.del.icio.us/v1/posts/all?start=' . $start;
    $request_url .= '&results=' . $limit;
    $this->curl_options[CURLOPT_URL] = $request_url;
    $response = $this->execute();        
    $xml = simplexml_load_string($response);        
    return $xml;
}
?>
```


####Getting Recently Bookmarked Links

Recently bookmarked links can also be fetched from the API. The method to be used is the `posts/recent` method.
You can also supply an optional `tag` or `count` argument.

```
<?php
public function get_recent($tag = '', $count = 1){

    $this->set_options();
    $request_url  = 'https://api.del.icio.us/v1/posts/recent?';
    if(!empty($tag)){ //limit results by tag
    	$request_url .= 'tag=' . urlencode($tag);
    }

    if(!empty($count)){ //limit results by bookmark count
    	$request_url .= '&count=' . $count;
    }
    $this->curl_options[CURLOPT_URL] = $request_url;
    $response = $this->execute();
    $xml = simplexml_load_string($response);        

    return $xml;
}
?>
```


####Bookmarking Links

Bookmarking new links can also be done from the API. The method to be used is the `posts/add` method.
The `url` argument is required and you can also set an optional `description` or `tags`. If there are more than one tags you can separate them using a comma (E.g php, web-development)

```
<?php
public function add($url, $description = '', $tags = ''){

    $this->set_options();
    $request_url  = 'https://api.del.icio.us/v1/posts/add?';
    $request_url .= 'url=' . urlencode($url);
    $request_url .= '&description=' . urlencode($description);
    $request_url .= '&tags=' . urlencode($tags);

    $this->curl_options[CURLOPT_URL] = $request_url;
    $this->execute();
}
?>
```

####Deleting Bookmarks

You can also delete links that were previously bookmarked. The request method is `posts/delete`. 
You have to pass in the `url` of the link that you wish to delete.

```
<?php
public function delete($url){

	$this->set_options();
	$this->curl_options[CURLOPT_URL] = 'https://api.del.icio.us/v1/posts/delete?url=' . $url;
	$this->execute();

}
?>
```

There are a bunch of other methods which you can use so be sure to check out the Delicious API documentation.


###Using the Class

```
<?php
<?php
require_once('class.delicious.php');

$username = 'XYZ';
$password = 'secret';

$deli = new Delicious($username, $password);

$links = $deli->get_by_tag('php');

foreach($links->post as $row){
?>
	<li><?php echo $row['href']; ?></li>
<?php	
}
?>
```



###Resources

- [Delicious API](https://github.com/avos/delicious-api/blob/master/APIs.md)
- [Delicious-PHP](https://github.com/anchetaWern/delicious-php) - a little PHP class that I created for interacting with the Delicious API