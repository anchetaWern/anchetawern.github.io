---
layout: post
title: "How to modify the results from the Search API Solr Module"
date: 2013-10-13 13:15
comments: true
categories: [drupal, search-api, solr]
published: true
---


The [Search API Solr module](https://drupal.org/project/search_api_solr) for Drupal is a nice way to use Solr as the server for the [Search API module](https://drupal.org/project/search_api). Its pretty flexible with customizing the data that you want to return from the server but what if you need something that's not directly available from the Solr server? What if you also need the data to be available to the client side and do some kind of data manipulation from there? 

In this article I'll be showing you how to do just that. We will be creating a custom module that will tap into the API of the Search API Solr Module to modify the default results that are returned and make it available to the client side.



####Module Information

Let's begin by creating the `.info` file for our custom module:

```
name = searchapisolrmod
description = "Modifies the results returned from the Search API Solr Module"
package = Nrue
core = 7.x 
files[] = searchapisolrmod.module
files[] = searchapisolrmod.install
```


####Use Case

Before we dive into the 'how' let me tell you about a sample use case first.
For example, we have the following data stored in the Solr server:

```json
[
	{
		id: '123',
		business_name: 'Antares',
		business_address:postal_code: '2500 AC'
	},
	{
		id: '456',
		business_name: 'Aldebaran',
		business_address:postal_code: '3420 AD'
	},
	{
		id: '352',
		business_name: 'Cassiopeia',
		business_address:postal_code: '1288 XD'
	},
	{
		id: '93',
		business_name: 'Regulus',
		business_address:postal_code: '671 CC'
	}
]
```

But we want to display the location of the business in Google Maps by using the postal code as the query.
Normally we would want to actually update the data that's in the Solr server so there will be no need to modify the results from it. But what if we don't have access to the Solr server? What if its a remote server run by someone else? For that we will need to actually modify the results as they are returned.



####Module File

Now were ready to create the `.module` file which will contain the code that will tap into the search api solr module. The search api solr search module already provides a hook that we can tap into to modify the search results. It's called the `search_api_solr_search_results_alter()`. This takes up 3 arguments, the first one is the `$results` which contains the current result set. As you can see its an argument that's passed by reference so we don't really have to return it. The second is the `$query`, we won't really use it in our custom module but its the variable that contains the current query. The third argument is the `$response`, this is the response object returned from Solr. 

In the code below we first have to check whether we are in the specific view in which we want to execute our script.
In this case were checking if we are in the `q` view. 
Next we declare a variable called `$locations`, this will store the modified version of the results returned from the Solr server.
Next we loop through the results and get the business name and the postal code.
We then use the postal code to query the Google Geocoding API.
After that, we simply convert the results returned from the Google Geocoding API to an array so we could extract 
the coordinates (latitude and longitude). The coordinates is what we ultimately need in order to display the location of the businesses in a Google Map.
Finally we assign the modified data to the Drupal JavaScript object so that we could access it from the client-side.


```php
<?php
/**
 * Implements hook_search_api_solr_search_results_alter().
 */
function searchapisolrmod_search_api_solr_search_results_alter(&$results, $query, $response){

  if($_GET['q'] == 'q'){ //only execute this script if we are in the q view

	$locations = array();  
	$rest = $results['results'];

	if(!empty($rest)){	
		foreach($rest as $r){

			$place = $r['fields']['business_name'];

			//encode the postal code to be used as a query for the geocoding api
			$postal_code =	urlencode($r['fields']['business_address:postal_code']); 
			
			$api = 'http://maps.googleapis.com/maps/api/geocode/json?address=' .  $postal_code . '&sensor=false';
			$api_results = file_get_contents($api); //get the results from the google geocoding api
			$api_data = json_decode($api_results, true);

			if($api_data['status'] == 'OK'){
				$location = $api_data['results'][0]['geometry']['location'];

				$locations[] = array(
					'place' => $place,
					'lat' => $location['lat'],
					'lng' => $location['lng']
				);	
			}
		}
	}

	$data = array(
		'searchapisolrmod' => array( //namespacing is very important
			'locations' => $locations, 
			'results' => $rest //store the original result set that was returned
		)
	);

	drupal_add_js($data, 'setting'); //add the data to the Drupal JavaScript object
  }	
}
?>
```


####Accessing the data from the client-side

The modified results is now available from the client side via the `Drupal` object. 
You can make use of this data however you want.

```
Drupal.settings.searchapisolrmod.results
Drupal.settings.searchapisolrmod.locations
```