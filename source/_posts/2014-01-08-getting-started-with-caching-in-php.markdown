---
layout: post
title: "Getting Started with Caching in PHP"
date: 2014-01-26 09:56
comments: true
categories: [php, caching]
published: true
updated: 2014-02-02
---

In this post were going to explore how to do caching in PHP. But first let's define what caching is. With a quick Google search we get these definitions:

{% blockquote %}
store away in hiding or for future use.
{% endblockquote %}

Another definition from [citrix.com](http://www.citrix.com/glossary/caching.html)

{% blockquote %}
Temporarily storing recently used information. The content, which includes HTML pages, images, files and Web objects, is stored on the local hard drive in order to make it faster for the user to access it, which helps improve the efficiency of the computer and its overall performance
{% endblockquote %}

So we now know that caching is temporarily storing information in order to improve performance.

<!-- more -->

###Caching Techniques

There are different caching methods that we can use with PHP:

- Caching content
- Memory Cache
- Database Cache


###Caching Content

We can cache content in PHP by saving the final output of a specific script into the filesystem then simply serving it like a static file for a specific period of time instead of executing the original script.

Below is an example on how to cache content on the filesystem. First we declare a variable which stores the location of the cache file, current time and the time when the cache file was last modified. Once that's done we simply check whether there is a cache file for the particular script that a visitor is currently accessing. If there is a cache file then we simply include it in the page. If not then we access the database for the content and output the HTML. Then all of the output will be stored in the cache file. [Output buffering](http://www.php.net/ob_start) is used to store all of the output in a string format so only the HTML that's outputted in the browser is going to be saved in the cache file. This means that the database access is bypassed when we load the cache file later on when a second visitor visits the site. Its like serving plain HTML, which means that it will load faster than the previous request.

```php
<?php
$file = 'cache/' . basename($_SERVER['SCRIPT_NAME']); //location of cache file
$current_time = time();
$cache_last_modified = filemtime($file); //time when the cache file was last modified

if(file_exists($file) && ($current_time < strtotime('+1 day', $cache_last_modified))){ //check if cache file exists and hasn't expired yet
	include($file); //include cache file
}else{
	ob_start(); //start output buffering
?>
	<h1>Hello World!</h1>
	
<?php
	/*
	some code accessing the database
	for some data here
	*/

	/*
	probably some complex computations here
	*/

	$fp = fopen($file, 'w'); //open cache file
	fwrite($fp, ob_get_contents()); //create new cache file
	fclose($fp); //close cache file
	ob_end_flush(); //flush output buffered
}
?>
```

###Memory Cache

Another caching technique is caching via memory. This is a lot more faster than caching in the file system.

####Opcode Cache

Opcode Cache is mostly used for temporarily storing data and not the actual content. The first time I encountered object cache I couldn't understand what's the difference between it and sessions.
I did some reading and found out that by default sessions are stored in the filesystem. And data stored via object cache is stored in memory so its faster compared to session.


#####APC

We can implement object caching by using APC. APC isn't packaged with PHP so you have to install it separately. In Ubuntu you can install it by going to the terminal and executing the following command:

```
sudo apt-get install php-apc
```

Once that's done you can simply restart Apache for the changes to reflect.

```
sudo service apache2 restart
```

Using APC is simple. There are only 3 methods that you need to remember in order to start using it:

- **apc_add/apc_store** - store a variable in the cache. The only difference between `apc_add` and `apc_store` is that `apc_store` overwrites the data if it already exists and `apc_add` does not
- **apc_fetch** - fetch a variable from the cache
- **apc_delete** - delete a variable from the cache

Below is a sample implementation of APC. Here were simply checking if the value returned from fetching the `db_results` cache is null. If its null then we get the data from the database, store the results in the cache then do something with the results that were retrieved. If the call to `apc_fetch` returned something then we simply use it instead of travelling back to the database to get the data that we need.

```php
<?php
$results_array = apc_fetch('db_results');

if($results_array == null){
	$db = new Mysqli($host, $user, $password, $database); 
	//get data from the database
	$results = $db->query("SELECT title, SUM(views) AS view_count FROM tbl_octoblog 
		LEFT JOIN tbl_blogviews ON tbl_octoblog.id = tbl_blogviews.post_id
		GROUP BY title");

	$results_array = $results->fetch_array(MYSQLI_ASSOC); //convert results to associative array
	apc_add('db_results', $results_array, 86400); //store results in the cache for 1 day (1 day = 86400 seconds)
}

//do something with the $results_array
?>
```

If you wish to learn more about APC, be sure to check out the [official APC documentation](http://www.php.net/apc/) on PHP.net.


#####Memcached

Memcached is an in-memory key-value store for small chunks of arbitrary data (strings, objects) from results of database calls, API calls, or page rendering. That's the definition that I got from the memcached site. To put simply, memcached is used for temporarily storing data that came from a specific source (database, API, page rendering).

To install memcached execute the following from your terminal:

```
sudo apt-get install memcached
```

And just like with APC, you also have to restart apache in order for the changes to take effect:

```
sudo service apache2 restart
```

Once that's done, you can go ahead and start using memcached. To use memcached you first have to define the memcached server in which you want to connect to. Since this is just a getting started tutorial we can simply use `127.0.0.1` as the host. This refers to the localhost or the machine that you're currently working on. As for the port, the default port that memcached is running on is port `11211`. You can change these values by updating the `memcached.conf` file located under the `etc` directory.
After that, declare a new object of the Memcache class then call the `connect` method using the newly declared object. The `connect` method takes up the host and port that you declared earlier as its arguments. You can then use the variable that you used to store the result of that call to check whether the connection was successful or not. 
From there the scenario is similar to that of the APC example earlier. First you call the `get` method and supply a unique key that you will be using to refer to the data as the argument then store the result in a variable. Then you simply check whether this variable contains `null`. If its `null` then it means there's no data assigned to the specific key that you used so you have to get the data from its original source, in the case of the example below the database is the original source. Once you get the data from its original source you can then use the `set` method to save the data into the cache. The `set` method takes up 2 required arguments, the first is the unique key that will be used to identify the data, the second is the data that you want to store, the third is a flag on whether to use compression or not. If you want to compress the data you can use `MEMCACHE_COMPRESSED` as the value for the flag, otherwise simply use `false`. The last argument is the expiration time. You can use either a unix timestamp or the number of seconds in which to store the data in the cache. In the example below we used the number of seconds `86400` which is the number of seconds in a day. 
The next time the script runs it will no longer go back to the database to get the data. It will get it from the cache instead.

```php
<?php
//define the memcached host and port to connect to
$memcache_host = '127.0.0.1';
$memcache_port = '11211';
 
//connect to memcached server
$memcache = new Memcache;
$is_cache = $memcache->connect($memcache_host, $memcache_port);


if($is_cache){

	$things = $memcache->get('things');

	if($things == null){ //if data hasn't been cached yet
		$db = new Mysqli($db_host, $db_user, $db_password, $db_name); 
		$results = $db->query("SELECT * FROM tbl_things WHERE needed = 'yes'");
		$things = $results->fetch_array(MYSQLI_ASSOC); //convert result set to an array

		$memcache->set('things', $things, false, 86400); //cache the data
	}

	//do something with the $things, output it, mess with it, whatever.
}
?>
```

Here are some of the common methods that you can use with memcached:

- **add** - saves a specific data into the cache
- **store** - saves a specific data into the cache. The only difference between `store` and `add` is that `add` will return `false` if the key already exists but store goes ahead and over-writes the data if it already exists
- **delete** - deletes data from the cache based on the key that you define as its argument 
- **flush** - deletes all the data that you have on the cache

To learn more about memcached be sure to check out the [official memcached site](http://memcached.org/) or the [memcached documentation for PHP](http://php.net/manual/en/book.memcache.php).


###Database Cache

We have been talking about how to do caching in the application layer but caching can also be in the database layer. 
In this form of caching the caching is done by the database server itself. This works by caching the results of the query so the query is only parsed the first time it runs and in the succeeding requests it won't be parsed since the results from the specific query is already cached by the database server.
In this section I'm going to walk you through how caching is done in MySQL.

To configure caching in MySQL simply open up the `my.cnf` file under the `etc` directory and add the following lines:

```
query_cache_type    = 1
query_cache_limit	= 1M
query_cache_size    = 16M
```

 - **query_cache_type** - whether to enable caching. Set to `0` if you want to disable, `1` to enable for all cacheable queries except those that begin with `SELECT SQL_NO_CACHE`. And `2` to cache only for cacheable queries that begin with `SELECT SQL_CACHE`  
 - **query_cache_limit** - limit caching for a specific result set. If the results returned from the query exceeds the value set in this option then it won't be cache 
 - **query_cache_size** - the amount of memory allocated for caching results

The query cache works by storing the text of a SELECT statement together with the result. If the same query is received at a later time, the server retrieves the results from the query cache rather than parsing and executing the statement again. The query cache is shared among sessions, so a result set generated by one client can be sent in response to the same query issued by another client. 

But you may ask: "What if the contents of a specific table has been changed, will the server return the results from the cache?". The answer is no it doesn't. The server is smart enough to flush the cache when the tables in question is updated or modified in some way.

Here are some of the things that you need to remember when using the query cache in MySQL:

 - Only full queries are cached. This means that subqueries aren't cached by the server at all
 - Query cache stores the text of a SELECT statement together with the result. Yes I already said that earlier but I think its worth emphasizing
 - Only works for SELECT queries
 - No support for prepared statements
 - Only works for queries that are absolutely the same

Be sure to read about [how the query caching operates](http://dev.mysql.com/doc/refman/5.1/en/query-cache-operation.html) at the official MySQL website if you want to learn more about the query cache.


###Caching Libraries

To make the caching implementation easier you can also use caching libraries. Caching libraries allows you to use different caching methods such as the file system, sqlite, apc, memcached and xcache.

####PHPFastCache

First on the list is PHPFastCache. PHPFastCache is a high-performance object caching system for PHP. 
To use PHPFastCache all you have to do is download the library from their site and include the `phpfastcache.php` file on the script where you plan to use it. Then declare a variable that will contain the configuration details such as the storage, the path for the cache files and the htaccess protection to disable direct access to the data that are cached.

```php
<?php
require_once("libs/phpfastcache/phpfastcache.php");

//configuration
$config = array(
    "storage" => "files",
    "path" => "/somewhere/outside/your/web_folder", //path for cache files
    "htaccess" => true, //set htaccess protection (default: true)
);
?>
```

You can also supply a `fallback` option in case the primary caching option that you supplied isn't available on the server where you deploy your application. 

```
<?php
$config = array(
	"fallback"  =>  array(
	    "memcache" => "files", //if memcached isn't installed use file system instead
	    "apc" => "files", //if apc isn't installed use file system instead
	)
);
?>
```

If you used memcached as the cache type, you can provide the memcached server details under the `server` key of the configuration. If you remember earlier when we used memcached we supplied the `server` and the `port`. You also need to pass these details under the configuration.

```
<?php
$config = array(
 "server" =>  array(
    array("127.0.0.1", 11211, 1) 
  )
);
?>
```

Once you're done with setting up the configuration, simply pass it as the argument for the `setup` method then declare a new instance of the `phpFastCache` class:

```
<?php
phpFastCache::setup($config);
$cache = new phpFastCache();
?>
```

Just like with any other caching methods that we've used so far there's only a couple of methods that you have to remember: `get` and `set`. In PHPFastCache we use `set` to save a specific data into the cache and `get` to get the data back for processing.
In the example below were trying to get the products from the cache. If it doesn't exist we simply get the data from the original source and cache it.

```
<?php
$products_cache = $cache->get("products");
if($products_cache == null){
	$results = $db->query("SELECT item_name, quantity, price FROM tbl_products LIMIT 10");
	$results->fetch_array(MYSQLI_ASSOC);
	$cache->set("products", $products_cache);
}
?>
```

You can learn more about [PHPFastCache](http://www.phpfastcache.com/) on their official site.


####Doctrine/Cache

The Doctrine Object Relational Mapper also comes with a caching module which you can use separately even if you're not using Doctrine. You can install the Doctrine caching module through composer.

```
{
	"require": {
	  "doctrine/cache": "1.2"
	}
}
```

Include the `autoload.php` file and initialize the cache driver that you want to use.

```
<?php
require 'vendor/autoload.php';
$cache = new \Doctrine\Common\Cache\ApcCache(); //use APC as the driver
$fruits = $cache->fetch('fruits'); //fetch the data from the cache

if($fruits == null){
	$fruits = array('apple', 'orange', 'grapes', 'coconut', 'papaya');
	$cache->save('fruits', $fruits); //save data into the cache
}

//do something with $fruits
?>
```

With Doctrine you can also use the following as the cache driver:

 - ArrayCache
 - CouchbaseCache
 - FileCache
 - FilesystemCache
 - MemcacheCache
 - MemcachedCache
 - MongoDBCache
 - PhpFileCache
 - RedisCache
 - RiakCache
 - WinCacheCache
 - XcacheCache
 - ZendDataCache

So if you want to use Memcache you do something like this:

```
<?php
$memcache = new Memcache();
$memcache->connect('127.0.0.1', 11211); //connect to the memcache server
$cache = new \Doctrine\Common\Cache\MemcacheCache();
?>
```

As you can see Doctrine doesn't automatically handle connecting to the memcache server so you have to do it manually before initialiazing the cache driver that you want to use. After that you can use the same methods that you use with any other caching driver. Here are the commonly used methods:

 - fetch($id) - fetch an item from the cache
 - contains($id) - check if an item exists in the cache
 - save($id, $data, $lifetime) - save the data into the cache. Note that the lifetime is expressed in seconds
 - delete($id) - deletes an item from the cache

You can learn more about the Doctrine caching module [here](http://docs.doctrine-project.org/en/2.0.x/reference/caching.html).


###Things to Remember

Implementing a caching functionality in the applications that you're writing can be great, but like Uncle Ben from Spiderman said 'With great power comes great responsibility'. So as developers we always have to carefully study if caching is appropriate for a specific scenario or not. For example here are some instances in which caching is not recommended:

 - real-time data
 - search results
 - latest news

A good rule of thumb when trying to implement caching is that to ask yourself whether the data needs to be always fresh or not. For the examples above caching is pretty much not applicable. But if you think about the requirements, for example for the latest news, is there always a latest news every minute? Yes there may be but does publishing a new news in news website (that's a tongue twister that I just came up with) takes less than a minute? Maybe you can actually apply caching but only cache for example 30 seconds. The same is true with search results, if the website doesn't really publish much content then caching can still be applied. Just be sure to think about the expiration time carefully.


##Conclusion

There you have it! Some of the most common caching techniques that you can use with PHP to improve the performance of the applications that you're writing. Like I just said, caching is a very good way to improve the performance of your app. There's no need to run a query every time a page is requested. If you can cache it somewhere (filesytem, memory) where it will take less time to access, the better.


##Resources

 - [What is Caching](http://stackoverflow.com/questions/548301/what-is-caching)
 - [Caching Basics](http://www.slideshare.net/anisniit/caching-new)
 - [Beginners Guide to HTTP Cache Headers](http://www.mobify.com/blog/beginners-guide-to-http-cache-headers/)
 - [Database Caching](http://en.wikipedia.org/wiki/Database_caching)
 - [MySQL Caching Methods Tips and Tricks](http://www.mysqlperformanceblog.com/2011/04/04/mysql-caching-methods-and-tips/)
 - [Understanding MySQL Query Cache](http://www.taos.com/2013/04/10/understanding-mysql-query-cache/)
