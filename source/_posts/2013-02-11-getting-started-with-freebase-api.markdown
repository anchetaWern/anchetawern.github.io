---
layout: post
title: "Getting Started with Freebase API"
date: 2013-02-11 19:55
comments: true
categories: [freebase, api, search]
published: true
---

In this blog post I'm going to show you the basics of using the Freebase API.


###What is Freebase?

Freebase is a collection of data from different sources. 
So its basically like an encyclopedia in which you can pull data from.

Here's a diagram that shows exactly what type of data you can fetch from Freebase:

![freebase diagram](/images/posts/getting_started_with_freebase/Freebase-Domains.jpg)


You can also watch this video Introducing the knowledge graph:

{% youtube mmQl6VGvX-c %}


<!--More-->


###Playing with the API

Most API's requires an API Key so that you could access its data but Freebase is different.
You have the choice whether or not to register an API key. If you just want to try things out
you can simply access the data from Freebase like this:

```
https://www.googleapis.com/freebase/v1/search?query=nirvana&indent=true
```

There are 2 parameters used in this url:


 - query - what you want to search.
 - indent - can either be true or false, specify the value of true if you want to return a formatted json string so that you can easily read it.


####Specifying Language

You can also specify the language by using the `lang` parameter. 
If you specified a non-supported language the API will also tell you:

![unsupported language](/images/posts/getting_started_with_freebase/unsupported_language.jpg)


####Filters

But the true power of this API lies on the filters that you can use to specify what is exactly the type
of data that you're looking for. For example you want to be able to find music that has the name "Robot" on it:

```
https://www.googleapis.com/freebase/v1/search?query=robot&indent=true&filter=(all%20type:music)
```

The query above would return:

![robot music](/images/posts/getting_started_with_freebase/robot_music.jpg)

Another example would be if you're looking for "One piece" not the swimsuit but the [manga/anime](http://en.wikipedia.org/wiki/One_Piece):

```
https://www.googleapis.com/freebase/v1/search?query=one%20piece&indent=true&filter=(all%20type:animation)
```

And as expected it returns only the data which refers to the "One Piece" anime/manga:

![one piece anime](/images/posts/getting_started_with_freebase/one_piece.jpg)


###Read Services

The Freebase API is actually composed of several services which you can use separately or in tandem with other services. We will go over some of these services later on and implement it using PHP. 

- Search Service
- MQL Read Service
- Topic API
- RDF API
- Text Service
- Image Service
- Freebase Suggest


###Getting an API Key

Once you've played around the Freebase API a bit you might want to register an API key.
You can register from the [Google API Console](https://code.google.com/apis/console/).
It's free to register but when your application gets more and more users and it exceeds the limit for the free service Google will have you pay for the service.

If you haven't created a project with the Google console before you might need to create a new project.

![new project](/images/posts/getting_started_with_freebase/new_project.jpg)

Once that's done look for the Freebase API in the services tab and then enable it by turning it on:

![freebase](/images/posts/getting_started_with_freebase/freebase.jpg)

Accept the service agreement and then click on the API Access tab:

![api key](/images/posts/getting_started_with_freebase/api_key.jpg)

All you have to do now is copy the API key and use it on your requests by specifying a key parameter.
Using our previous query, your query will now look like this with the api key specified:

```
https://www.googleapis.com/freebase/v1/search?query=one%20piece&indent=true&filter=(all%20type:animation)&key=xyz
```


###Freebase with PHP

Now that we've played around with the Freebase API in the browser its time to access it using PHP.

First were going to build a simple class that will query the Freebase API for us.

```php
<?php
class Freebase{

}
?>	
```

Create a new private variable that will store the API key that we got from the Google console earlier.

```
private $api_key = 'xyz';
```

####Search Service

Like I mentioned earlier we will go through some of the read services that the Freebase API offers.
So were going to create a method which will utilize these services in our class.

The service that we have gone over earlier was the Search service which simply allows you to search based on keywords.

Create a new method and call it search this will utilize the search service. 
Here we have 1 required parameter ($query) and 5 optional parameters. 
You can see a full list of the parameters that you can specify in the wiki for the [Search API](http://wiki.freebase.com/wiki/ApiSearch).

As you can see from the code below 
were just building the URL from the arguments that we will supply later on when we call the method.

```
<?php
public function search($query, $filter = '', $start = 0, $limit = 10, $exact = 'false'){

	if(!empty($query)){
		$query = urlencode($query);
		$url 	= 'https://www.googleapis.com/freebase/v1/search?query='. $query;
		$url .= '&filter=(' . urlencode($filter) . ')';
		$url .= '&start=' . $start;
		$url .= '&limit=' . $limit;
		$url .= '&exact=' . $exact;
		$url .= '&key=' . $this->api_key;

		return json_decode(file_get_contents($url), true)['result'];
	}
}
?>
```

The important thing to note here is that the query should be [url encoded](http://php.net/manual/en/function.urlencode.php) otherwise your query won't work properly if for example the query has spaces in it or some special characters.  

You can see url encoding in action when you input your query manually in the address bar of the browser.
If you manually input our query earlier it will look like this before you type in enter:

```
https://www.googleapis.com/freebase/v1/search?query=one piece&indent=true&filter=(all type:animation)&key=xyz
```

But once you press on enter all those spaces will be replaced with `%20` or `+`:

```
https://www.googleapis.com/freebase/v1/search?query=one%20piece&indent=true&filter=(all%20type:animation)&key=xyz
```

Here's a [url encoding reference](http://www.w3schools.com/tags/ref_urlencode.asp) from W3Schools.

The main meat of all the methods that we will be creating 
for this class is the actual fetching of the data from the Freebase API. 
We do the fetching by using a method called `file_get_contents` which takes a `url` as an argument and returns the contents (both html, javascript and text) of the page referenced by the url that you supplied.

But do note that `file_get_contents` doesn't work with every site or every API out there.
So in the case it doesn't work then you can use CURL instead. 
There's a very gentle introduction on [how to perform cURL request using PHP](http://codular.com/curl-with-php) at codular.

Also note that `file_get_contents` returns a warning if the content that you're requesting doesn't exist because of an HTTP Error or the API simply didn't find the data that you're requesting for. 
In those cases you might want to include an `@` sign before the actual method name like `@file_get_contents` that way it wouldn't return a warning even if nothing is returned.

Lastly we use the `json_decode` method to convert the json string to a PHP array which we can easily manipulate or loop through.


####Image Service

There's also the Image Service which simply returns an image base on the entity ID.
The entity ID can be a string or a number representing the entity. 
But in my experience I notice that this service doesn't generalize if you query for something like 'naruto', 'ichigo' or 'gundam'. It can only return an image for a certain entity that is globally known like the following people or works:

- vincent_van_gogh
- pablo_picasso
- mona_lisa
- the_scream
- jose_rizal
- andres_bonifacio
- leonardo_da_vinci  

For the others which aren't globally known or entities which didn't deserve to have an actual index for the image service you can use the search service to get the entity ID and then use that entity ID to query the image service.
We'll go through that in a minute.

For now let's look at the method for fetching image from the image service.
We have 3 parameters, 1 required and 2 optional. 

There's not really much parameters that you can specify for the image service, be sure to check out the wiki for the [image service](http://wiki.freebase.com/wiki/ApiImage) to learn more.

The first parameter is the `entity_id` which for globally known entities can be just words separated by underscores like we saw earlier. 
As you can see were not actually using the `file_get_contents` method here since we only need the url for the image we only return the url itself.

```
<?php
public function image($entity_id, $max_width = 150, $max_height = 150){

	if(!empty($entity_id)){
		$url = 'https://usercontent.googleapis.com/freebase/v1/image' . $entity_id;
		$url .= '?maxwidth=' . $max_width;
		$url .= '&maxheight=' . $max_height;
		$url .= '&key=' . $this->api_key;

		return $url;		
	}
}
?>
```

####Text Service

The text service is different from the image service in that the 
image service actually accepts the title or name of well-known entities as a value for the entity ID as well as the ID representing the entity itself.
But for the text service we can only utilize it once we've 
called the search service which returns the entity ID that we need.

The method has also a  `max_length` parameter which is simply used to specify the maximum length of the text that will be returned. `0` being no limit so it basically returns everything it can return.

```
<?php
public function text($entity_id, $max_length = '0'){

	if(!empty($entity_id)){
		$url 	= 'https://www.googleapis.com/freebase/v1/text/' . $entity_id;
		$url .= '?maxlength=' . $max_length;
		$url .= '&key=' . $this->api_key;

		return json_decode(file_get_contents($url), true)['result'];		
	}

}
?>
```


####Topic API

Lastly there's the topic API. There's actually 3 more services in the Freebase API which we haven't gone over but I'll leave those for another day. The topic API just like the text service and image service requires an entity ID for the request.

```
<?php 
public function topic($entity_id){

	if(!empty($entity_id)){
		$url = 'https://www.googleapis.com/freebase/v1/topic' . $entity_id;
		return json_decode(file_get_contents($url), true);		
	}

}
?>
```


###Calling the Methods

Now that were done creating the class its now time to actually call the methods 
to produce some output. Create a new file and then import the class that we created earlier.
Also create an object of that class so that we can use it to call the methods.

What the code below does is just using the search method as the base data source
and then the image and text methods to fetch the image and a description for each entity
returned from our main search.

```
<?php
require_once('class.freebase.php');

$freebase = new Freebase();
$result = $freebase->search('Dragon ball z', 'all type:manga');

foreach($result as $entity){

	$id = $entity['mid'];
	$name = $entity['name'];

	$image = $freebase->image($id);
	$text = $freebase->text($id);
?>
<li>
	<h3><?php echo $name; ?></h3>
	<img src="<?php echo $image; ?>" alt="<?php echo $name; ?>">
	<p>
	<?php echo $text; ?>	
	</p>	
</li>
<?php
}
?>
```


##Resources

- [Search Service](http://wiki.freebase.com/wiki/ApiSearch)
- [Image Service](http://wiki.freebase.com/wiki/ApiImage)
- [Text Service](http://wiki.freebase.com/wiki/ApiText)
- [Topic API](http://wiki.freebase.com/wiki/Topic_API)
- [Search Cookbook](http://wiki.freebase.com/wiki/Search_Cookbook)
- [URL Encoding Reference](http://www.w3schools.com/tags/ref_urlencode.asp)
- [Sample Application Source Code](https://dl.dropboxusercontent.com/u/126688107/tutorials/getting_started_with_freebase_api.7z)
