---
layout: post
title: "Using Google Maps with Mysql and PHP"
date: 2012-08-27 21:12
comments: true
categories: [google-maps, php, mysql]
published: true
---


###Introduction

In this article were going to build a simple application that allows users to plot a specific place in Google Maps and save the coordinates in a database. The application will also have a search feature that allows users to search the places that they have saved in the database. Once a place has been selected it will be plotted back into the map. This article won't serve as an introduction to using Google Maps so its required that you first go ahead and read up the Google Maps v3 API Documentation if its your first time using Google Maps API. But if you want a quick and dirty solution without understanding anything then feel free to go ahead and copy-paste all the things.
Here's what the output would look like:

![place](/images/posts/googlemaps_and_mysql/place1.jpg)
![search](/images/posts/googlemaps_and_mysql/search.jpg)

If that has gotten you interested then let's get started.


<!--More-->


####Database

Let's start by creating the table that will store the coordinates of places in the map. Note that the code below will only create the table so go ahead and create the database which will serve as the home for this table.

```sql
	CREATE TABLE IF NOT EXISTS `tbl_places` (
	`place_id` int(10) NOT NULL AUTO_INCREMENT,
	`place` varchar(160) NOT NULL,
	`description` varchar(200) NOT NULL,
	`lat` float(15,11) NOT NULL,
	`lng` float(15,11) NOT NULL,
	PRIMARY KEY (`place_id`)
	) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=latin1;
```



Include the Google Maps API JavaScript and jQuery

Next were going to include the Google Maps API JavaScript file and jQuery into the page. Jquery isn't actually required but its going to make our life easier in selecting the elements that we need and delegating events to specific elements. So if you want to use plain JavaScript or another JavaScript library then feel free to use them. In the options we have set the sensor equal to false since were not gonna detect the users location. We've also set the libraries equal to places to make use of the places library which powers the search feature of the application that were going to make. This allows the user to search for places that are already in Google's database.

```html
<script type="text/javascript" src="js/jquery172.js"></script>
<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?key=YOUR_KEY&sensor=false&libraries=places"></script>
```

####Setting Map Defaults

Next we set the default information to be used by the map like the coordinates where the map will be centered when the page is loaded, the marker, the map type. I'm not a big fan of explaining everything in sentences when making this type of articles so be sure to read up the comments if you don't know what each line of code does.
Set default coordinate information.

```javascript
var lat = 18.35827827454; //default latitude
var lng = 121.63744354248; //default longitude
var homeLatlng = new google.maps.LatLng(lat, lng); //set default coordinates
```

Set default settings for the marker.

```
var homeMarker = new google.maps.Marker({ //set marker
  position: homeLatlng, //set marker position equal to the default coordinates
  map: map, //set map to be used by the marker
  draggable: true //make the marker draggable
});
```

Set the defaults settings to be used by the map.

```
var myOptions = {
    center: new google.maps.LatLng(16.61096000671, 120.31346130371), //set map center
    zoom: 17, //set zoom level to 17
    mapTypeId: google.maps.MapTypeId.ROADMAP //set map type to road map
  };
  var map = new google.maps.Map($("#map_canvas"),
      myOptions); //initialize the map
```

####Search Feature

Next lets build the search feature for new places. First create the text field in which the users will type his queries:

```html
<label for="search_new_places">New Places</label>
<input id="search_new_places" type="text" />
```

####Bind the search field into the Map

Next let's bind the search field to the autocomplete using the Autocomplete class. This allows us to store an instance of the text field for the auto-complete search field. And that is stored by the autocomplete variable which we will use later on as the argument for the event listener when the place selected on the auto-complete search field changes.

```
	var input = $('#search_new_places'); //get element to use as input for autocomplete
	var autocomplete = new google.maps.places.Autocomplete(input); //set it as the input for autocomplete
	autocomplete.bindTo('bounds', map); //bias the results to the maps viewport
```

Also add the other html code that we will be using later on for searching existing places and saving new places into the database.

```html
<label for="search_ex_places">Saved Places</label>
<input id="search_ex_places" type="text" />

<!--this will hold the place id of the selected existing place-->
<input id="place_id" type="hidden" name="place_id" />

<!--The following are used for holding the name of the place and its description-->

<label for="place">Name</label>
<input id="n_place" type="text" name="n_place" />

<label for="description">Description</label>
<input id="n_description" type="text" name="n_description" />

<!--buttons used for executing functions for saving the place and plotting marker into the map-->

<input id="btn_save" type="button" value="save place" />
<input id="plot_marker" type="button" value="plot marker" />
```

####Load existing places into search field

Include the database configuration file(which we will be creating shortly). Create a query that will select all the places that were saved in the database. 

```php
<?php
	require_once('places_config.php'); //include database config file
	$places = $db->query("SELECT * FROM tbl_places");
?>
```

Then loop through it. Inside the loop we create a new option for the datalist(the datalist serves as the data source for the auto-complete search field) we also add a corresponding data attribute for each of the fields from the table. ```data-id``` stores the id of the place, ```data-lat``` stores the latitude, etc. We will then use this data later on to fill in the text fields for the place id, name of the place, and description.

```html
<datalist id="saved_places">
	<!--loop through the places saved in the database and store their data into each of the data attribute in the options-->
	<?php while($row = $places->fetch_object()){ ?>
	<option value="<?php echo $row->place; ?>" data-id="<?php echo $row->place_id; ?>" 
			data-lat="<?php echo $row->lat; ?>" data-lng="<?php echo $row->lng; ?>" 
			data-place="<?php echo $row->place; ?>" data-description="<?php echo $row->description; ?>"><?php echo $row->place; ?>
	</option>
	<?php } ?>
</datalist>
```

####Add event listener for the new places search field

Next were going to add an event listener for when a place is selected from the new places search field. This allows us to get information such as the coordinates of the selected place and use that information to set where the marker will be plotted in the map. If you remember earlier we created a variable named autocomplete which we binded into the map. This variable is what were going to use as the first argument for the event listener when the place selected from the auto-complete search field changes.

```javascript
//executed when a place is selected from the search field
google.maps.event.addListener(autocomplete, 'place_changed', function(){

    //get information about the selected place in the autocomplete text field
    var place = autocomplete.getPlace();

    if (place.geometry.viewport){ //for places within the default view port (continents, countries)
      map.fitBounds(place.geometry.viewport); //set map center to the coordinates of the location
    } else { //for places that are not on the default view port (cities, streets)
      map.setCenter(place.geometry.location);  //set map center to the coordinates of the location
      map.setZoom(17); //set a custom zoom level of 17
    }

    homeMarker.setMap(map); //set the map to be used by the  marker
    homeMarker.setPosition(place.geometry.location); //plot marker into the coordinates of the location

});
```

####Plotting the Marker

Next we'll also add the function which will allow the user to plot a marker in the center of the map.

```
$('#plot_marker').click(function(e){ //used for plotting the marker into the map if it doesn't exist already
  e.preventDefault();
  homeMarker.setMap(map); //set the map to be used by marker
  homeMarker.setPosition(map.getCenter()); //set position of marker equal to the current center of the map
  map.setZoom(17);

  $('input[type=text], input[type=hidden]').val('');
});
```

####Search field for existing places

Next we'll add the functionality to search for existing places saved in the database.

```
$('#search_ex_places').blur(function(){//once the user has selected an existing place

  var place = $(this).val();
  //initialize values
  var exists = 0;
  var lat = 0;
  var lng = 0;
  $('#saved_places option').each(function(index){ //loop through the save places
    var cur_place = $(this).data('place'); //current place description

    //if current place in the loop is equal to the selected place
    //then set the information to their respected fields
    if(cur_place == place){
      exists = 1;
      $('#place_id').val($(this).data('id'));
      lat = $(this).data('lat');
      lng = $(this).data('lng');
      $('#n_place').val($(this).data('place'));
      $('#n_description').val($(this).data('description'));
    }
  });

  //if the place doesn't exist then empty all the text fields and hidden fields
  if(exists == 0){
    $('input[type=text], input[type=hidden]').val('');

  }else{
    //set the coordinates of the selected place
    var position = new google.maps.LatLng(lat, lng);

    //set marker position
    homeMarker.setMap(map);
    homeMarker.setPosition(position);

    //set the center of the map
    map.setCenter(homeMarker.getPosition());
    map.setZoom(17);

  }
});
```

####Submit information via AJAX

Were going to submit the information about the place(name of the place, description, latitude, longitude) via AJAX into the backend.

```
$('#btn_save').click(function(){
    var place   = $.trim($('#n_place').val());
    var description = $.trim($('#n_description').val());
    var lat = homeMarker.getPosition().lat();
    var lng = homeMarker.getPosition().lng();

    $.post('save_place.php',
    	{
      	'place' : place, 'description' : description,
      	'lat' : lat, 'lng' : lng
    	},
      function(data){
        var place_id = data;
        var new_option = $('').attr(
						{
						'data-id' : place_id, 'data-place' : place, 
						'data-lat' : lat, 'data-lng' : lng, 'data-description' : description
						}
					).text(place);          
					
	new_option.appendTo($('#saved_places')); //append new option to the datalist      

	});    

	$('input[type=text], input[type=hidden]').val('');    
});	
```


####Connecting to the Database

Next were going to connect to the database using MySQLi(MySQL Improved). Make sure that the mysqli extension is enabled in your php.ini file:

```
[PHP_MYSQLI]
extension=php_mysqli.dll
```

Next create a new file(places_config.php) that will serve as the database configuration file.

```php
<?php
//host, user, password, database name
$db = new Mysqli("localhost", "root", "", "db");
if ($db->connect_errno){
	die('Connect Error: ' . $db->connect_errno);
}
?>
```

####Save the place into the Database

Then create an insert query to save the place into the database.

```
<?php 	
require_once('places_config.php'); //include database config file 	

//get place information submitted via ajax earlier 	
$place = $_POST['place']; 	
$description = $_POST['description']; 	
$latitude = $_POST['lat']; 	
$longitude = $_POST['lng']; 	

$db->query("
	INSERT INTO tbl_places SET place='$place', description='$description',
	lat='$latitude', lng='$longitude'
	");
	
$place_id = $db->insert_id; //get the id of the newly inserted record
echo $place_id;
?>
```


###Conclusion

You've learned how to use the Google Maps API together with PHP, MySQL and jQuery to create a simple application that allows users to plot places in Google Maps and allow them to save it in the database for later access.


###Resources

 * [Google Maps v3 API Documentation](https://developers.google.com/maps/documentation/javascript/tutorial)
 * [Leaflet](http://leaflet.cloudmade.com/)
 * [Code Samples from this Article](https://github.com/anchetaWern/tutorials/tree/master/gmaps)
