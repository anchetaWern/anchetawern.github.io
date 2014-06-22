---
layout: post
title: "Getting Started with Amazon Product Advertising API"
date: 2013-02-10 19:31
comments: true
categories: [amazon, api]
published: true
updated: 2014-02-06
---

In this blog post I'm going to show you how you can get started using Amazon's product advertising API in PHP.
I'm going to walk you through creating an access key, some of the basics of the API and lastly some examples on how to use the API.


<!--More-->


###What is the Product Advertising API

Amazon Product Advertising API is basically an API offered by Amazon for accessing data on every product that are being displayed at any Amazon site. 


###Create an Access Key

Just like most of the API that are offered by sites like Facebook, Twitter, Tumblr we need to create an
access key to be used by our application. The access key that were going to create can be used to authenticate requests to any Amazon Web Service API and that includes the Product Advertising API.

In order to obtain an access key first you have to sign up for an amazon web service account at: [aws.amazon.com](http://aws.amazon.com/). Youre amazon web service account is different from your amazon account that you use for shopping so you have to create a new account if you don't already have one.
Along the sign up process you will be asked for your credit card number. 
If you don't have a credit card fret not because you can just close the tab when you reach that point and then access the [security credentials page](https://portal.aws.amazon.com/gp/aws/securityCredentials) where you can create a new access key. All you have to do once you reach that page is to scroll down a bit so you will see the Access Credentials section which basically shows you a table of the access keys that are associated with your account.
Just click on the "Create new access key" link to create a new access key. Once that's done you can just copy and paste the access key ID and the Secret Access key to the PHP file where you're going to include the class for accessing the api later on.

![amazon access key](/images/posts/getting_started_with_amazon_product_advertising_api/access_key.jpg)

Once that's done sign up for an amazon affiliate account: [Amazon affiliate program](https://affiliate-program.amazon.com/gp/advertising/api/detail/main.html) so that you will have your own affiliate ID which you can use for accessing the API. The amazon affiliate site where you register should be the same as the amazon website where you plan to make your API requests later on. So if you're planning to use the amazon UK website then you have to register here: [Amazon UK Affiliate program](https://affiliate-program.amazon.co.uk/gp/advertising/api/detail/main.html). Once you are in that page click on the 'Sign Up now' button to sign up for the amazon affiliate service. This will ask you to login with your amazon account. You can use your AWS login credentials from earlier for this one. Once you're logged in it will ask for a couple of information about your website. Just make it up if you don't really have a website, nobody will know.

Note that the associate tag is the same thing as the affiliate ID so if the code refers to the associate tag then all you have to do is to supply the ID that you got from signing up for the Amazon affiliate program. At the time of writing of this tutorial, the affiliate ID can be found on the upper left corner of the screen after signing in to your Amazon affiliate account. The one that is directly below the 'signed in as' label.

###API Basics

There are only 3 things that you have to keep in mind while working with the Amazon Product Advertising API:

- Operations
- Response Groups
- Browse Nodes

####Operations

Operations are like methods in a class. This tells the API what specific action to do. 
Some of the most commonly used operations are:

- ItemSearch - commonly used for returning one or more items that satisfies the parameters specified
- ItemLookup - commonly used for returning a single item but can also return more items if the ASIN's (Amazon Standard Identification Number) are separated by comma. 
- SimilarityLookup - used for returning items that are similar to the ASIN that is specified in the request.


####Response Groups

Response groups are pre-defined result sets in the API. 
They are used for specifying the data that is to be returned by the API.
Some of the most commonly used response groups are:

- ItemAttributes
- EditorialReview
- Images
- Medium
- NewReleases
- Reviews
- ItemIds

You can check out the full list of available response groups here: [Response Groups](http://docs.aws.amazon.com/AWSECommerceService/latest/DG/CHAP_ResponseGroupsList.html)

Looking at the documentation provided by Amazon I don't think there's a way to specify the specific fields that you want to return so the best thing to do when working with the API is to select a response group that suits your needs.
Medium and Large response groups isn't really the best response group to use if you only want to get the items ASIN, title and selling price. So its wiser to check out what specific data are being returned by each response group before picking something like the Medium response group which returns a whole bunch of data that you might not need in the app that you're trying to build. 
Choosing the right response group will have a considerable effect on performance as you're only getting what's actually needed.


####Browse Nodes

Browse Nodes in simple terms are product categories in amazon. 
If you have already tried shopping for a product at amazon you might have notice that there's a general category that you select when searching for a product like Electronics, Aparrel, Books, etc. 
These are the major browse nodes. As you go inside that category you will then see some sub-categories. For example you're browsing through the Books category. In the right side you will see sub-categories like arts & philosophy, business & investing, children's books, etc.
All of these are represented by node Id's. You can find the full list of some of the major nodes in Amazon here: [Browse Node IDs](http://docs.aws.amazon.com/AWSECommerceService/latest/DG/BrowseNodeIDs.html)

As you might have noticed in the table in the link above, every amazon site has different sets of major nodes since not every site has the same items available.



###Accessing the API

A very nice guy has already written the class for us so we won't have to write the class for accessing the API. 
Here's the link to his blog post on how to use the API: [Accessing Amazon Product Advertising API](http://www.codediesel.com/php/accessing-amazon-product-advertising-api-in-php/) you might want to download the source code from that site and read the blog post. He has also written another class which can be used for fetching some of the product categories available in each amazon site: [Amazon Advertising API Browse Nodes](http://www.codediesel.com/libraries/amazon-advertising-api-browsenodes/).



Ok enough with the boring explanation let's start playing with the API.
Go ahead and download the source available at the site I've linked earlier and setup a sandbox where you could play with the API to your heart's content if you haven't done so.

Open up the php file which contains the class for accessing the api and do some modifications.
The class doesn't have every single operation and response group that's available in the API but its fine since we rarely need to use all of those. But we have to do some modifications so the class will become more flexible.

First replace the constructor to accept the access key($public) , access key secret($private), amazon local site($local_site) and the associate id($associate_tag):

```php
<?php
public function __construct($public, $private, $local_site, $associate_tag){

    $this->public_key = $public;
    $this->private_key = $private;
    $this->local_site = $local_site;
    $this->associate_tag = $associate_tag;
    
}
?>
```

Of course you will need to declare some member variables where the values specified in the constructor will be assigned.

The ```queryAmazon``` method can also use a little modification:

```php
<?php
public function queryAmazon($parameters){
    return amazon_product_api_signed_request($this->local_site, $parameters, $this->public_key, $this->private_key, $this->associate_tag);
}
?>
```

Little because we've only changed the string "com" to be the member variable local site. 
All the rest is left unchanged.

There are a number of methods already present in the class but the ```queryAmazon()``` method is all we really need.
All we have to do is to specify the parameters needed and were good to go.

There's also the php file which makes the actual request and creates the signatures for us.
Basically amazon needs some sort of a signature for you to be able to access the API aside from the access ID and secret that you already have. 
But the access ID and secret are basically the ingredients on creating the signature. 
We won't be diving into that because honestly I don't understand some of the black magic coding-fu that's done in that file. 

But we need to make some modifications on it as well. 
Open up the `aws_signed_request.php` and scroll to its `aws_signed_request` method. 
I noticed that the default host that is used in there is somewhat obsolete.

So instead of this:

```
<?php
$method = "GET";
$host = "webservices.amazon.".$region; 
$uri = "/onca/xml";

$params["Service"]          = "AWSECommerceService";
$params["AWSAccessKeyId"]   = $public_key;
$params["AssociateTag"]     = $associate_tag;
$params["Timestamp"]        = gmdate("Y-m-d\TH:i:s\Z");
$params["Version"]          = "2009-03-31";
?>
```

It should be:

```
<?php
if($region == 'jp'){
    $host = "ecs.amazonaws.".$region;
}else{
    $host = "webservices.amazon.".$region;
}

$method = "GET";
$uri = "/onca/xml";


$params["Service"]          = "AWSECommerceService";
$params["AWSAccessKeyId"]   = $public_key;
$params["AssociateTag"]     = $associate_tag;
$params["Timestamp"]        = gmdate("Y-m-d\TH:i:s\Z");
$params["Version"]          = "2011-08-01";
?>
```

Not really much change in here. All we did was to make the host a little bit flexible and level up the version a bit (from version 2009-03-31 to 2011-08-01). As of the writing of this article Amazon.co.jp is the only amazon site that doesn't work with `webservices.amazon.{region}` so we had to do that little `if` statement to check if the region that is specified is Japan.


Next create a new php file and include the class for accessing the api: 

```
require_once('amazon_api_class.php');
```

Create an instance of the class and provide the necessary details:

```
$amazon = new AmazonProductAPI($public, $private, $site, $affiliate_id);
```

The `$site` is the amazon site where the items will be fetched. By default its value is "com"


####Getting a Specific Item

First let's try getting a specific item by using an ASIN. 
You can get the ASIN of an item in amazon by scrolling down to its product details:

![amazon item ASIN](/images/posts/getting_started_with_amazon_product_advertising_api/item_asin.jpg)

Here we are specifying the ASIN of a Gundam called Heavy Arms Custom. 
One thing to remember when getting data for a specific product you must use the `ItemLookup` operation.
The ItemId is a required parameter when using the `ItemLookup` operation so it must always be present.
In the response group we specified two which is the reviews response group and the medium response group. Response group can either be one or more depending on what specific data you need. 

```php
<?php
$single = array(
	'Operation' => 'ItemLookup',
	'ItemId' => 'B0006N149M',
	'ResponseGroup' => 'Reviews,Medium'
	);
?>
```

If you want to specify more than one response group then you can use comma to separate them. The  same is true with the other parameters that you specify. So for `ItemId` you can also specify one or more ASIN's also separated by commas. But for the operation you can only have one. In the screenshot below I've specified two operations (ItemLookup and ItemSearch):

![multi operation](/images/posts/getting_started_with_amazon_product_advertising_api/multi_operation.jpg)

If you missed a parameter required by the specific operation that you have specified the API will also tell you. So for example we haven't specified the ItemId as a parameter:

![required parameters](/images/posts/getting_started_with_amazon_product_advertising_api/required_params.jpg)

It's always nice to play around with the parameters so you'll know which are possible and which are not. Different parameters renders different results.

Now if you execute the following code in the browser:

```php
<?php
$result = $amazon->queryAmazon($single);
echo "<pre>";
print_r($result);
echo "</pre>";
?>
```

You will get the following results:

```
SimpleXMLElement Object
(
    [OperationRequest] => SimpleXMLElement Object
        (
            [RequestId] => 78a46e7d-73ca-43e9-802b-956bd94878ab
            [Arguments] => SimpleXMLElement Object
                (
                    [Argument] => Array
                        (
                            [0] => SimpleXMLElement Object
                                (
                                    [@attributes] => Array
                                        (
                                            [Name] => Operation
                                            [Value] => ItemLookup
                                        )

                                )

                            [1] => SimpleXMLElement Object
                                (
                                    [@attributes] => Array
                                        (
                                            [Name] => Service
                                            [Value] => AWSECommerceService
                                        )

                                )

                            [2] => SimpleXMLElement Object
                                (
                                    [@attributes] => Array
                                        (
                                            [Name] => Signature
                                            [Value] => oiTUfIDVjKQzYKj2CA8KXoGU/hkgu+WimXaPOt6Czo8=
                                        )

                                )

                            [3] => SimpleXMLElement Object
                                (
                                    [@attributes] => Array
                                        (
                                            [Name] => AssociateTag
                                            [Value] => 
                                        )

                                )

                            [4] => SimpleXMLElement Object
                                (
                                    [@attributes] => Array
                                        (
                                            [Name] => Version
                                            [Value] => 2009-03-31
                                        )

                                )

                            [5] => SimpleXMLElement Object
                                (
                                    [@attributes] => Array
                                        (
                                            [Name] => ItemId
                                            [Value] => B002ODQJKQ
                                        )

                                )

                            [6] => SimpleXMLElement Object
                                (
                                    [@attributes] => Array
                                        (
                                            [Name] => AWSAccessKeyId
                                            [Value] => 
                                        )

                                )

                            [7] => SimpleXMLElement Object
                                (
                                    [@attributes] => Array
                                        (
                                            [Name] => Timestamp
                                            [Value] => 2013-02-11T10:37:21Z
                                        )

                                )

                            [8] => SimpleXMLElement Object
                                (
                                    [@attributes] => Array
                                        (
                                            [Name] => ResponseGroup
                                            [Value] => Reviews,Medium
                                        )

                                )

                        )

                )

            [RequestProcessingTime] => 0.0188220000000000
        )

    [Items] => SimpleXMLElement Object
        (
            [Request] => SimpleXMLElement Object
                (
                    [IsValid] => True
                    [ItemLookupRequest] => SimpleXMLElement Object
                        (
                            [IdType] => ASIN
                            [ItemId] => B002ODQJKQ
                            [ResponseGroup] => Array
                                (
                                    [0] => Reviews
                                    [1] => Medium
                                )

                            [VariationPage] => All
                        )

                )

            [Item] => SimpleXMLElement Object
                (
                    [ASIN] => B002ODQJKQ
                    [DetailPageURL] => http://www.amazon.com/GTMax-Black-Travel-Charger-Sandisk/dp/B002ODQJKQ%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB002ODQJKQ
                    [ItemLinks] => SimpleXMLElement Object
                        (
                            [ItemLink] => Array
                                (
                                    [0] => SimpleXMLElement Object
                                        (
                                            [Description] => Technical Details
                                            [URL] => http://www.amazon.com/GTMax-Black-Travel-Charger-Sandisk/dp/tech-data/B002ODQJKQ%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB002ODQJKQ
                                        )

                                    [1] => SimpleXMLElement Object
                                        (
                                            [Description] => Add To Baby Registry
                                            [URL] => http://www.amazon.com/gp/registry/baby/add-item.html%3Fasin.0%3DB002ODQJKQ%26SubscriptionId%3D%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB002ODQJKQ
                                        )

                                    [2] => SimpleXMLElement Object
                                        (
                                            [Description] => Add To Wedding Registry
                                            [URL] => http://www.amazon.com/gp/registry/wedding/add-item.html%3Fasin.0%3DB002ODQJKQ%26SubscriptionId%3D%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB002ODQJKQ
                                        )

                                    [3] => SimpleXMLElement Object
                                        (
                                            [Description] => Add To Wishlist
                                            [URL] => http://www.amazon.com/gp/registry/wishlist/add-item.html%3Fasin.0%3DB002ODQJKQ%26SubscriptionId%3D%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB002ODQJKQ
                                        )

                                    [4] => SimpleXMLElement Object
                                        (
                                            [Description] => Tell A Friend
                                            [URL] => http://www.amazon.com/gp/pdp/taf/B002ODQJKQ%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB002ODQJKQ
                                        )

                                    [5] => SimpleXMLElement Object
                                        (
                                            [Description] => All Customer Reviews
                                            [URL] => http://www.amazon.com/review/product/B002ODQJKQ%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB002ODQJKQ
                                        )

                                    [6] => SimpleXMLElement Object
                                        (
                                            [Description] => All Offers
                                            [URL] => http://www.amazon.com/gp/offer-listing/B002ODQJKQ%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB002ODQJKQ
                                        )

                                )

                        )

                    [SalesRank] => 502
                    [SmallImage] => SimpleXMLElement Object
                        (
                            [URL] => http://ecx.images-amazon.com/images/I/41betMKJ4%2BL._SL75_.jpg
                            [Height] => 75
                            [Width] => 75
                        )

                    [MediumImage] => SimpleXMLElement Object
                        (
                            [URL] => http://ecx.images-amazon.com/images/I/41betMKJ4%2BL._SL160_.jpg
                            [Height] => 160
                            [Width] => 160
                        )

                    [LargeImage] => SimpleXMLElement Object
                        (
                            [URL] => http://ecx.images-amazon.com/images/I/41betMKJ4%2BL.jpg
                            [Height] => 500
                            [Width] => 500
                        )

                    [ImageSets] => SimpleXMLElement Object
                        (
                            [ImageSet] => SimpleXMLElement Object
                                (
                                    [@attributes] => Array
                                        (
                                            [Category] => primary
                                        )

                                    [SwatchImage] => SimpleXMLElement Object
                                        (
                                            [URL] => http://ecx.images-amazon.com/images/I/41betMKJ4%2BL._SL30_.jpg
                                            [Height] => 30
                                            [Width] => 30
                                        )

                                    [SmallImage] => SimpleXMLElement Object
                                        (
                                            [URL] => http://ecx.images-amazon.com/images/I/41betMKJ4%2BL._SL75_.jpg
                                            [Height] => 75
                                            [Width] => 75
                                        )

                                    [ThumbnailImage] => SimpleXMLElement Object
                                        (
                                            [URL] => http://ecx.images-amazon.com/images/I/41betMKJ4%2BL._SL75_.jpg
                                            [Height] => 75
                                            [Width] => 75
                                        )

                                    [TinyImage] => SimpleXMLElement Object
                                        (
                                            [URL] => http://ecx.images-amazon.com/images/I/41betMKJ4%2BL._SL110_.jpg
                                            [Height] => 110
                                            [Width] => 110
                                        )

                                    [MediumImage] => SimpleXMLElement Object
                                        (
                                            [URL] => http://ecx.images-amazon.com/images/I/41betMKJ4%2BL._SL160_.jpg
                                            [Height] => 160
                                            [Width] => 160
                                        )

                                    [LargeImage] => SimpleXMLElement Object
                                        (
                                            [URL] => http://ecx.images-amazon.com/images/I/41betMKJ4%2BL.jpg
                                            [Height] => 500
                                            [Width] => 500
                                        )

                                )

                        )

                    [ItemAttributes] => SimpleXMLElement Object
                        (
                            [Binding] => Electronics
                            [Brand] => TPA
                            [EAN] => 0084331456620
                            [EANList] => SimpleXMLElement Object
                                (
                                    [EANListElement] => 0084331456620
                                )

                            [Feature] => Brand new generic charger.
                            [Label] => GTMax
                            [Manufacturer] => GTMax
                            [MPN] => VF-76-SAN-CLP-WALLC-A01
                            [PackageDimensions] => SimpleXMLElement Object
                                (
                                    [Height] => 110
                                    [Length] => 360
                                    [Weight] => 5
                                    [Width] => 350
                                )

                            [PackageQuantity] => 1
                            [PartNumber] => VF-76-SAN-CLP-WALLC-A01
                            [ProductGroup] => Network Media Player
                            [ProductTypeName] => ACCESSORY_OR_PART_OR_SUPPLY
                            [Publisher] => GTMax
                            [SKU] => NAS-B002ODQJKQ
                            [Studio] => GTMax
                            [Title] => GTMax Black Home Travel Charger for Sandisk Sansa Clip Plus 4GB 8GB
                            [UPC] => 084331456620
                            [UPCList] => SimpleXMLElement Object
                                (
                                    [UPCListElement] => 084331456620
                                )

                        )

                    [OfferSummary] => SimpleXMLElement Object
                        (
                            [LowestNewPrice] => SimpleXMLElement Object
                                (
                                    [Amount] => 1
                                    [CurrencyCode] => USD
                                    [FormattedPrice] => $0.01
                                )

                            [TotalNew] => 10
                            [TotalUsed] => 0
                            [TotalCollectible] => 0
                            [TotalRefurbished] => 0
                        )

                    [CustomerReviews] => SimpleXMLElement Object
                        (
                            [IFrameURL] => http://www.amazon.com/reviews/iframe?alinkCode=xm2&asin=B002ODQJKQ&exp=2013-02-12T10%3A37%3A25Z&v=2&sig=1hL8%2BYC95zSlZ9ngcaerOMj3TEoZhDARGrPlLN9GnfI%3D
                            [HasReviews] => true
                        )

                    [EditorialReviews] => SimpleXMLElement Object
                        (
                            [EditorialReview] => SimpleXMLElement Object
                                (
                                    [Source] => Product Description
                                    [Content] => 
Brand new non-OEM
 
Input: 100V - 240V (U.S. & World Standard)
 
LED light power indicator.
 
Best replacement for original Sansa travel charger.
 
Intelligent IC chip inside recognizes a fully charged battery and automatically switches to a saver mode to prevent overcharging and short circuit.
 
UPC Code:084331456620

                                    [IsLinkSuppressed] => 0
                                )

                        )

                )

        )

)
```

Wew! That was a lot for a single product. What more if you're fetching more than one.
Take the time to examine which specific data are returned so that you'll know how to access them later on.

As you have seen above the api returns a simple xml object so you can access the data from it just like a normal object in PHP. But here were going to convert the object into an array.

To convert a Simple Xml Object to an array you first have to convert it to a JSON string:

```
$json = json_encode($result);
```

And then use `json_decode()` to convert it to an array. 
Be sure to specify to convert it to an associative array by setting the second argument to `true`:

```
$array = json_decode($json, true);
```

You can then access it like a regular array:

```php
<?php
echo $array['Items']['Item']['ASIN'];
?>
```

One thing to remember though. Not every product has the same sets of fields. 
Just like in the real world, you can't expect a bag to have a model number since only electronic gadgets like cellphones have that.


####Getting Similar Items

You can also get items which are similar to the item that you have specified in your parameters.
Here were using the `SimilarityLookup` operation to get the items which are similar to the Gundam Heavy Arms Custom. We also have a new parameter called `Condition` which is simply the status of the item whether its new, refurbished, used or collectible.

```php
<?php
$similar = array(
	'Operation' => 'SimilarityLookup',
	'ItemId' => 'B0006N149M',
	'Condition' => 'All',
	'ResponseGroup' => 'Medium'
	);
?>
```

Here were simply looping through the results returned by the api and were outputting the image, price and the ASIN of the item:

```php
<?php
$result =	$amazon->queryAmazon($similar);
$similar_products = $result->Items->Item;
foreach($similar_products as $si){

	$item_url = $si->DetailPageURL; //get its amazon url
	$img = $si->MediumImage->URL; //get the image url

	echo "<li>";
	echo "<img src='$img'/>";
	echo "<a href='$item_url'>". $si->ASIN . "</a>";
	echo $si->ItemAttributes->ListPrice->FormattedPrice; //item price
	echo "</li>";		
}
?>
```

Here's what it will look like:

![required parameters](/images/posts/getting_started_with_amazon_product_advertising_api/similar_items.jpg)


####Item Lookup

Finally let's look at the `ItemSearch` operation. 
As I have mentioned earlier the `ItemSearch` operation simply returns all the items which matches the criteria that you have specified.

So here were trying to get some computer software which are associated with the keyword "Disney".
We also have some new paramters which we haven't used earlier. The `SearchIndex` is the category where we want to search, in this case the category is software so its expected that we only get software for the results. The `Keywords` is like the query for our search. In other words what specific software do we want to search. In this case its "disney" software. Remember that games are also software so its natural that we get some computer games back.

```php
<?php
$category = 'Software';

$params = array(
	"Operation"     => "ItemSearch",
	"SearchIndex"   => $category,
	"Keywords" => "disney",
	"ResponseGroup" => "Medium,Reviews"		
	);
?>
```

And indeed we get some computer games based on some disney films:

![disney games](/images/posts/getting_started_with_amazon_product_advertising_api/disney_games.jpg)


##Conclusion

We've barely scratched the surface with this tutorial but I hope I've been able to give you some useful information on how to get started using the Amazon Product Advertising API.


##Resources

- [Introduction to the Product Advertising API](http://docs.aws.amazon.com/AWSECommerceService/latest/DG/CHAP_Intro_AAWS.html)

- [API Reference](http://docs.aws.amazon.com/AWSECommerceService/latest/DG/CHAP_ApiReference.html)

- [Browse Node IDs](http://docs.aws.amazon.com/AWSECommerceService/latest/DG/BrowseNodeIDs.html)

- [Accessing Amazon Product Advertising API](http://www.codediesel.com/php/accessing-amazon-product-advertising-api-in-php/)

- [Response Groups](http://docs.aws.amazon.com/AWSECommerceService/latest/DG/CHAP_ResponseGroupsList.html))

- [Sample Application Source Code](https://dl.dropboxusercontent.com/u/126688107/tutorials/getting_started_with_amazon_product_api.7z)

