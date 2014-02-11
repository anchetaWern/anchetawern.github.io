---
layout: post
title: "Gettting Started with Coinbase API"
date: 2013-11-03 13:34
comments: true
categories: [coinbase-api, api, php]
published: true
---

In this article I'll be showing you how to get started developing applications which communicates with the Coinbase API. But first what is Coinbase?

{% blockquote %}
Coinbase is a service that allows you to use bitcoins as a means of payment for goods and services. 
Its like Paypal but for bitcoins.
{% endblockquote %}


<!-- more -->

First thing that you need to do is to register an account with Coinbase.

![register account](/images/posts/coinbase_api/coinbase-register.png)

Then go to your email and verify the account.

Accept the license.

![accept license](/images/posts/coinbase_api/coinbase-license.png)

Next, click on account settings and then click on the integrations tab:

![integrations](/images/posts/coinbase_api/coinbase-api.png)

Next, click on show my API key. You would need to enter your password to verify that you are indeed the account owner. Initially the API key is disabled so you need to enable it as well.

![enable api key](/images/posts/coinbase_api/enable-apikey.png)

After that, simply copy the API key that's displayed.

![copy api key](/images/posts/coinbase_api/copy-apikey.png)

The API key will be used for authenticating requests to the Coinbase API.


###Authentication

There are 2 ways in which a request to the API can be authenticated:

1. API key
2. OAuth2


####Authentication using API Key

Authenticating a request via the API Key is the easier way of making requests to the API. All you have to do is to append the api key on each request. The cool thing is you can directly execute a request to the API directly from the browser for methods that can be called via `GET`.

For example when you want to get the account balance, you simply do something like:

```
https://coinbase.com/api/v1/account/balance?api_key=xyz
```

There's a bunch of other methods which you can call directly from the browser. They're all listed [here](https://coinbase.com/api/doc/1.0.html). Do note that you can only call a method directly from the browser when its request method is `GET`. `POST` methods cannot be called directly from the browser, you need to use `curl` or `file_get_contents()` to be able to make the request.

Here's an example of using `curl` to generate  a payment button, remember to pass the API Key along with the parameters required by the specific API method:

```php
<?php
	$request = '{
		"api_key" : "xyz", 
		"button": {
	        "name": "test",
	        "price_string": "1.23",
	        "price_currency_iso": "USD"
   	 	}
	}';
    
    $post_fields = json_decode($request, true); //convert json string to an object
    $post_fields = http_build_query($post_fields); //urlencode for arrays

	$curl = curl_init();
    curl_setopt($curl, CURLOPT_POST, true); //tell curl that were posting some data along with the request 
    curl_setopt($curl, CURLOPT_POSTFIELDS, $post_fields); //the data that we want to post
    curl_setopt($curl, CURLOPT_URL, 'https://coinbase.com/api/v1/buttons'); //the request url
    
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true); //return the transfer, by default its being echoed out
	$response = curl_exec($curl); //execute the request
?>
```

The method that we have used above is the `buttons` method. It only requires 3 arguments:

- **button[name]** - the name of the item or service for which you are collecting bitcoins. 

- **button[price_string]** - the total price of the item or service.

- **button[price_currency_iso]** - the currency of the price used in the `button[price_string]` argument. Examples are `USD`, `PHP`, `SGD`, `CAD`, or `BTC` for the bitcoin currency. It would be easier if `BTC` isn't used so you won't have to convert. Simply use your local currency and the API will automatically convert it to `BTC` depending on the current exchange rate.


The response would be formatted in JSON:

```json
{
    "success": true,
    "button": {
        "code": "93865b9cae83706ae59220c013bc0afd",
        "type": "buy_now",
        "style": "buy_now_large",
        "text": "Pay With Bitcoin",
        "name": "test",
        "description": "Sample description",
        "custom": "Order123",
        "price": {
            "cents": 123,
            "currency_iso": "USD"
        }
    }
}
```

To generate the payment button, simply create a div with a class of `coinbase-button` then give it a data attribute `data-code` using the button code as its value. After that create a new script element and use the `button.js` from coinbase:

```html
<div class="coinbase-button" data-code="<?php echo $response->button->code; ?>"></div>
<script src="https://coinbase.com/assets/button.js"></script>
```

The response returned above can also be used for generating payment pages. 
All you have to do is append the button code to the coinbase checkout url:

```html
<?php
$response = json_decode($response); //convert json string to an object
?>
<a href="https://coinbase.com/checkouts/<?php echo $response->button->code; ?>">Checkout</a>
```


####Authentication using OAuth2

Authentication using OAuth2 is a bit difficult. Thankfully there are good people out there who creates libraries that makes our lives easier. One of those libraries is the [Coinbase-PHP](https://github.com/coinbase/coinbase-php) library. 

To use it, simply download the zip file from the Github repository or clone it on your machine. Once the download is done, you can just include it on your working script:

```php
<?php
require 'libs/coinbase/Coinbase.php';
?>
```

After that, you can go ahead and call the methods available from the library. In the example below were calling the `getOrders()` method which simply returns all the orders received by the merchant who owns the API Key that is used in the code. This means that every merchant who plans to integrate Coinbase in their application has to create their own Coinbase app in order to receive an API Key. The API Key will then serve as their identification for each request that is made to the API. Yes this is a bit of a drag for the merchants but that's just how it works so there's no choice but to stick with it.

```
<?php
$api_key = 'xyz';
$coinbase = new Coinbase($api_key);
$orders = $coinbase->getOrders();
?>
```

The response returned from the code above is not the same as the response that you directly get from the API.
The library already converts it to an object so there's no need to. Here's an example of looping through the orders:

```
<?php
if($orders->total_count > 0){

	foreach($orders->orders as $row){
					
		echo $row->order->created_at; 
		echo $row->order->button->description; 
		echo $row->order->status; 
		echo $row->order->total_native->cents; 
		echo $row->order->button->name; 
			
	}
}
?>
```



##Conclusion

You've learned how to perform requests to the Coinbase API. Requests can be performed directly from the browser or via Curl. You have also learned how to generate payment buttons via the API.


##Resources

- [API Documentation](https://coinbase.com/api/doc/1.0.html)
- [Coinbase-PHP](https://github.com/coinbase/coinbase-php)


