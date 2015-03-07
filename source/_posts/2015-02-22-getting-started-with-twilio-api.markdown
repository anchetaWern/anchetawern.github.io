---
layout: post
title: "Getting Started with Twilio API"
date: 2015-02-22 07:42
comments: true
categories: [twilio, api]
published: true
---

In this article I'll be walking you through the basics of using the Twilio API in PHP. But before that, what is Twilio? Twilio is a cloud communications company. They offer APIs which developers can use to enable Text Messaging, Voice, VoIP on their apps. 

Now that we got the introduction out of the way. Let's get started.

If you don't have an account with Twilio yet now is the time to create one. You can do so from this page: [Try Twilio](https://www.twilio.com/try-twilio). After signing up, Twilio will need to verify you're a human. You can either have them call you or send you a text message containing your verification code. You'll just have to select which country you're in and then your phone number. Twilio already adds the country code as the prefix so you will only have to add your actual phone number. After you have verified your phone number, Twilio assigns you your first phone number. 

![twilio phone number](/images/posts/twilio/phone_number.png)

After that, Twilio will have you take your phone number for a spin. You can either make a call, send an SMS, receive a call, or receive an SMS.

![twilio test drive](/images/posts/twilio/test-drive.png)

Go ahead and try atleast one of those options so you have an idea how it works.

###SMS API

Twilio's SMS API allows you to:

- **Send and receive SMS or MMS** - when you signup with Twilio, you can purchase a phone number. You can then use this phone number to send text messages or multi-media messages to your users. At the same time, users can also send text messages to that phone number in order to interact with your application. How it works is that when a specific person sends a text message to the phone number that has been assigned to you by Twilio. Twilio makes an HTTP request to the URL you assigned to that phone number. The HTTP request contains the same data that the person sent. You can then use this data to have your app do what the user requested.

- **Track SMS Conversations** - this allows you to track conversations between two phone numbers through the use of HTTP cookies. These HTTP cookies are use to keep a state. Just like when you login to a specific website. Cookies allows you to continue accessing the admin pages as long as you have that cookie around. After being active for some time, the cookie expires automatically. The same idea is used when tracking conversations with Twilio. Each phone number is assigned a cookie, and this cookie is sent along with the text message on every HTTP request made by Twilio. 


####SMS API Hello World

Now were ready to write some code. First create a `composer.json` file and add the following:

```
{
    "require": {
        "twilio/sdk": "dev-master"
    }
}
```

This tells composer to require the twilio sdk for PHP. If you don't know what composer is. You can check out [getcomposer.org](https://getcomposer.org/) to get started. Once you have saved the file, execute `composer install` from your terminal to install the twilio sdk.

Next, create a new PHP file then add the following code:

```php
<?php
require 'vendor/autoload.php'; //include the twilio sdk

$sid = "xxx"; //your twilio account sid number
$token = "yyy"; //your twilio account token

$your_twilio_phonenumber = ''; //the friendly name of your twilio phone number
$phone_number_to_send_to = ''; //the phone number to send the message
$text_to_send = 'Hello world! from twilio';

$client = new Services_Twilio($sid, $token);

//send message
$message = $client->account->messages->sendMessage(
  $your_twilio_phonenumber, 
  $phone_number_to_send_to, 
  $text_to_send
);

echo $message->sid; //the message id
?>
```

From the code above, the first line includes the twilio sdk. This allows us to easily make requests to the Twilio API. Next we declare the sid and token. You can find this on your [account settings page](https://www.twilio.com/user/account/settings) under the **API Credentials** section. You can either use the live or the test credentials. The only thing to note is that when using the live credentials, your account is charged by Twilio. But if your account is in trial mode, you can only use the live credentials. Twilio doesn't charge you when your account is in trial mode. But there are [some restrictions](https://www.twilio.com/help/faq/twilio-basics/how-does-twilios-free-trial-work). Going back to the code. Next we declare the twilio phone number. If you don't know what your twilio phone number is, visit the [numbers](https://www.twilio.com/user/account/phone-numbers/incoming) page. You'll want to use the friendly name for your number. Next is the phone number where you want to send your message. This can be any phone number from any country supported twilio. Note that only United States and Canada are enabled by default. So you'll have to [enable sending a message to your country](https://www.twilio.com/user/account/settings/international/sms) if you don't live in any of those places. Just add a check mark to the country you want to send the message to. Next add the text that you want to send. Then create a new instance of the `Services_Twilio` class and supply the sid and token that we declared earlier. Finally, send the message using the `sendMessage` method. This takes up 3 arguments: your twilio phone number, the phone number to send to and the message. This method returns the following data:

- `sid` - a uniqued id assigned to the message.
- `date_created` - the date and time that the message was created.
- `date_updated` - the most recent date and time that the message was updated
- `date_sent` - normally this is empty when the request to send a message has just been made. Twilio messages doesn't seem to be sent immediately when the `sendMessage` method is called (it is queued). Therefore its only natural for this to be empty and only updated when the message is actually sent.
- `to` - the phone number where the message is sent.
- `from` - the twilio phone number that you used for sending the message.
- `body` - the actual text message.
- `status` - the status of the message, normally this has a value of 'queued' right after getting the response from the `sendMessage` method. It is then updated to 'sent' once the message is actually sent. For inbound messages, the value for this is 'received'. If the message is currently being sent, this will have a value of 'sending'. If the sending failed, it will have 'failed' as the value. 
- `num_segments` - the number of segments the message has. Text messages are only limited to 160 characters so your message is divided into 160-character segments. Each segment are then sent separately.
- `num_media` - the number of media items associated with your message.
- `direction` - can have a value of `outbound-api`, `inbound`, `outbound-call`, and `outbound-reply`. These are basically like the name suggests, `outbound-api` are the messages you have sent from your app. `inbound` are the ones that are sent from an actual phone number to your twilio phone number. `outbound-call` are the messages initiated during a call. And `outbound-reply` are messages initiated in response to an incoming SMS.
- `api_version` - the twilio api version used when the message was sent.
- `price` - the amount billed for the message.
- `price_unit` - the currency used for the price.
- `error_code` - the error code returned. This will only have a value if the value for `status` is failed. If you are having an error returned to you, be sure to check out the [errors reference](https://www.twilio.com/docs/errors/reference).
- `uri` - the uri of the resource used for sending the message.
- `subresource_uris` - the sub-resources used in sending the message. For SMS, a possible sub-resource can be the media resource.


####Dev Tools

Before we move on to writing some more code. I'd like to do a quick introduction on the dev tools offered by Twilio. Twilio's dev tools includes the following:

- **App Monitor** - allows you to monitor the requests being made to your app. These requests can be an outbound test/call to a specific phone number, or an inbound text/call to your twilio phone number. Basically, every interaction to your app are logged in the app monitor.

- **API Explorer** - allows you to make and explore API requests. This includes the parameters needed for a specific resource and the response that it returns. The good part is that it also includes code samples in different programming languages. Which you can readily copy and paste in order to test in your application. One thing to note when making requests through the API explorer is that you get charged for specific resources. An example of such resource is the resource for sending messages. 

- **Connect Apps** - allows you to create a twilio app for the purpose of letting your clients connect to it. This allows you to perform specific actions on behalf of your client. If you've ever used the Facebook API before, its pretty much the same idea. The only difference is that its your clients twilio account that is connected to your app. This is useful for clients who have their own clients. This allows you to send messages or make calls to the clients of your client on their behalf. This means all the charges are being made to your clients twilio account instead of yours if you choose to.


###Searching and Buying Phone Numbers

If your app allows your users to have their own phone numbers. You can also use the twilio API to search for available phone numbers:

```php
<?php

$area_code = 201; //only for US and Canada
$search_params = array(
    'AreaCode' => $area_code
);

//make a request to search for available phone numbers on a specific area
$numbers = $client->account->available_phone_numbers->getList('US', 'Local', $search_params);

$nums = array();
foreach($numbers->available_phone_numbers as $n){
    $nums[] = json_decode(json_encode($n->phone_number), true);
}
?>
<pre>
<?php print_r($nums); ?>
</pre>
```

You can supply the following arguments for your search:

- `AreaCode` - any valid area code in US or Canada.
- `Contains` - a regular expression for matching the characters you want the phone numbers to have.
- `SmsEnabled` - if sms capabilities are enabled. This can either be true or false.
- `MmsEnabled` - if mms capabilities are enabled. This can either be true or false.
- `VoiceEnabled` - if making and receiving calls is enabled. This can either be true or false.
- `ExcludeAllAddressRequired` - if you want to exclude the phone numbers that require an address or not.
- `ExcludeLocalAddressRequired` - if you want to exclude the phone numbers that require a local address or not.
- `ExcludeForeignAddressRequired` - if you want to exclude the phone numbers that require a foreign address or not.

Once your user has selected a number, you can then make a request to buy a phone number:

```php
<?php
$phone_number = $_POST['phone_number'];

$number = $client->account->incoming_phone_numbers->create(array(
            'VoiceUrl' => 'http://yourwebsite.com/greet',
            'PhoneNumber' => $phone_number
));
?>
```

The request requires two arguments: the `VoiceUrl`, which is the URL which you want Twilio to make a request to when this specific phone number is called by someone. We'll talk more about this on the TwiML section, which is Twilio's way for interacting with users in a call through a computer voice. The second argument is the `PhoneNumber`, which is the phone number selected by the user which came from the search results earlier. Note that making a request to purchase a phone number costs money.


###TwiML 

TwiML or the Twilio Markup Language isn't exactly a new markup language created by Twilio. Its basically just plain old XML which you can use to do all kinds of cool stuff when a user calls your twilio phone number. Here are a few examples of awesome stuff you can do with TwiML. Note that these are all performed during a call:

- **Play** - allows you to play an audio file.
- **Say** - allows you to convert text to speech. 
- **Dial** - dials another phone number that can then be added to the current call.
- **Record** - record the voice of the caller.
- **Sms** - send a text message.
- **Gather** - allows you to gather the users input. Currently inputs are only limited to numbers.

Now that you have an idea what you can do with TwiML, lets move on to some practical stuff. Let's build an app that allows the user to input a number and have a different sound played based on the number.

Start by creating a `hello.xml` file, then add the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Response>
  <Say>Hello! Please enter a number from 1 to 5</Say>
  <Gather numDigits="1" action="/choose.php" method="POST" />
</Response>
```

What this does is allows you to control the response that the user hears when they call your twilio phone number. The first line specifies the xml version and the encoding. The second line is the response wrapper. This allows us to specify the actual response that the user will hear. The first thing that the user will hear is the speech version of the text that we added inside the `Say` verb. In this case, were asking the user for a single digit number from 1 to 5. Next we use the `Gather` verb to gather the digit entered by the user. The `numDigits` attribute allows you to specify the number of digits. This has an added benefit of submitting the response immediately after the number of digits you specified matches the number of digits entered by the user. The digits entered by the user are submitted to the page you specify on the `action` attribute. In this case its the `choose.php` file in the same request URL you added to your twilio number. If you don't know how to change the request URL used by your number, then visit the [numbers page](https://www.twilio.com/user/account/phone-numbers) and click the number you want to use. That will redirect you to the settings page of that number. From there look for the voice section and then change the request url then click save. This means that if your request url is 'http://mywebsite.com' and you specified '/choose.php' as the action, then you need to have the 'choose.php' file in the root web directory of your website in order for the digits to be submitted properly.

Add the following code to the `choose.php` file:

```php
<?php
header("content-type: text/xml"); //specify content type to be xml

$digits = $_POST['Digits']; //the digit inputted by the user in his/her phone

//the array of sounds that we will be playing back to the user
$animals = array(
    'bassethound.wav',
    'cat.wav',
    'cattle.wav',
    'chicken.wav',
    'sheep.wav'
);
?>
<?xml version="1.0" encoding="UTF-8"?>
<Response>
  <Say>Here is the sound you selected</Say>
  <Play>http://mywebsite.com/sounds/<?php echo $animals[$digits - 1]; ?></Play>
</Response>
?>
```

From the code above, the first line specifies the content type to be xml. The second line is where we get the digits enterred by the user. Next we declare an array containing the sounds that we want to play. I got these sounds from [animal-sounds.org](http://www.animal-sounds.org/animal-sounds-free-download.html). Next we just set the response starting with a speech saying 'Here is the sound you selected', then we just play it back using the `Play` verb.

 
###Conclusion

Twilio's API allows you to add SMS and Voice superpowers to your apps at ease. Their documentation, quick start guides can get you up and running pretty quickly. Their code samples include some of the most popular programming languages for the web. Such as PHP, Ruby, Python, Java and .Net. If you need to add SMS and Voice capabilities to your app, there is no doubt that Twilio should be your first choice. 


###Resources

- [Twilio - Quickstart Docs](https://www.twilio.com/docs/quickstart)
- [Twilio - API Docs](https://www.twilio.com/docs/api)
- [Twilio - Helper Libraries](https://www.twilio.com/docs/libraries)
- [Twilio - How-tos](https://www.twilio.com/docs/howto)
- [Twilio - Errors Reference](https://www.twilio.com/docs/errors/reference)

