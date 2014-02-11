---
layout: post
title: "Getting Started with Ebay Finding API"
date: 2013-04-03 08:09
comments: true
categories: [php, ebay, api]
published: true
---

In this tutorial I'm going to show you how you can access the e-bay finding API to access products that are sold from e-bay.
Product data such as the list price, available quantities, images are available from the e-bay finding API.

<!--More-->

###Getting an API Key

First thing that you have to do is to get an API Key from e-bay.
This will serve as a unique identification for your application
and a means for e-bay to limit access to their API to only those that have an API key.

To get an API key you must first register with e-bay: [developer.ebay.com/join](https://developer.ebay.com/join/)

After successfully registering you will receive an email from e-bay. Click on the link to verify your email and you will be redirected to a screen similar to the screenshot below:

![successful registration](/images/posts/getting_started_with_ebay_finding_api/registration_success.jpg)

You can then click on the get your application keys link, you will be redirected to the accounts page where you can click on the Generate production keys button to generate the API key.



###Building a Simple e-bay Class

Next were going to build the class that were going to use later to access the API. 
Create a new PHP file and name it `class.ebay.php`. Then put the following contents:

```
<?php
class ebay{

}
?>
```

Inside the class declare the following private member variables:

```php
<?php
private $url = 'http://svcs.ebay.com/services/search/FindingService/v1';
private $app_id; //api key
private $global_id; //e-bay region (eg. EBAY-US)
private $version = '1.0.0'; //version of the API to use
private $format = 'json'; //format of the returned data 
?>
```

The `$url` is the address in which the API can be accessed.

The `$app_id` is the API key that you got earlier from registering your application with e-bay.

The `$global_id` is the e-bay region in which you want to access product data. Think of it as the e-bay store which you access in your browser when you want to buy something online. The e-bay store that you're accessing when you type in `ebay.com` is the US store which has a global id of `EBAY-US`. There are also other global ids that you can use, you can access them here: [Global ID List](http://developer.ebay.com/DevZone/finding/CallRef/Enums/GlobalIdList.html)

The `$version` is the version of the API that you want to use. At the time of writing of this article the version that is available is `1.0.0` so were going to use that here.

The `$format` is the format in which you want the returned data to be encoded. The preffered format is `json` since we can easily manipulate it using PHP or JavaScript.


Next is the constructor which will take up 3 arguments. The `$app_id` and `$global_id`. 
The constructor is called once you create an object of this class so you'll have to pass in the 2 arguments when you create an object.

```
<?php
public function __construct($app_id, $global_id){
	$this->app_id = $app_id; 
	$this->global_id = $global_id; 
}
?>	
```

Next, create a new method and call it `findItems` this will take 2 arguments: the `$keyword` and the `$limit`. 
The `$keyword` is your query. For example `computer accessories`. 
The `$limit` is the number of products which you want to return.

In this method were simply appending the different parameters to the `$url` that we declared earlier. 

The parameters that we have used here are:

- operation-name - the operation that you want to perform. In the example below were using the `findItemsByKeywords` operation. The type of operation will determine the other parameters that you will be including in your request.
In the case of `findItemsByKeywords` the required parameter is the `keywords`. There are also other operations which you can use you can find them at the [call reference page](http://developer.ebay.com/DevZone/finding/CallRef/index.html).

- **service-version** - the version of the API that you would want to use. In our example were using version 	`1.0.0`

- **keywords** - the parameter required by the `findItemsByKeywords` operation in which you supply your url encoded query.

- **paginationInput.entriesPerPage** - the number of entries per page

- **security-appname** - the APP id that you got from registering your application with e-bay

- **response-data-format** - the format in which you want the returned data to be. 
The preferred format is json although you can also have XML or SOAP as response data format.

Once the parameters are all appended together with the request url we can then make a request to the API by using the `file_get_contents` method and supplying the request url as the argument. And since we specified `json` as the format earlier were going to use the `json_decode` method to convert the json string into an array.  

```
<?php
public function findItems($keyword = '', $limit = 2){

	$url 	= $this->url . '?';
	$url .= 'operation-name=findItemsByKeywords';
	$url .= '&service-version=' . $this->version;
	$url .= '&keywords=' . urlencode($keyword);
	$url .= '&paginationInput.entriesPerPage=' . $limit;
	
	$url .= '&security-appname='. $this->app_id;
	$url .= '&response-data-format=' . $this->format;

	return json_decode(file_get_contents($url), true);
}
?>	
```

We can also have a method where we can have more specificity with what we want to find. 
We can also specify the sorting type, item type, minimum price and maximum price. Note that we are using a different operation name for this method and that is the `findItemsAdvanced` operation.

```
<?php
public function findItemsAdvanced($keyword = '', $item_sort = 'BestMatch', $item_type = 'FixedPricedItem', $min_price = '0', $max_price = '9999999', $limit = 2){

		$url 	= $this->url . '?';
		$url .= 'operation-name=findItemsAdvanced';
		$url .= '&service-version=' . $this->version;
		$url .= '&global-id=' . $this->global_id;
		$url .= '&keywords=' . urlencode($keyword);

		$url .= '&sortOrder=BestMatch';
		$url .= '&itemFilter(0).name=ListingType';
		$url .= '&itemFilter(0).value=FixedPrice';
		$url .= '&itemFilter(1).name=MinPrice';
		$url .= '&itemFilter(1).value=' . $min_price;
		$url .= '&itemFilter(2).name=MaxPrice';
		$url .= '&itemFilter(2).value=' . $max_price;
		$url .= '&paginationInput.entriesPerPage=' . $limit;
		$url .= '&descriptionSearch=false';

		$url .= '&security-appname='. $this->app_id;
		$url .= '&response-data-format=' . $this->format;

		return json_decode(file_get_contents($url), true);
	}
?>
```

Lastly, we can also create a method which simply returns an array of the sort orders available via e-bay.
You can find the available values for sort orders in [this page](http://developer.ebay.com/DevZone/finding/CallRef/findItemsAdvanced.html#Request.sortOrder). 

```
<?php
public function sortOrders(){

	$sort_orders = array(
		'BestMatch' => 'Best Match',
		'BidCountFewest' => 'Bid Count Fewest',
		'BidCountMost' => 'Bid Count Most',
		'CountryAscending' => 'Country Ascending',
		'CountryDescending' => 'Country Descending',
		'CurrentPriceHighest' => 'Current Highest Price',
		'DistanceNearest' => 'Nearest Distance',
		'EndTimeSoonest' => 'End Time Soonest',
		'PricePlusShippingHighest' => 'Price Plus Shipping Highest',
		'PricePlusShippingLowest' => 'Price Plus Shipping Lowest',
		'StartTimeNewest' => 'Start Time Newest'
	);

	return $sort_orders;
}
?>
```


###Building a Simple App

Time to use the class that we just created in building a simple application. 
Our simple application will have a search field for inputting products that the user wants to search
and a drop-down box to sort the results. 

The only product details that were going to show to the user is the item title, price and the product image.
In the code below were declaring an object of the class that we created earlier specifying the API key 
and the e-bay region as the first and second parameter.

Then we call the `sortOrders` method which simply returns an array of sort orders that are available from the e-bay finding API.

Next, we build the form for searching products.

Finally, we check if the `$_POST['search']` variable is not empty and use its value together with the sort selected by the user as the argument for the `findItemsAdvanced` method. 
Going back to the class that we created earlier we used `findItemsAdvanced` as the operation.
The operation determines the first index when accessing the results. 
So for the `findItemsAdvanced` it will have `findItemsAdvancedResponse` as the first index.

```
<?php
require_once('class.ebay.php');

$ebay = new ebay('YOUR API KEY', 'EBAY-US');
$sort_orders = $ebay->sortOrders();
?>

<form action="ebay_finding_test.php" method="post">
	<input type="text" name="search" id="search">
	<select name="sort" id="sort">
	<?php
	foreach($sort_orders as $key => $sort_order){
	?>
		<option value="<?php echo $key; ?>"><?php echo $sort_order; ?></option>
	<?php	
	}
	?>
	</select>
	<input type="submit" value="Search">
</form>

<?php
if(!empty($_POST['search'])){

	$results = $ebay->findItemsAdvanced($_POST['search'], $_POST['sort']);
	$item_count = $results['findItemsAdvancedResponse'][0]['searchResult'][0]['@count'];
	
	if($item_count > 0){
		$items = $results['findItemsAdvancedResponse'][0]['searchResult'][0]['item'];

		foreach($items as $i){
?>
		<li>
			<div class="item_title">
				<a href="<?php echo $i['viewItemURL'][0]; ?>"><?php echo $i['title'][0]; ?></a>
			</div>
			<div class="item_img">
				<img src="<?php echo $i['galleryURL'][0]; ?>" alt="<?php echo $i['title']; ?>">
			</div>
			<div class="item_price">
				<?php echo $i['sellingStatus'][0]['currentPrice'][0]['@currencyId']; ?>
				<?php echo $i['sellingStatus'][0]['currentPrice'][0]['__value__']; ?>
			</div>
		</li>
<?php
		}
	}		
}
?>
```


Here's the demo for this simple application implemented using JavaScript by using Handlebars for the template and jQuery's `$.ajax` method to request the data. Be sure to place your own app id that you got from e-bay in order to make this demo work.


{% jsfiddle L6Nkj %}



###Conclusion

That's it for this tutorial. Using the API is really easy since you don't need to construct signatures to be used in the request like other API's. Be sure to check out the resources below if you want to learn more about the e-bay finding API. 


###Resources

- [Finding API How To](http://developer.ebay.com/DevZone/finding/HowTo/)
- [Making an API Call](http://developer.ebay.com/DevZone/finding/Concepts/MakingACall.html)
- [Call Reference](http://developer.ebay.com/DevZone/finding/CallRef/index.html)
- [Sample Application Source Code](https://dl.dropboxusercontent.com/u/126688107/tutorials/ebay_finding_api.7z)
- [Sample Application Demo](http://tutorialdemos-wern.rhcloud.com/ebay_finding_api/ebay_finding_test.php)