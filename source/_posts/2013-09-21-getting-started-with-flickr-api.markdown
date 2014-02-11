---
layout: post
title: "Getting Started with Flickr API"
date: 2013-10-13 11:00
comments: true
categories: [php, api, flickr-api]
published: true
---


In this article I'll be showing you how to get started with using the Flickr API.
The Flickr API is a way to interact with data from Flickr Accounts. 


###Getting an API Key

First you have get an API Key from the [flickr developer website](http://www.flickr.com/services/apps/create/apply/).
In order to get an API key you first have to create an app. 
The app is a way for flickr to track usage of their API. As you know, yahoo owns flickr so you first have to log in using your yahoo account in order to access the page for creating an app.

For the purpose of this tutorial you can just apply for a non-commercial key.

![key type](/images/posts/getting_started_with_flickr_api/key_type.png)

Next, enter an app info. It can be anything you want, but be sure to provide more detailed information if you will be using the API for a project that you're building:

![key type](/images/posts/getting_started_with_flickr_api/app_info.png)

Check the two checkboxes to agree with [Flickr API terms of use](http://www.flickr.com/services/api/tos/).
Be sure to read it so you will be informed of the limitations of the API.

![app key](/images/posts/getting_started_with_flickr_api/app_key.png)

Once you're done with that you can now see the Flickr key and Secret. 
Copy those two as you will be needing it to interact with the API later.



###Interacting with the API

Now were ready to actually interact with the API. 
For this tutorial were going to create a little library that will interact with the flickr API for us and then we can simply include it in our code and call the methods from there.


Create a new php file and call it `class.flickr.php`. Declare 3 private variables which will store the flickr API key, the secret key and the format in which the results will be returned. In this case were using `json` so we can manipulate it with either JavaScript or PHP if we want. Under the constructor, simply assign the values for the `$flickr_key` and `$flickr_secret` to that of the arguments that will be passed later on when the `Flickr` class is instantiated.

```php
<?php
class Flickr{

	private $flickr_key;
	private $flickr_secret;
	private $format = 'json';

	public function __construct($flickr_key, $flickr_secret) {

		$this->flickr_key = $flickr_key;
		$this->flickr_secret = $flickr_secret;
	}
?>
```


####Searching of Public Photos

Now let's create a method for searching of public photos on Flickr. 
This method performs a call to the `flickr.photos.search` method from the API. 
You can read more about the arguments which you can pass to that method [here](http://www.flickr.com/services/api/flickr.photos.search.html). 

The `searchPhotos` method will take two arguments. 
The first one is the query or the image that you're looking for. It can be the image title, description or tags that has been attached to it. Note that the query can be a single word or a collection of words, you can also prepend the minus sign (-) to a word if you want to exclude it in the search results.

The next argument is the tags, the tags is a comma-separated list of words that can be used to further describe the image that you're looking for.

As you can see from the method below were using the `urlencode()` method to wrap all the user input. This includes the query and the tags. We need to do this in order to properly format the request url.

Were also specifying a couple of arguments to the url aside from the `text` and the `tags`:

- **sort** - the order in which to return the results, in this case I've chosen `relevance` to be the value but it can also have a value of of `date-posted-asc`, `date-posted-desc`, `date-taken-asc`, `date-taken-desc`, `interestingness-desc`, and `interestingness-asc` all of which is self-explanatory.

- **safe_search** - the safe search argument is a filter for results that are returned. You will usually want this to have a value of `1` which tells to the API to only return results that are safe for viewing for all ages.

- **content_type** - the type of content, I've selected the value of `4` for this to indicate that I want to return results that can be either photos or screenshots.

- **api_key** - the API key that we got earlier from creating the app.

- **format** - the format in which to return the results. In this case were using json.

- **per_page** - this is the limit of images to return per page. In this case we only want the API to return 10 images per page. 


```
<?php
public function searchPhotos($query = '', $tags = ''){

	$urlencoded_tags = array(); 
	
	if(!empty($tags)){	
		$tags_r = explode(',', $tags);
		foreach($tags_r as $tag){
			$urlencoded_tags[] = urlencode($tag);
		}
	}	

	//construct the url
	$url  = 'http://api.flickr.com/services/rest/?';
	$url .= 'method=flickr.photos.search';
	$url .= '&text=' . urlencode($query);
	$url .= '&tags=' . implode(',', $urlencoded_tags); //convert the array of url encoded tags back to a string
	$url .= '&sort=relevance';
	$url .= '&safe_search=1';
	$url .= '&content_type=4';
	$url .= '&api_key=' . $this->flickr_key;
	$url .= '&format=' . $this->format;
	$url .= '&per_page=10';

	//get the results
	$result = file_get_contents($url);

	//remove the unneccessary strings that wraps the result returned from the API
	$json = substr($result, strlen("jsonFlickrApi("), strlen($result) - strlen("jsonFlickrApi(") - 1);

	$photos = array();
	$data = json_decode($json, true);

	//check if the status didn't fail
	if($data['stat'] != 'fail'){
		//return only the data for the photos as that's the only thing that we need
		$photos = $data['photos']['photo'];
		return $photos;
	}else{
		return false;
	}

}
?>
```

After constructing the url we simply use the `file_get_contents()` method to request the data from the API.
The results will then be stored to the `$result` variable. But the API has wrapped up the data with a function named `jsonFlickrApi()` as you can see from the screenshot below:

![flickr results](/images/posts/getting_started_with_flickr_api/flickr_results.png)

Thus we cannot immediately convert it to a PHP array or even parse it with a json parser. So we need to use the `str_replace()` function to trim the unneccessary characters. And that's exactly what this particular line does:

```
<?php
$json = substr($result, strlen("jsonFlickrApi("), strlen($result) - strlen("jsonFlickrApi(") - 1);
?>
```

Then we simply use the `json_decode()` function to convert the json string to an array.

```
<?php
$photos = array();
$data = json_decode($json, true);

//check if the status didn't fail
if($data['stat'] != 'fail'){
	//return only the data for the photos as that's the only thing that we need
	$photos = $data['photos']['photo'];
	return $photos;
}else{
	return false;
}
?>
```


But wait, were not really done yet. If you might have noticed from the screenshot of the results returned from the API earlier you might have noticed that there were no links to the images matching the query. The common purpose of using the flickr API is to fetch the image source of the images on the flickr website. So why are there no image sources as we can see from the parsed version of the results returned from the API below:

![json parse](/images/posts/getting_started_with_flickr_api/jsonview.png)


That's because we need to construct the url's ourselves using the data that has been returned from the API.
All you have to do is to extract the `farm`, `server`, `id` and the `secret`. Here's how to construct the url:

```
<?php
$src = "http://farm" . $photo['farm'] . ".static.flickr.com/" . $photo['server'] . '/' . $photo['id'] . '_' . $photo['secret'] . '_m.jpg';
?>
```

To call the method, you simply have to loop through the results returned from the `searchPhotos()` method and then construct the url from inside the loop:

```
<?php
require_once('class.flickr.php');

$flickr = new Flickr($api_key, $api_secret);

$results = $flickr->searchPhotos($query, $tags);
if(!empty($results)){
	foreach($results as $photo){

		$src = "http://farm" . $photo['farm'] . ".static.flickr.com/" . $photo['server'] . '/' . $photo['id'] . '_' . $photo['secret'] . '_m.jpg';
?>
	<img src="<?php echo $src; ?>" alt="<?php echo $photo['title']; ?>">
<?php		
	}
}
?>
```

###Conclusion

The flickr API is a great way to fetch and modify user data from the flickr website.
We've barely scratch the surface with this tutorial. If you want to learn more about the flickr API be sure to checko out the resources below.



###Resources

- [Flickr Developer Guide](http://www.flickr.com/services/developer/)
- [Flickr API Methods](http://www.flickr.com/services/api/)

