---
layout: post
title: "Introduction to Facebook JavaScript SDK"
date: 2012-08-28 22:02
comments: true
categories: [facebook-api, javascript]
published: true
---

In this article I'm going share the things I learned about the Facebook JavaScript SDK.


<!--More-->


####Create an App

When were talking about the Facebook API or Facebook SDK we must first have a Facebook App.
A Facebook App doesn't necessarily reside within Facebook just like the games that we play in Facebook.
An app can be a login application that you only use to have your users login to your websites using their Facebook accounts.
An app can be basically anything which you can use to connect your website or webapp to Facebook.

To create an app go to [developers.facebook.com/apps](https://developers.facebook.com/apps)

Click on ```create new app```. 

Enter the name of your app.
![create_app](/images/posts/facebook_js_1/create_app.jpg)

Enter the captcha.
![enter_captcha](/images/posts/facebook_js_1/security_check.jpg)

After entering the captcha correctly an ```app id``` and ```app secret``` will be generated. 
The ```app id``` and ```app secret``` is what you will use on your website or webapp to connect to Facebook.
They're like connection strings for databases.

Enter your app info. What information you enter here will basically depend on the nature of your app. 
In this article I'm only going to show you the basics so I'm just going to select the ```website with Facebook login``` option.
The ```site url``` is basically the address where you want to redirect once the user has successfully logged in. 
It doesn't necessarily have to be an existing website which can be access in the internet.
For this reason I only used my ```localhost``` which is basically ```127.0.0.1```. If you're not using the default port
you can just enter something like ```127.0.0.1:8090``` where ```8090``` is the port where your web server is running.
 
![app_info](/images/posts/facebook_js_1/app_info.jpg)


####Setting up the API

Now were on the exciting part. Most of the information that I will mention here are basically based on the [Official Documentation on JavaScript SDK](https://developers.facebook.com/docs/reference/javascript/)
You might as well go there and read up the basics. But if you're like me and your eyes hurt a minute after going through the documentation then continue reading.
The documentation is pretty good but they're not making things easy to find. Some things are basically hidden until you hit up Google or Stackoverflow.

Here are some of the things that you have to remember when working with the Facebook JavaScript SDK:

 * **fb-root** - the fb root is a ```div``` with an id of ```fb-root```. It is used by the JavaScript SDK to be able to load properly. 
The ```fb-root``` is where new elements are being attached. You might ask why not just append it to the ```body``` and be done with it. I don't really know how
to answer that. Facebook has their own way of doing things.  

```html
<div id="fb-root"></div>
```

As you can see from the screenshot below the ```fb-root``` is some sort of a container for all the things that has something to do with the Facebook SDK.
![fb_root](/images/posts/facebook_js_1/fb_root.jpg)

 * **jQuery** - Another thing that you have to remember is using jQuery. It will make your life easier in selecting elements from the DOM when working with Facebook.
So go ahead and download and include it on your page.

```
<script src="jquery.js"></script>
```

 * **Facebook JavaScript SDK** - next is the Facebook JavaScript SDK itself. Include it on your page immediately. 
```
<script src="http://connect.facebook.net/en_US/all.js"></script>
``` 

In the documentation what they did was to load the JavaScript SDK asynchronously(grammar natzis forgive me if I didn't spell that right) like this:

```javascript
(function(d){
     var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement('script'); js.id = id; js.async = true;
     js.src = "//connect.facebook.net/en_US/all.js";
     ref.parentNode.insertBefore(js, ref);
   }(document));
```

They did this so that it doesn't block the loading of elements in the page. 
Its up for you to choose which method of loading Facebook SDK do you want. 
Its always recommended that you load it asynchronously if you're working on a real world website
where every millisecond counts.

 * **Channel File** - next is the channel file which contains the code below. In the documentation it said something about cross-domain communication in certain browsers.
Feel free to read that if you have lots of time but for now let's just say its important that we have that file as well. 
So go ahead and create a new file called ```channel.php``` and paste the code below.

```php
<?php
 $cache_expire = 60*60*24*365;
 header("Pragma: public");
 header("Cache-Control: max-age=".$cache_expire);
 header('Expires: ' . gmdate('D, d M Y H:i:s', time()+$cache_expire) . ' GMT');
 ?>
<script src="http://connect.facebook.net/en_US/all.js"></script>
```

 * **Initialization** - next is the initialization. Just substitute the ```YOUR_APP_ID``` with your ```app id```. 
Yes were not gonna need the ```app secret``` I don't really know why but when I used the PHP SDK its actually required. 
Might as well do some research on that but we won't die if we don't know it. 
The code below is a short version as I only used 3 key-value pairs. These are not the only options there are [more](https://developers.facebook.com/docs/reference/javascript/FB.init/)
but these are the only one's that we need right now.
 
```
FB.init({appId: "YOUR_APP_ID", status: true, cookie: true});
```

####Logging In

Were done with the essentials now its time to play. Let's go ahead and [login with Facebook](https://developers.facebook.com/docs/reference/javascript/FB.login/) using ```FB.login```.
As the name suggests ```FB.login``` is used to login to your website or webapp via Facebook. In the example below were logging in with 3 permissions that has to be approved 
by the user.
 
 * **user_about_me** - Provides access to the "About Me" section of the profile in the about property
 * **user_activities** - Provides access to the user's list of activities as the activities connection
 * **user_birthday** - Provides access to the birthday with year as the birthday property

The strings that we specify on the ```scope``` are the user information that we have access to. Check out the [permissions reference](https://developers.facebook.com/docs/authentication/permissions/) for some of
the permissions that you can use on the ```scope```. Each permission is separated by a comma ```,``` note that there are no spaces, just the comma.
If you have scanned through the permissions you might have noticed that Facebook has broken it down into specific data and not groups like ```user_information``` or ```friends_information```.

You can also have access to your friends information. Note that this is not confidential information like passwords and email as Facebook won't give you those.
You only have access to information that are allowed by your friends in their privacy settings. For example if your friend has an album where he has set that
he is the only one who can view it then you won't have access to that.

There are also extended permissions, these are actions in which the app can do like posting to the wall/timeline of your friends or publishing information
into your own wall. These extended permissions has their own authentication box(the box that you see the first time you use an app) so if an app has an extended permission
you will basically have an authentication box which has 2 pages. One for the basic permission and one for the extended permission.

```javascript
FB.login(function(response){
   if (response.authResponse) { //if the user has logged in successfully
		console.log('You are now logged in');
   } else { //problem with logging in
		console.log('User cancelled login or did not fully authorize.');
   }
 }, {scope: 'user_about_me,user_activities,user_birthday});
```

Here's what the basic permission might look like:
![basic_permission](/images/posts/facebook_js_1/basic_permission.jpg)

And here's the extended permission:
![extended_permission](/images/posts/facebook_js_1/extended_permission.jpg)

Yes you can actually deselect a specific permission if you don't want it like the 
posting in your behalf permission since its so evil. 
You're just watching something on Youtube and without you knowing it actually published a link to your timeline on the video that
you're watching. That's why its always wise to review the permissions that you're allowing before you click on the allow button.


####Accessing Data

I'll just give a simple introduction on accessing data. I want to make at least 3 posts out of this so forgive me if this post isn't
long enough or in-depth enough for you. If you want some in-depth stuff that's the job of the official documentation on the Facebook JavaScript SDK.

You can access information using ```FB.api```. But the information that you can access depends on the permissions that you have set on the ```scope``` and 
the permissions that your users has allowed. For this reason its always nice to check whether a specific permission is allowed before trying
to use it. You can check whether a specific permission is allowed using ```fql``` or the ```Facebook Query Language```. 
All you have to do is set the ```method``` to ```fql.query``` and the ```query``` to the actual query. 
Remember that Facebook doesn't allow wildcards like ```SELECT * FROM tbl``` you have to explicitly specify what fields you need. 
In the example below were reading querying the permissions table for the permissions of the current user which is basically ```me()```. 
You can also use the Facebook ID of the user.
The list of tables which you can query are in the [reference page for fql](https://developers.facebook.com/docs/reference/fql)
What were doing in the code below is to loop through the response if the current key contains ```1``` it means that the permission is allowed if its ```0``` it means its not allowed.

```
FB.api({ method: 'fql.query', query: 'SELECT publish_stream, read_friendlists FROM permissions WHERE uid=me()' }, function(resp) {
    for(var key in resp[0]) {
        if(resp[0][key] === "1"){
			console.log(key +' -available');
        }else{
            console.log(key+ ' not available');
		}
	}
});
```

As you can see from the screenshot below the response is basically an object and the information that were interested in is at index 0. 
As you can see the 2 permissions are allowed by the user so were all good.

![basic_permission](/images/posts/facebook_js_1/response.jpg)

For the last example for this article were going to fetch a list of all the friends of the current user. These information are stored
in ```me/friends``` which is some sort of a table in a database or a folder in a filesystem. 
Next we specify the fields that we need as Facebook doesn't automatically fetch the fields that you need. Facebook only fetches the default information
like the ```username``` , ```first_name```, ```last_name``` , and ```id```. Yeah it turns out that we don't actually need to specify the fields if 
what we want to access are just the basic information. But its good practice to specify the fields so you'll know what to expect. 
Of course the fields that you can fetch still depends on the permissions that the user has allowed. So you will still get some ```undefined``` if the user didn't allow it.

```
FB.api('/me/friends', {fields: 'id,first_name,last_name,username'}, function(response){

	for(var x in obj.data){
	var field = obj.data[x];
	
	var id = field['id'];
	var firstname = field['first_name'];
	var lastname = field['last_name'];
	var username = field['username'];
	
	console.log("first_name: " + firstname + "\nlast_name: " + lastname + "\nid: " + id + "\nusername: " + username);
	}
});
```


###Resources
 * [Facebook Developers](https://developers.facebook.com/)
