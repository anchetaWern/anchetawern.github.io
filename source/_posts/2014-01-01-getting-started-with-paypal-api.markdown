---
layout: post
title: "Getting Started with Paypal API"
date: 2014-01-08 18:15
comments: true
categories: [paypal, php, api]
published: true
---

In this tutorial I'm going to show you how you can get started with using the Paypal API. I'll walk you through the steps needed in order to get you started with using the Paypal API in your projects. 


<!-- more -->

###Concepts to Remember

Here are some of the concepts that you have to remember when working with the Paypal API in any of your projects:

- **Sandbox** - this is used for testing requests to the Paypal API. Sandbox Paypal accounts can be assigned with funds of up to 5000 USD and then you can use it for testing. 
- **Live** - the live Paypal website. You can switch your API calls to use the live endpoints upon deploying your project.
- **API Request** - you can use either NVP (Name-Value Pair) or SOAP when making request to the API. We will use name-value pairs in this tutorial.
- **API Credentials** - the credentials that you will use in order to make API calls. 
- **API** - short for Application Programming Interface. Paypal is composed of different APIs such as the adaptive accounts, adaptive payments, invoicing, merchant APIs and permissions. In this tutorial I'm going to discuss about the merchant API.
- **Service Endpoint** - this simply refers to the URL of the server that will handle a specific request. Note that the endpoints used for testing (sandbox) and production (live) are different. So you have to update the endpoints after you're done with the testing.
- **Call Payload** - the minimum data required by paypal that you have to submit as part of the request to the API.
- **Request and Response Formats** - the format in which your API request and the response that's going to be returned after a successful call.
- **HTTP Headers** - the HTTP request header information that you have to specify in each API call.


###Create a Paypal Account

First you have to create either a Paypal Personal Account or a Paypal Business Account on the Paypal website.
After creating an account go to [developer.paypal.com](https://developer.paypal.com/) and login using the account that you created.


###Create a Sandbox Account

Once you're logged in to the paypal developer website, click on the applications tab then go to sandbox accounts. In this page you will see the default paypal account that you can use for testing. The default account contains information that you can use to authenticate your API calls. In most cases you would only need to take note of the username, password and the signature in order to authenticate API calls.

![default account](/images/posts/getting_started_with_paypal/default-test-account.png)

The default test account is a business account so if you need to test on a personal account you may need to create a new test account which you can do on the same page by clicking on the `Create Account` button.

![create test account](/images/posts/getting_started_with_paypal/paypal-create-testacc.png)

The default test account along with any test account that you create can be used to login in the [sandbox paypal website](https://www.sandbox.paypal.com). This is great as you can use this like a real paypal account to view your transactions, make payments, etc.


###Getting Live API Credentials

Note that the API credentials that comes along with the default test account can't be used to make API calls with the live version of the API. For that you would need to login to [paypal](http://paypal.com) then go to **My Account** -> **Profile** -> **My Selling Tools** then click on the **update** link beside the **API Access** section. After that click on the **Request API Credentials** link. Finally, select **Request API signature** and click **Agree and Submit**. This will generate the API Username, Password and Signature that you can use in your live API calls. 


###Paypal Class

Now were ready to build the class that we will be using later on to make requests to the Paypal API. 
First create a new class and call it `Paypal`. Then declare the following class variables:

- **request method** - the request method to use. This can be either CURL or file_get_contents.
- **errors** - stores the current errors that occured while making the requests.
- **credentials** - stores the API credentials.
- **endpoint** - the URL of the service end point to use.
- **version** - the version of the API. Currently its 74.0

```php
<?php
class Paypal{

  public $request_method; 
  
  public $_errors = array();

  protected $_credentials;
  protected $_endPoint = 'https://api-3t.sandbox.paypal.com/nvp';
  protected $_version = '74.0';

}
?>
```

Next declare the constructor. This will take 3 required arguments and two optional arguments:

- **user** - the API username that you got from paypal. Note that this should correspond with the endpoint that you use. If the endpoint is a sandbox endpoint then use the sandbox credentials otherwise use the live credentials.
- **pass** - the API password
- **signature** - the API signature
- **paypal server** - this can either be set to sandbox or live. This is set to sandbox by default so its using the sandbox endpoint. Setting this to live will set the endpoint to the live endpoint.
- **request method** - the request method to use, this can be either file_get_contents or curl. Its recommended to use curl since its more secure. The file_get_contents method is only there in case the server where you are deploying has no support for CURL.

What the constructor does is to initialize the values for the class variables based on the arguments supplied when an object for the class is declared.

```
<?php
  public function __construct($user, $pass, $signature, $paypal_server = 'sandbox', $request_method = 'file_get_contents'){
    $this->_credentials = array(
        'USER' => $user,
        'PWD' => $pass,
        'SIGNATURE' => $signature,
    );

    $this->request_method = $request_method;
    if($paypal_server == 'live'){
      $this->_endPoint = 'https://api-3t.paypal.com/nvp';
    }

  }
?>
```

Next create the request method. This will be the primary method that we will call from this class once we make the request to the API. This accepts two arguments:

- **method** - the API method to use.
- **params** - the parameters required by the method that we specified.

What this method does is to build the name-value pair that will be used for the request. It also builds the required HTTP header based on the credentials supplied through the constructor earlier. Once its done building all the information required by a specific API method it makes the request depending on the request method. 

```
<?php
  public function request($method, $params = array()){
    $this->_errors = array();
    if(empty($method)){ 
      $this->_errors = array('There is no API Method');
      return false;
    }
   
    $requestParams = array(
       'METHOD' => $method,
       'VERSION' => $this->_version
    ) + $this->_credentials;

    
    $request = http_build_query($requestParams + $params); //build a query string based on the array of request parameters

    if($this->request_method == 'curl'){

      	//build the HTTP header required by Paypal
		$http_header = array(
			'X-PAYPAL-SECURITY-USERID' => $this->_credentials['USER'],
			'X-PAYPAL-SECURITY-PASSWORD' => $this->_credentials['PWD'],
			'X-PAYPAL-SECURITY-SIGNATURE' => $this->_credentials['SIGNATURE'],
			'X-PAYPAL-REQUEST-DATA-FORMAT' => 'JSON',
			'X-PAYPAL-RESPONSE-DATA-FORMAT' => 'JSON'
		);

		//set options for CURL
		$curlOptions = array (
			CURLOPT_HTTPHEADER => $http_header,
			CURLOPT_URL => $this->_endPoint,
			CURLOPT_VERBOSE => 1,
			CURLOPT_SSL_VERIFYPEER => true, 
			CURLOPT_SSL_VERIFYHOST => 2,
			CURLOPT_CAINFO => dirname(__FILE__) . '/cert/cacert.pem', //CA cert file
			CURLOPT_RETURNTRANSFER => 1,
			CURLOPT_POST => 1,
			CURLOPT_POSTFIELDS => $request
		);

		$ch = curl_init();
		curl_setopt_array($ch, $curlOptions);

		$response = curl_exec($ch); //make the request

		if(curl_errno($ch)){
			$this->_errors = curl_error($ch);
			curl_close($ch);
			return false;
		}else{
			curl_close($ch);
			$responseArray = array();
			parse_str($response, $responseArray); //convert the response string to an array
			return $responseArray;
		}

    }else if($this->request_method == 'file_get_contents'){

    	//build the HTTP header required by Paypal
		$context_options = array(
			"http" => array(
			  "method" => "POST",
			  "header"  => "Content-type: application/x-www-form-urlencoded\r\n" .
			        "X-PAYPAL-SECURITY-USERID: " . $this->_credentials['USER'] . "\r\n" .
			        "X-PAYPAL-SECURITY-PASSWORD: " . $this->_credentials['PWD'] . "\r\n" .
			        "X-PAYPAL-SECURITY-SIGNATURE: " . $this->_credentials['SIGNATURE'] . "\r\n" .
			        "X-PAYPAL-REQUEST-DATA-FORMAT: JSON\r\n" .
			        "X-PAYPAL-RESPONSE-DATA-FORMAT: JSON\r\n",
			  "content" => $request
			)
		);

		$context = stream_context_create($context_options); //create context for file_get_contents
		$response = file_get_contents($this->_endPoint, false, $context); //make the request

		$responseArray = array();
		parse_str($response, $responseArray); //convert the response string to an array
		return $responseArray;
      
    }

  }
}
?>
```

###API Methods

Before we dive into actually making an API request its important that we first understand the API methods that we will actually use. In this tutorial were only going to use 3 methods: SetExpressCheckout, GetExpressCheckoutDetails, and DoExpressCheckoutPayment. Were going to use these methods to create an application that accepts payments using Paypal.


####SetExpressCheckout

The `SetExpressCheckout` method allows you to initiate an express checkout transaction. This is the easiest way to implement a payment operation in your application. What this does is to generate a unique token that can be appended into the paypal URL which is used for making payments. The URL to be used for sandbox and live are different so you have to make sure that the URL that you're using corresponds to the current API endpoint that you're using:

- **sandbox** - https://www.sandbox.paypal.com/webscr?cmd=_express-checkout&token=UNIQUE_TOKEN
- **live** - https://www.paypal.com/webscr?cmd=_express-checkout&token=UNIQUE_TOKEN

The `SetExpressCheckout` method requires the following parameters:

- **METHOD** - must be set to `SetExpressCheckout`

- **RETURNURL** - this is the URL where the buyer will be redirected after a successful payment
- **CANCELURL** - this is the URL where the buyer will be redirected if he doesn't accept to make the payment
- **NOSHIPPING** - you can use this to specify if shipping information is enabled or not. If the customer is paying for a specific service that doesn't require shipping then you can simply set the value to `1`
- **ALLOWNOTE** - you can use this to specify if notes are allowed. You can set this to `0` if you don't want buyers to send a note along with the payment information. Otherwise set it to `1`

- **PAYMENTREQUEST_0_AMT** - the total cost of the product or service. If you have more than one item then the value for this parameter should be the total of those items. Note that any value that you supply for any parameter that requires an amount should be expressed in 2 decimal places. So if the item is worth 25 dollars then it should be written as `25.00`.
- **PAYMENTREQUEST_0_SHIPPINGAMT** - the shipping cost. If the `NOSHIPPING` is set to `1` then there's no need to supply a value for this parameter
- **PAYMENTREQUEST_0_ITEMAMT** - the cost of the product or service. Note that if you have more than one product you can simply set this to `PAYMENTREQUEST_1_ITEMAMT`, `PAYMENTREQUEST_2_ITEMAMT` and so on. Just be sure to get the total of the values that you supplied to those parameters

- **PAYMENTREQUEST_0_CURRENCYCODE** - the currency in which the `PAYMENTREQUEST_0_AMT` and `PAYMENTREQUEST_0_ITEMAMT` is expressed. Here's a [list of currency codes](https://developer.paypal.com/docs/classic/api/currency_codes/) that you can use. If you don't specify a value for this parameter the default value of `USD` will be used.

- **L_PAYMENTREQUEST_0_NAME0** - the name of the product or service
- **L_PAYMENTREQUEST_0_DESC0** - the description of the product or service
- **L_PAYMENTREQUEST_0_AMT0** - the cost of the product or service
- **L_PAYMENTREQUEST_0_QTY0** - the quantity of the product or service

After a successfull request it returns the following response:

- **TOKEN** - the token that can be appended to the URL of the paypal website where the payment can be made.


####GetExpressCheckoutDetails

The `GetExpressCheckoutDetails` method is used for getting additional information regarding a specific express checkout transaction. This is called after a payment has successfully been made through the paypal website. This happens when paypal successfully redirects to the `RETURNURL` that we specified in the `SetExpressCheckout` method.

- **TOKEN** - the token that paypal has appended to the return URL. You can get the token by using `$_GET['token']`.

After a successful request paypal returns a bunch of information regarding the payment. This includes information about the transaction itself and some payer information. Check out the [official documentation](https://developer.paypal.com/docs/classic/api/merchant/GetExpressCheckoutDetails_API_Operation_NVP/) if you want to see a full list of the response objects returned from calling the `GetExpressCheckoutDetails` method.


####DoExpressCheckoutPayment

The `DoExpressCheckoutPayment` method is used for completing the express checkout transaction. You might think that once the payment has been made its already completed but actually its not. The transaction isn't actually completed unless the payment is confirmed on both sides (paypal and your website). 

- **TOKEN** - the token that paypal has appended to the return URL. Yes this is the same as the token that you used for the `GetExpressCheckoutDetails` method.
- **PAYMENTREQUEST_n_PAYMENTACTION** - specifies how you want to obtain the payment. There are 3 possible values for this: `Authorization`, `Order`, and `Sale`. In most cases the value used here is `Sale`.
- **PAYERID** - the unique ID of the buyer. This information is also appended in the return URL, you can get it by using `$_GET['PayerID']`
- **PAYMENTREQUEST_0_AMT** - this should be the same as the value you supplied in the `PAYMENTREQUEST_0_AMT` parameter on the `SetExpressCheckout` method.
- **PAYMENTREQUEST_0_CURRENCYCODE** - this should be the same as the value you supplied in the `PAYMENTREQUEST_0_CURRENCYCODE` parameter on the `SetExpressCheckout` method.

After a successful request the express checkout transaction is now completed. 


###Making API Requests

Now were ready to actually make requests to the API. First include the file where the Paypal class is located. Then create a new object for the Paypal class:

```
<?php
require 'Paypal.php';

//get credentials from DB
$credentials = $db->get("tbl_credentials", "paypal"); 
extract($credentials);

$paypal = new Paypal($user, $pass, $signature, $paypal_server);

if(empty($_GET['TOKEN']) && empty($_GET['PayerID'])){

	$request_params = array(
	   'RETURNURL' => $success_url,
	   'CANCELURL' => $cancel_url,
	   'NOSHIPPING' => '1',
	   'ALLOWNOTE' => '1'
	);	

	$order_params = array(
	   'PAYMENTREQUEST_0_AMT' => $amount,
	   'PAYMENTREQUEST_0_ITEMAMT' => $amount,
	   'PAYMENTREQUEST_0_CURRENCYCODE' => $currency
	);

	$item = array(
	   'L_PAYMENTREQUEST_0_NAME0' => 'Oldies Anime Collection',
	   'L_PAYMENTREQUEST_0_DESC0' => 'old anime',
	   'L_PAYMENTREQUEST_0_AMT0' => $amount,
	   'L_PAYMENTREQUEST_0_QTY0' => '1'
	);	

	//initiate express checkout transaction
	$response = $paypal->request('SetExpressCheckout', $request_params + $order_params + $item);

	if(is_array($response) && $response['ACK'] == 'Success'){
		$token = $response['TOKEN'];
		//redirect to paypal where the buyer will make his payment
		header('Location: https://www.sandbox.paypal.com/webscr?cmd=_express-checkout&token=' . $token);
	}
}else{
	//after a successful redirect, complete the express checkout transaction
	$request_params = array(
		'TOKEN' => $_GET['token'],
		'PAYMENTACTION' => 'Sale',
		'PAYERID' => $_GET['PayerID'],
		'PAYMENTREQUEST_0_AMT' => $amount, 
		'PAYMENTREQUEST_0_CURRENCYCODE' => $currency
	);

	$response = $paypal->request('DoExpressCheckoutPayment', $request_params);

	if(is_array($response) && $response['ACK'] == 'Success'){
		//commit the transaction in your database
	}
}
?>
```

###Conclusion

In this tutorial you've learned the basics of making API requests to the Paypal API. We have specifically used the Merchant API. But there are other Paypal APIs which we can use for different use cases.


###Resources

 - [Paypal Classic API Getting Started Guide](https://developer.paypal.com/docs/classic/api/gs_PayPalAPIs/)
 - [Paypal Classic API Reference](https://developer.paypal.com/docs/classic/api/)
