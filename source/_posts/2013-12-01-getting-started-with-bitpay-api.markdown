---
layout: post
title: "Getting Started with Bitpay API"
date: 2013-12-01 11:49
comments: true
categories: [bitpay, api, php]
published: true
---

Bitcoin is really trending these days with its value now over [$1000 per coin](http://www.extremetech.com/extreme/171762-bitcoin-hits-1000-but-how-far-can-it-go). I think its timely to explore some of the services which uses Bitcoin as a form of payment. Last time I also showed you how to [get started with the Coinbase API](http://anchetawern.github.io/blog/2013/11/03/gettting-started-with-coinbase-api/) which is also another service which allows you to use Bitcoins as a means of payment for goods and services. This time we will be exploring Bitpay. But first lets determine what's the difference between the Coinbase and Bitpay. Here's a really good answer to [this question](http://bitcoin.stackexchange.com/questions/7544/what-are-the-differences-and-similarities-among-paymium-bitpay-coinbase-etc):

{% blockquote %}
BitPay is a payment processor for E-Commerce as well as for bricks and mortar / point-of-sale. This allows a business to accept bitcoins for payment and the proceeds are delivered to the merchant as directed. This could be 100% fiat (e.g., all bitcoin sales get converted to USDs immediately, or a mix, .. like 30% USD, 70% BTCs, etc.) The currently can send payments to merchants in U.S., Mexico, Canada and several nations in Europe.
{% endblockquote %}

{% blockquote %}
Coinbase is an EWallet provider and provides a service for buying and selling bitcoins. They do not operate a market, but instead use the exchange rate from the leading exchange (Mt. Gox) for customer buying and selling. They charge just 1% to buy or sell, but they have low limits (i.e., buy a max of $100 USD per-day) for new customers still in the 30-day probationary period.
{% endblockquote %}

So what service you use basically depends on what you need.

<!-- more -->

###Signing Up

First you need to [sign up at Bitpay](https://bitpay.com/start) in order to get an API key which you can use for interacting with their API. Bitpay is really strict when it comes to the registration so you really have to provide real information about your business so that you can actually confirm it when they need some confirmation.


###Connecting to Bitpay API

The Bitpay API only requires basic HTTP authentication so the process of connecting to the API is really simple.
All you have to do is to call the `base64_encode()` method on the API key that you acquire from Bitpay and then pass it as one of the HTTP header fields. Under the `Authorization` field use `Basic` followed by the base 64 encoded string representation of the API key. Here's how to do it using `file_get_contents()`:


```php
<?php
$user = base64_encode($api_key);
		
$context_options = array(
	"http" => array(
		"method" => $method,
		"header"  => "Content-type: application/json\r\n" . 
			"Content-Length: $length\r\n" .
			"Authorization: Basic $user\r\n"
	)
);		

$context = stream_context_create($context_options);

//the $url here is the API resource that you're trying to request from
$response = file_get_contents($url, false, $context); 
$response = json_decode($response, true);
?>
```

###Creating an Invoice

You can create an Invoice via by using the following resource in the Bitpay API:

```
https://bitpay.com/api/invoice
```

Then passing in all the fields required by the resource:

- **price** - the price of the service or good.
- **currency** - any valid currency short name (USD, GBP, EUR, JPY). Here's a [full list of valid currency short names](http://www.casi.org.uk/info/1051list/annexd.html). This will be automatically converted to the corresponding value in Bitcoins (BTC) depending on the [current Bitcoin exchange rates](https://bitpay.com/bitcoin-exchange-rates).

You can also pass in some optional fields:

- **posData** - this is normally used for passing in some additional information regarding the service or good that a customer is trying to purchase
- **notificationURL** - the URL that will be pinged by Bitpay everytime the transaction status changes. Note that a change from `new` to `expired` doesn't count as a transaction status change. Bitpay will only ping the URL when the transaction status changes from `new` to `paid`, `confirmed`, or`complete`.

- **transactionSpeed** - this can be set to `high`, `medium` or `low`. High means that the invoice is considered to be confirmed after a payment has been received. Medium means it will be considered confirmed after 10 minutes. And low means it will be considered confirmed after an hour.

- **fullNotifications** - this can be set to `true` or `false`. If you want Bitpay to notify via email or via the notification url that you have set every time the transaction status changes then use `true`. If you only want Bitpay to notify once the transaction status becomes confirmed then set to `false`.

- **notificationEmail** - the email address that Bitpay will notify on every transaction status change.
- **redirectURL** - the URL in which Bitpay will display in the receipt after a payment has been made.

And here are some fields which you can use to supply information regarding the product or the customer:

- **orderID** 
- **itemDesc**
- **itemCode**
- **physical**
- **buyerName**
- **buyerAddress1**
- **buyerAddress2**
- **buyerCity**
- **buyerState**
- **buyerZip**
- **buyerCountry**
- **buyerEmail**
- **buyerPhone**


###Invoice Status

The invoice status is the status of the invoice at any given time. Here are some of the invoice states:

- **new** - Initially the invoice status is `new`. This means that someone can still initiate a payment to the Bitcoin address that is associated with the invoice. 
- **paid** - when an invoice becomes fully paid its status changes to `paid`
- **confirmed** - an invoice is considered confirmed depending on the transaction speed that was set on the creation of invoice. If the transaction speed is set to low then it will be confirmed after an hour or 6 blocks in the Bitcoin network, if the transaction speed is set to medium then it will be confirmed after 1 block (10 minutes) in the Bitcoin network, if its set to high then it will be confirmed right after full payment has been made.
- **complete** - this means that Bitpay has credited the merchant's account for the invoice.
- **expired** - this means that no payment has been received after the 15 minute limit alloted by Bitpay.
- **invalid** - this means that the invoice has been paid but has not been confirmed after an hour.


Now were ready to actually make a request to the Bitpay API. You can start by downloading the official [PHP client](https://github.com/bitpay/php-client) provided by Bitpay for interacting with the Bitpay API. There's also a [Ruby](https://github.com/bitpay/ruby-client) and [Node.js](https://github.com/bitpay/nodejs-client) client if you're developing for those.

Once you've downloaded it on your working directory open up the `bp_options.php` file and supply a value for the `apiKey`, `currency` or any of the optional fields that you would like to supply.

Create a new PHP file which we will be using to call the methods from `bp_lib.php`. To create an invoice call the `bpCreateInvoice()` method. It needs 4 arguments. The first one is the order ID which we will just supply `null` since we really don't have a system for generating order IDs. The second is the amount or the cost of the product or service. 
The third is the optional post data in which we can provide additional information for the product or service in key-value pairs. The fourth is the additional options which is primarily used for supplying information regarding the product or the customer.


```
<?php
require 'bp_lib.php';

$amount = 10;
$post_data = array(
	'name' => 'excalibur',
	'level' => '999'
);
$addl_options = array(
	'itemDesc' => 'Anime Figurine'
);

$response = bpCreateInvoice(null, $amount, $post_data, $addl_options);					
if(!empty($response)){
	//do something
}
?>
```

Bitpay returns a response similar to the following:

```
Array
(
    [id] => xxx
    [url] => https://bitpay.com/invoice?id=xxx
    [posData] => {"posData":{"name":"excalibur","level":999},"hash":"xxxx-xx"}
    [status] => new
    [btcPrice] => 0.0009
    [price] => 1
    [currency] => USD
    [invoiceTime] => 1385885490958
    [expirationTime] => 1385886390958
    [currentTime] => 1385885491133
)
```

- **id** - the unique id of the invoice
- **url** - the URL in which the invoice can be viewed
- **posData** - the additional data that we provided earlier
- **status** - the invoice status
- **btcPrice** - the corresponding amount in Bitcoins of the amount supplied earlier
- **price** - the amount that was supplied earlier when the invoice was created
- **currency** - the currency of the price
- **invoiceTime** - the time the invoice was created since January 1, 1970 midnight. This is in a UNIX timestamp format.
- **expirationTime** - the time in which the invoice will expire. When the invoice expires payments can no longer be accepted.
- **currentTime** - the current time in the Bitpay server. This is primarily used for determining the time remaining before the invoice expires.

Accessing the invoice URL will give you a page similar to the following:

![invoice url](/images/posts/getting_started_with_bitpay/bitpay-donation.png)

Customers can then use a Bitcoin client such as [Bitcoin Qt](http://bitcoin.org/en/download), [Electrum](http://electrum.org/), [Multibit](https://multibit.org/), or [Armory](https://bitcoinarmory.com/) to pay you the merchant.


###Getting Invoice Status

You can also get the status of an invoice by calling the `bpGetInvoice()` method and supplying the invoice ID as the argument:

```php
<?php
$invoice = bpGetInvoice('85AHEqCRaT2aZ3xAMpK8fQ');
?>
```

The method will return something like this:

```
Array
(
    [id] => xxx
    [url] => https://bitpay.com/invoice?id=xxx
    [posData] => Array
        (
            [name] => excalibur
            [age] => 27
        )

    [status] => new
    [btcPrice] => 0.0009
    [price] => 1
    [currency] => USD
    [invoiceTime] => 1385885490958
    [expirationTime] => 1385886390958
    [currentTime] => 1385886420720
)
```

Its basically the same as the response that we get when creating an invoice.


###Bitpay Class

Before I end this tutorial here's the modified version of the Bitpay client provided by Bitpay that works with servers without CURL support:

```php
<?php
class Bitpay{

	private $options;

	public function __construct($options){
		$this->options = $options;
	}

	public function bpLog($contents){
		$file = dirname(__FILE__).'/bplog.txt';
		file_put_contents($file, date('m-d H:i:s').": ", FILE_APPEND);
		
		if (is_array($contents))
			$contents = var_export($contents, true);	
		else if (is_object($contents))
			$contents = json_encode($contents);
			
		file_put_contents($file, $contents."\n", FILE_APPEND);			
	}

	public function bpfilegetcontents($url, $apiKey, $post = false) {
		global $bpOptions;	
			
		$length = 0;
		$method = "GET";
		if($post){	
			$length = strlen($post);
			$method = "POST";
		}
		
		$uname = base64_encode($apiKey);
		
		$context_options = array(
			"http" => array(
				"method" => $method,
				"header"  => "Content-type: application/json\r\n" . 
					"Content-Length: $length\r\n" .
					"Authorization: Basic $uname\r\n"
			)
		);		

		if($method == 'POST'){
			$context_options["http"]["content"] = $post;
		}

		$context = stream_context_create($context_options);
		$response = file_get_contents($url, false, $context);
		$response = json_decode($response, true);

		return $response;
	}
	
	public function bpCreateInvoice($orderId, $price, $posData, $options = array()) {	
		
		$options = array_merge($this->options, $options);
		
		$pos = array('posData' => $posData);
		if ($this->options['verifyPos'])
			$pos['hash'] = $this->bpHash(serialize($posData), $options['apiKey']);
		$options['posData'] = json_encode($pos);
		
		$options['orderID'] = $orderId;
		$options['price'] = $price;
		
		$postOptions = array('orderID', 'itemDesc', 'itemCode', 'notificationEmail', 'notificationURL', 'redirectURL', 
			'posData', 'price', 'currency', 'physical', 'fullNotifications', 'transactionSpeed', 'buyerName', 
			'buyerAddress1', 'buyerAddress2', 'buyerCity', 'buyerState', 'buyerZip', 'buyerEmail', 'buyerPhone');
		foreach($postOptions as $o)
			if (array_key_exists($o, $options))
				$post[$o] = $options[$o];
		$post = json_encode($post);
		
		$response = $this->bpfilegetcontents('https://bitpay.com/api/invoice/', $options['apiKey'], $post);

		return $response;
	}

	
	public function bpVerifyNotification($apiKey = false) {
		
		if (!$apiKey)
			$apiKey = $this->options['apiKey'];		
		
		$post = file_get_contents("php://input");
		if (!$post)
			return 'No post data';
			
		$json = json_decode($post, true);
		
		if (is_string($json))
			return $json;

		if (!array_key_exists('posData', $json)) 
			return 'no posData';
			
		$posData = json_decode($json['posData'], true);
		if($this->options['verifyPos'] and $posData['hash'] != $this->bpHash(serialize($posData['posData']), $apiKey))
			return 'authentication failed (bad hash)';
		$json['posData'] = $posData['posData'];
			
		return $json;
	}

	public function bpGetInvoice($invoiceId, $apiKey = false) {
		
		if (!$apiKey)
			$apiKey = $this->options['apiKey'];		
		
		$response = $this->bpfilegetcontents('https://bitpay.com/api/invoice/'.$invoiceId, $apiKey);
		if (is_string($response))
			return $response; 
		$response['posData'] = json_decode($response['posData'], true);
		$response['posData'] = $response['posData']['posData'];

		return $response;	
	}

	public function bpHash($data, $key) {
		$hmac = base64_encode(hash_hmac('sha256', $data, $key, TRUE));
		return strtr($hmac, array('+' => '-', '/' => '_', '=' => ''));
	}
}
?>
```



##Resources

- [Bitpay API Documentation](https://bitpay.com/downloads/bitpayApi.pdf)
- [Bitpay PHP Client](https://github.com/bitpay/php-client)




