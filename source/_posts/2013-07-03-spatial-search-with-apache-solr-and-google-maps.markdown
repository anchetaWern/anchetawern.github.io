---
layout: post
title: "Spatial search with Apache Solr and Google Maps"
date: 2013-07-03 21:33
comments: true
categories: [apache-solr, spatial-search, google-maps]
published: true
---

In this tutorial I'm going to show you how to setup spatial search in Apache Solr then were going to create an application which uses Spatial searching with the use of Google Maps.

<!--More-->

##What is Spatial Searching?

According to [Wikipedia](https://en.wikipedia.org/wiki/Geomatics):

{% blockquote %}
Geospatial technology or geomatics engineering is the discipline of gathering, storing, processing, and delivering geographic information, or spatially referenced information.
{% endblockquote %}

For the purposes of this tutorial were going to use Spatial search to find the locations which are near the place that we specify.


##Configure schema.xml File

First you need to configure the `schema.xml` to include a special field type called location. This field type is specifically used for geospatial searching. Depending on the Solr version that you're running on your machine it may or may not already be included on the default `schema.xml` file. But in case its not already included, here's what you have to add:

```xml
<fieldType name="location" class="solr.LatLonType" subFieldType="tdouble"/>
```

Then you can create a dynamic field that would use that specific field type by simply supplying the value for the `type` attribute to be `location`.

```
<dynamicField name="locm_*" type="location" indexed="true"  stored="true" multiValued="true"/>
```

After that you can now declare fields which will use the dynamic field:

```
<field name="locm_places">12.3456,-987.65</field>
```

As you can see from the example above, you can use dynamic fields by using the its name as the prefix for any field. In this case the prefix that we used is `locm_`. On the dynamic field declaration earlier we used the star `*` to tell to Solr that any field which uses the strings before the star will be using the attributes for this dynamic field.


##Geocoding

We need actual coordinates as our data-source for the project that were going to build later on so were going to use the Google Geocoding API to convert places into coordinates. I'm just going to use some places in my town as an example:

```php
<?php
$places = array(
	'San Fernando (La Union) Fire Station, San Fernando City, Region I, Philippines',
	'San Fernando (La Union) PNR',
	'Catbangen Central School, Gualberto Street, San Fernando City, Philippines',
	'Don Mariano Marcos Memorial State University, San Fernando City, Region I, Philippines',
	'TESDA Regional Training Center, San Fernando City, Region I, Philippines',
	'Lorma Colleges, San Fernando City, Philippines',
	'marcos building san fernando la union',
	'CICOSAT Medical Hospital, MacArthur Highway, San Fernando City, Region I, Philippines',
	'Gifted Learning Center, Gov. Nisce Street, San Fernando City, Region I, Philippines',
	'Union Christian College, San Fernando City, Region I, Philippines',
	'High Altitude Discotheque, Aguila Road, San Fernando City, Region I, Philippines',
	'Bethany Hospital, San Fernando City, Region I, Philippines',
	'sea and sky college san fernando la union',
	'Chowking, Gov. Luna Street, San Fernando City, Region I, Philippines',
	'saint williams cathedral san fernando la union',
	'ilocanos norte community school',
	'zaragosa elementary school',
	'bacnotan national highschool',
	'busel-busel elementary school',
	'luna public cemetery',
	'paratong elementary school'
);
?>
``` 

If you want you can also use places in your town. Just make sure you check it with the Google Geocoding API first so that you know that it actually returns something. You can just paste the following URL in your browser's address bar and replace `SOME_PLACE_THAT_YOU_KNOW` with an actual place that you know, well-known and highly accessible places in your town is a great choice since there will be a greater chance that its already been geocoded.

```
http://maps.googleapis.com/maps/api/geocode/json?address=SOME_PLACE_THAT_YOU_KNOW&sensor=false
```

{% blockquote %}
It's important that you set the sensor to false since were not actually using a device with a location sensor (GPS locator) in this application. 
{% endblockquote %}


Next we use the Google Geocoding API to convert the places that we specified earlier into a coordinate (latitude and longitude). Here were simply extracting the data returned from the Google Geocoding API for each of the places then storing it in a variable called `$data`. Then we convert it back to a JSON string using the `json_encode()` method.

{% blockquote %}
Id is a required attribute for documents indexed in Solr so we have to generate a unique ID for each of the places that were going to add. Also remember to use dynamic fields that are already available from the schema.xml file in Solr. In this case were using the dynamic field ss_* which has a data type of string to store the name of the place, and the dynamic field locm_* to store the coordinates of the place.
{% endblockquote %}

```
<?php
$url = 'http://maps.googleapis.com/maps/api/geocode/json?address=place&sensor=false';

$data = array();
$id_prefix = 'SUPER'; //it's a good idea to prefix your Solr ID's just to make sure it won't have the same id as something that already exists

foreach($places as $i => $place){

	$request_url = str_replace('place', urlencode($place) , $url); //replace the place string in the url with the urlencoded address
	$response = file_get_contents($request_url); //make the actual request to the google geocoding api
	$results = json_decode($response); //google geocoding api returns a JSON string so we have to use json_decode() to convert it to an array
	
	$data[] = array(
		'id' => $id_prefix . $i,
		'ss_place' => $results->results[0]->address_components[0]->short_name,
		'locm_lat' => $results->results[0]->geometry->location->lat . ',' . $results->results[0]->geometry->location->lng
	);
}

$doc = json_encode($data); //convert the data to a json string
?>
```

Next make the request to the Solr server to update the index using `curl`:

```
<?php
$solr_update_url = 'http://localhost:8080/solr/update/json'; //the url for updating the solr index using a json document
$solr_commit_url = 'http://localhost:8080/solr/update?commit=true'; //the url for commiting the updates

$curl = curl_init();

curl_setopt_array($curl, array(
    CURLOPT_RETURNTRANSFER => 1, //specify that we want to return the response so we can store it in a variable
    CURLOPT_HTTPHEADER => array("Content-type:application/json"), //header type
    CURLOPT_URL => $solr_update_url,
    CURLOPT_POST => 1, //specify that we want to post a data
    CURLOPT_POSTFIELDS => $doc, //the data that we want to post
));

$update_response = curl_exec($curl);
curl_close($curl);


//commit the changes to SOLR
$curl = curl_init();
curl_setopt_array($curl, array(
	CURLOPT_URL => $solr_commit_url
));


$commit_response = curl_exec($curl);
curl_close($curl);
?>
```


##Building the Application

Now for the fun part, let's start building the application. You're going to need to download and link up the following resources if you want to follow along:

- jQuery
- jQuery UI (Use the custom builder to only include the dependencies of jQuery UI slider and the Slider itself)
- Google Maps API Key (you're going to need a Google Account, just access the [Google Console](http://code.google.com/apis/console) and activate the Google Maps API)

The application that were going to build is simple, were just going to need a text field in which the user will input the base location, then a slider to adjust the distance. The markers that points out the nearby places which matches the current distance will automatically be updated once the user moves the slider.

```html
<link rel="stylesheet" href="jquery-ui/css/ui-lightness/jquery-ui-1.10.3.custom.min.css">
<link rel="stylesheet" href="style.css">
<script type="text/javascript"
  src="http://maps.googleapis.com/maps/api/js?key=YOUR_GOOGLE_MAPS_API_KEY&sensor=false&libraries=places">
</script>

<body>
    <p>
      <label for="location">Location:</label> 
      <input type="text" id="location"/>     
    </p>     
    <div id="slider"></div>
    <div id="map-canvas"></div><!--the container of the map-->
</body>
<script src="jquery.js"></script>
<script src="jquery-ui/js/jquery-ui-1.10.3.custom.min.js"></script>
<script src="script.js"></script>
```

Then on the `style.css` file sprinkle some css that will make the presentation slightly:

```css
html { 
  height: 100%;
}

body { 
  height: 100%; 
  margin: 0; 
  padding: 0; 
}

#map-canvas { 
  height: 90%; 
}

#slider {
  width: 200px;
}
```

Then on the `script.js` file add the code that will set the default map options. Were just going to make everything global so we can access them from anywhere.

```javascript
var loc; //this will store information about the current base location selected by the user
var markers_array = []; //this will store an array of the markers that were created

//set the map options
var map_options = {
    center: new google.maps.LatLng(16.61096000671, 120.31346130371),
    zoom: 17, //set zoom level to 17 
    mapTypeId: google.maps.MapTypeId.ROADMAP //set map type to road map
};

//layout the map in the page
var map = new google.maps.Map(document.getElementById("map-canvas"), map_options);

var homeLatlng = new google.maps.LatLng(18.35827827454, 121.63744354248); //set the base coordinate

//set the marker for the base coordinate
var homeMarker = new google.maps.Marker({
    position: homeLatlng,
    map: map,
    draggable: false
});

//get the text field which the user will use to search for a base location
var input = document.getElementById('location'); 
var autocomplete = new google.maps.places.Autocomplete(input); //google maps autocomplete

autocomplete.bindTo('bounds', map); //bind the selected place in the autocomplete text field to the map
		
/*
 executed when a place is selected from the search bar
 this will automatically adjust the map settings to display the place that was entered in the text field
*/
google.maps.event.addListener(autocomplete, 'place_changed', function(){

    var place = autocomplete.getPlace();

    //if the selected location has a geometry then show it on the map
    if(place.geometry.viewport){
      map.fitBounds(place.geometry.viewport); //automatically adjust the display on the viewport
    }else{
      map.setCenter(place.geometry.location); //if the location doesn't have a geometry, use the location
      map.setZoom(17); //set the zoom level to 17
    }
    
    homeMarker.setMap(map); //place the marker in the map
    homeMarker.setPosition(place.geometry.location); //set the position of the marker based on the selected location
    
    
    //update the global variable which stores the current location
    loc = place.geometry.location; 
});
```

Add a method to clear the markers, this will be used to clear the markers every time the distance is updated:

```
google.maps.Map.prototype.clear_markers = function() {
  for (var i = 0; i < markers_array.length; i++){
    markers_array[i].setMap(null);
  }
}
```

Add the code for when the user moves the slider, were going to bind it to a text field so the actual value is visible to the user. The value will have a unit of kilometers.

```
$("#slider").slider({
  slide: function(event, ui){

    map.clear_markers(); //clear all the markers that are currently in the map
    
    var distance = ui.value; //the selected distance

    //get the latitude and longitude from the location that we updated  earlier
    var coordinate = loc.lat() + "," + loc.lng(); 

    //create the object which will store the data that were going to pass through solr
    var data = {
      'coordinate' : coordinate,
      'distance' : distance
    };

    $("#distance").val(distance); //update the text field which shows the current distance
    
    //make the request
    $.post('http://my.dev/tester/geocoding/get_nearby_places.php', data, function(response){
      
      var results = JSON.parse(response); //convert the JSON string to a JavaScript object
      if(results.response){

        var places = results.response.docs; //the actual places that were returned by solr

        var place_count = places.length;
        var markers = [];

        //loop through all the places that were returned
        for(var x = 0; x < place_count; x++){
          
          var coordinate = (places[x]['locm_lat'][0]).split(','); //convert the string to an array
          var lat = coordinate[0];
          var lng = coordinate[1];
          
          //create the marker which points out the nearby places
          marker = new google.maps.Marker({
              position: new google.maps.LatLng(lat, lng),
              map: map
          });

          //push the marker to the array which stores the markers so we can clear them later
          //when user moves the slider again
          markers_array.push(marker); 

        }
      }
      

    });
  }
});
```

Finally, add the code which will make the query to the Solr server to get the places which are near to the selected location. What were doing here is constructing the URL needed to make the request to the solr server, then getting the actual response that was returned and then outputting it.

```php
<?php
//the url for querying solr, 8080 is the port where solr is running
$url  = 'http://localhost:8080/solr/select?q=*:*&fq='; 

//the string that we need to replace in the query
$search = array(
	'BASE_COORDINATE',
	'DISTANCE'
);

//the string that were going to use as a query
$replace = array(
	$_POST['coordinate'], //the latitude and longitude pair (eg. 123.111,456.233)
	$_POST['distance'] //the selected distance
);

//replace the placeholder text with the input supplied by the user then encode the part of the url which has the query
$url .= urlencode(str_replace($search, $replace, '{!geofilt pt=BASE_COORDINATE sfield=locm_lat d=DISTANCE}'));
$url .= '&wt=json'; //set the response type to json

$response = file_get_contents($url); //get the json string returned from the query
echo $response; //output the json string
?>
```

The output will look like this:

![asana](/images/posts/spatial_search_with_apache_solr_and_google_maps/output.PNG)


##Conclusion

That's it for this tutorial, you've learned how to use Solr's spatial search with Google Maps.
You can further improve the application that we just built. For example, you can make a distinction to the marker for the selected location by giving it a different color or icon since the marker for that is currently the same with the markers for locations which are near the selected location. You can also add filters, for example only show nearby restaurants to the location that you selected.


##Resources

- [Solr Spatial Search](http://wiki.apache.org/solr/SpatialSearch)
- [Google Maps API](https://developers.google.com/maps/)

