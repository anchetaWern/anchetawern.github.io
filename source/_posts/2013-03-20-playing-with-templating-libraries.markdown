---
layout: post
title: "Playing with Templating Libraries"
date: 2013-03-24 21:49
comments: true
categories: [templating, php, javascript, mustache, handlebars]
---

In this tutorial I'm going to walk you through some of the templating libraries 
that I'm currently using for my projects specifically the following:

- [Mustache](https://github.com/janl/mustache.js)
- [Handlebars](https://github.com/wycats/handlebars.js/)
- [Smarty](http://smarty.net/)

Mustache is available for a bunch of languages but were going to use the JavaScript version for this tutorial.
Handlebars is only available on JavaScript. And Smarty is for PHP.

You can either use chrome dev tools, JS Fiddle (or any alternatives) or a local file for this tutorial.

<!--More-->

###Mustache

Let's start by creating the two ingredients that Mustache needs in order
to create an output: a data source and a template.

####Basics

Mustache mainly accepts JavaScript objects as its data source
and an html string for the template.

{% raw %}
```javascript
var name_obj = {'name' : 'Killua Zoldyc'}; //data source
var name_template = "<h1>{{name}}</h1>"; //template
```
{% endraw %}

After that, we can call the `Mustache.to_html()` method
to merge the data source and the template together:

```
var name_html = Mustache.to_html(name_template, name_obj);
console.log(name_html);
```

You can just use jQuery or plain JavaScript to append the html contained by `name_html` variable into the DOM.


####Collections

Next let's do something less basic. 
Let's try to use a group of hunters as our data source:

```javascript
var hunters = {
	'hunters' : [
		{'name' : 'Gon', 'nen' : 'Enhancer'},
		{'name' : 'Killua', 'nen' : 'Transmuter'},
		{'name' : 'Kurapika', 'nen' : 'Conjurer'},
		{'name' : 'Leorio', 'nen' : 'Emitter'}
		]
};
```

For the template were going to make use of a table to display 
both their names and nen ability:

{% raw %}
```html
<script id="hunters" type="text/html">
	<h1>Hunters</h1>
	<table border="1">
		<tr>
			<th>Name</th>
			<th>Nen Ability</th>
		</tr>
		{{#hunters}}
		<tr>
			<td>{{name}}</td>
			<td>{{nen}}</td>
		</tr>
		{{/hunters}}
	</table>
</script>	
```
{% endraw %}

On our previous example we made use of a variable which stores an html string for the template.
But for the example above were using a `script` tag which has a type of `text/html`	and plain html on its body.

We also used a new pair of tags for looping through the items in the array:

{% raw %}
```
{{#hunters}}
  #access the value for each of the properties here
{{/hunters}}
```
{% endraw %}

The hash `#` marks the start of the loop and the forward slash `/` marks its end.
Then within those tags you can access the properties of the object. 
In our example the properties are `name` and `nen`. 


You can then append the html created from calling `Mustache.to_html()` into a container.
Just make sure you're doing it after the dom has fully loaded and you can do that by calling the
method inside jQuery's `document.read` event.

```
<div class="container"></div>
```

{% raw %}
```
var hunters_html = Mustache.to_html($('#hunters').html(), hunters);
$(function(){
	$('.container').html(hunters_html);
});
```
{% endraw %}


{% jsfiddle aj73t %}


####Arrays

In our previous example we used an object as the data source and then accessed its properties inside the loop. 
But what if the data source is an array?

For example we have this data source and we want to access the items in the `hunter_names` array:

```javascript
var hunter_names = {
	'hunter_names' : ['Gon', 'Killua', 'Kurapika', 'Leorio']
};
```

To access each of the items in the `hunter_names` array all we have to do is to place a dot `.` inside the template tags. The dot represents the current item in the array:

{% raw %}
```
<script type="text/html" id="hunter_names">
	{{#hunter_names}}
		<li>{{.}}</li>
	{{/hunter_names}}
</script>
```
{% endraw %}

{% jsfiddle Tb8pu %}


####Functions

You can also make use of functions in Mustache. 
For example we have an object which stores the items that we have added to the cart:

```javascript
var subtotal = function(){
   return this.price * this.quantity;
}; 

var cart = {
        'cart' : [
            {
                'name' : 'gundam', 
                'quantity' : 2, 
                'price' : 2500, 
                'subtotal' : subtotal
            },
            {
                'name' : 'racket',
                'quantity' : 1,
                'price' : 99,
                'subtotal' : subtotal
            },
            {
                'name' : 'flash drive',
                'quantity' : 20,
                'price' : 500,
                'subtotal' : subtotal
            }
        ]
    };
```

From the object above you can see that we have the `subtotal` property which we have assigned
to the `subtotal` function which returns the product of the `price` and the `quantity`. 

`this` simply refers to the current context where the function is being called so `this.price` simply refers to the price of the current item. 


We can then define our template. 
Note that were accessing the data from the `subtotal` property just like a normal property.
It seems like Mustache already does some of its sorcery once we call the 	`Mustache.to_html()` method which might include computing the subtotal for each item.

So you don't really have to call the method from the template just like what we normally do when accessing the value returned from a property that was assigned to a function:

```
cart.cart[0].subtotal();
```

{% raw %}
```html
<script id="functions" type="text/html">
  <table border="1">
      <tr>
        <th>Name</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Subtotal</th>    
      </tr>
      {{#cart}}
      <tr>
        <td>{{name}}</td>
        <td>{{price}}</td>
        <td>{{quantity}}</td>
        <td>{{subtotal}}</td>
      </tr>
      {{/cart}}
  </table>
</script>
```
{% endraw %}

The common use cases for functions is when checking for the existence or truthiness of a value, computing values, and adding extra markup based on a certain condition.


{% jsfiddle mGmPG/2 %}



###Handlebars

There's not really much difference between Mustache and Handlebars. 

They still use the same template tags which looks like a double mustache `{{}}`.
But the template tags also look like the Handlebars of a bicycle so maybe that's the reason behind the naming of this templating library.

Handlebars packs more features than Mustache since it has some simple logic tags which you can use like `if` , `with` and `each`. I believe templates should contain less logic as possible since templates are only for presentation. 

Just like how we keep logic to a minimum in the views when working with MVC. 
Handlebars has also limited the logic tags that we can use.

To emphasize that there isn't really much difference between Mustache and Handlebars I'll use the same object that we used earlier on our Mustache example:

```javascript
var subtotal = function(){
   return this.price * this.quantity;
}; 

 var cart = {
        'cart' : [
            {
                'name' : 'gundam', 
                'quantity' : 2, 
                'price' : 2500, 
                'subtotal' : subtotal
            },
            {
                'name' : 'racket',
                'quantity' : 1,
                'price' : 99,
                'subtotal' : subtotal
            },
            {
                'name' : 'flash drive',
                'quantity' : 20,
                'price' : 500,
                'subtotal' : subtotal
            }
        ]
};	
```

And for the template the only change that we have here is the value of the type attribute of the script tag.
In this case the value is `text/x-handlebars-template`.

{% raw %}
```html
<script id="functions" type="text/x-handlebars-template">
  <table border="1">
      <tr>
        <th>Name</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Subtotal</th>    
      </tr>
      {{#cart}}
      <tr>
        <td>{{name}}</td>
        <td>{{price}}</td>
        <td>{{quantity}}</td>
        <td>{{subtotal}}</td>
      </tr>
      {{/cart}}
  </table>
</script>	
```
{% endraw %}

Handlebars isn't really picky when it comes to the value of tye `type` attribute.
You can actually use `text/html` as the value or nothing at all. 

But its a good practice to always specify the `type` so that other people will know what that specific `script` tag is all about. Plus I haven't really tested if the two tags below would really work in all possible scenarios.

```html
<script type="text/html"></script>
	
<script></script>
```

Finally we can just call `Handlebars.compile` and supply the html string of our template as an argument to create the template. We can then call the template and supplying the data source `cart` as the argument then assign it as the html of the container:

```
var cart_html = Handlebars.compile($('#functions').html());
$('.container').html(cart_html(cart));
```

{% jsfiddle H8Bac %}

In the above example we did not explicitly specify that we want to loop through the items in the cart.
In handlebars there's actually an alternative syntax for looping through the items in an array. 
And that is by using the `each` keyword followed by the name of the array.

{% raw %}
```html
{{#each cart}}
<tr>
  <td>{{name}}</td>
  <td>{{price}}</td>
  <td>{{quantity}}</td>
  <td>{{subtotal}}</td>
</tr>
{{/each}}
```
{% endraw %}

####With

`With` is used to change the context on which the properties that are accessed inside of it are called.

First lets define our data source:

```javascript
var hunter = {
	'family_occupation' : 'assassin',
	'hunter' : {
		'name' : 'killua zoldyc', 
		'ability' : 'transmuter'
	}
};
```

Then our template:

{% raw %}
```html
<script id="hunter" type="text/x-handlebars-template">
	{{#with hunter}}
		<h1>Name: {{name}}</h1>
		<h2>Ability: {{ability}}</h2>
		<h3>Family: {{../family_occupation}}</h3>
	{{/with}}
</script>

<div class="name"></div><!--container-->
```
{% endraw %}

As you can see from the template above we have change the context to `hunter` so any properties that are defined inside the `hunter` object will be accessible as long as they are within the `with` tags.

But if you want to access properties outside of the current context you can use `../` just like what we do when stepping back a single directory when linking assets relatively in html. 
From our example the `family_occupation` property is outside the `hunter` object so we've used `../` to step back.

{% jsfiddle ZprP6 %}



####If

`if` is used to check for the [truthiness](http://james.padolsey.com/javascript/truthy-falsey/) of a value.
It can be used along with `else` to output something else in case a value is not present.

In our object below there is no value for the `box_weapon` of the first member.

```javascript
var family = {
    'member' : [
        {
            'name' : 'reborn',
            'box_weapon' : ''
        },
        {
            'name' : 'tsunayoshi sawada',
            'box_weapon' : 'sky lion'
        },
        {
            'name' : 'hibari kyoya',
            'box_weapon' : 'cloud hedgehog'
        },
        {
            'name' : 'gokudera hayato',
            'box_weapon' : 'storm leopard'
        },
        {
            'name' : 'takeshi yamamoto',
            'box_weapon' : 'rain swallow'
        },
        {
            'name' : 'ryohei sasagawa',
            'box_weapon' : 'sun kangaroo'
        },
        {
            'name' : 'lambo',
            'box_weapon' : 'lightning bull'
        },
        {
            'name' : 'rokudo mukuro',
            'box_weapon' : 'mist owl'
        }
    ]
};
```

We can then use `if` and `else` to check if the value is present or not and output something else if the value is not present:

{% raw %}
```html
<script id="ifs" type="text/x-handlebars-template">
  <h1>vongola</h1>
  <table border="1">
      <tr>
        <th>Family Member</th>
        <th>Box Weapon</th>
      </tr>
      {{#each member}}
      <tr>
        <td>{{name}}</td>
        {{#if box_weapon}}
        	<td>{{box_weapon}}</td>
        {{else}}
        	<td>No box weapon</td><!--if value is not present-->
        {{/if}}
      </tr>
      {{/each}}
  </table>
</script>

<div class="family"></div><!--container-->
```
{% endraw %}

{% jsfiddle J8qXs %}


####Helpers

Finally there are `helpers` which are like functions that you can call inside your Handlebars template.
They can be used to extend the functionality that Handlebars already provides by default.

For our example let's define the data source which is just an array of numbers from 1 to 10:

```javascript
var numbers = {
    'numbers' : [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
};
```


Then let's define our handlebars helper. You can define a helper by calling `Handlebars.registerHelper`. 
The first argument is the name of the helper, in this case the name is `multiply_by_10`.
The second argument is the callback function which contains the logic or the process that you want to perform with the data that you specify. The data that you want the function to use are specified as arguments. In this case we have the `num` variable. The helper below simply returns the value returned from multiplying the argument `num` with the number 10. 

```
Handlebars.registerHelper('multiply_by_10', function(num){
  return num * 10;
});
```

We can then create the template and call the helper that we just created, supplying the current item in the array of numbers. The current item in an array is represented by `this` in Handlebars.


{% raw %}
```html
<script id="helpers" type="text/x-handlebars-template">
{{#each numbers}}
    <li>{{multiply_by_10 this}}</li>
{{/each}}
</script>

<div class="num_container"></div><!--container-->
```
{% endraw %}

Let's do another example, this time were going to use the cart object that we used earlier.
But now we'll remove the `subtotal` property since we will let our helper take care of that.

```javascript
var cart = {
        'cart' : [
            {
                'name' : 'gundam', 
                'quantity' : 2, 
                'price' : 2500
            },
            {
                'name' : 'racket',
                'quantity' : 1,
                'price' : 99
            },
            {
                'name' : 'flash drive',
                'quantity' : 20,
                'price' : 500
            }
        ]
};
```

For this example were going to use two helpers. 
One will return the header for the table. And the other one will compute the subtotal.

Here's the helper that returns the header:

```
Handlebars.registerHelper('get_headers', function(obj){
  var table_headers = '';
  
  for(var x in obj){
    if(obj.hasOwnProperty(x)){
        table_headers += "<th>" + x + "</th>";
    }
  }
  
  return new Handlebars.SafeString(table_headers);
});
```

What were doing in the code above is looping through the properties of the object that we specified
and then wrapping it in `th` tags. The current property is represented by the value stored in the variable `x`.
We then append this value to the the `table_headers` variable.

After looping through all of the properties of the object we then return the string accumulated by the `table_headers` variable. We have to return a `new Handlebars.SafeString(html_string)` because Handlebars automatically escapes HTML tags. This is a way of telling Handlebars not to escape the specific HTML that were trying to return from the helper.


{% jsfiddle tENVa %}


####JSON

Finally were going to use real world data to supply to our template. 
Twitter really makes it easy to retrieve the tweets of a specific user as long as the tweets are set to public
so were going to make use of the data from Twitter as the data source for our templates.

Here's our template:

{% raw %}
```html
<script id="tweets">
    <h1>Wern Ancheta</h1>
    {{#each tweets}}
    <ul>
      <li>{{linkify text}}</li>
    </ul>
    {{/each}}
</script>

<div class="tweets_container"></div><!--container-->
```
{% endraw %}

Then extend the String prototype by adding a method called `replaceArray` this method will take two arrays as arguments. All it does is to loop through the `find` array and replaces the current item in the `find` array with the current item in the `replace` array and then assign it back to the original string which is represented by `this`. After looping through all of the items it just returns the string which now has been replaced with the items in the `replace` array:

```javascript
function replaceArray = function(find, replace) {
  var replaceString = this;
  var find_length = find.length;

  for (var i = 0; i < find_length; i++) {
    replaceString = replaceString.replace(find[i], replace[i]);
  }
  return replaceString;
};
```

Next, create a helper that would change the url's in a specific tweet to a link that can be clicked:

```
Handlebars.registerHelper('linkify', function(text){
    var linkified = [];
    var urls = text.match(/(\{(.+?)\}:)?(http:\/\/[\w\-\.]+\.[a-zA-Z]{2,3}(?:\/\S*)?(?:[\w])+)/g);
    if(urls){
        var url_count = urls.length;
        for (var i = 0; i < url_count; i++) {
            var url_string = "<a href='" + urls[i] + "'>" + urls[i] + "</a>";
            linkified.push(url_string);
        }
        return new Handlebars.SafeString(text.replaceArray(urls, linkified));
        
    }else{
        return text;
    }
});
```

In the code above were using regex to extract only the urls from the tweet.
For example we have this tweet:

```
really nice interactive course on chrome developer tools http://t.co/wHdyEMnWjG
```

Using the regex that we have above the `urls` variable will contain a single item:

```
[http://t.co/wHdyEMnWjG]
```

We then loop through all of those url's and wrapping it in anchor tags and then push it to the `linkified` variable.

```
for (var i = 0; i < url_count; i++) {
  var url_string = "<a href='" + urls[i] + "'>" + urls[i] + "</a>";
  linkified.push(url_string);
}
```

Then we call the `replaceArray` method that we created earlier to replace all the url's in the tweet to a url wrapped in anchor tags. Then we use it as an argument of the `Handlebars.SafeString` method so that Handlebars would not escape the HTML:

```
return new Handlebars.SafeString(text.replaceArray(urls, linkified));
```

In case there's no url in the current tweet we simply return the tweet without doing anything to it:

```
return text;
```

Finally we can compile the template for the tweets and then issue an AJAX request to the Twitter API to get the tweets.
The `dataType` should be `jsonp` since we can't really make a request to another domain if we don't specify the data type as `jsonp`. If you want to learn more about it check out this question at stackoverflow: [What is jsonp all about](http://stackoverflow.com/questions/2067472/what-is-jsonp-all-about).

Once the request succeeded we can then replace the HTML of our tweets container with the HTML string returned from merging the template with the data coming from Twitter:


```
var tweets_template = Handlebars.compile($('#tweets').html());

$.ajax({
    url: 'https://api.twitter.com/1/statuses/user_timeline.json?screen_name=wern_ancheta&count=5&exclude_replies=true',
    dataType: 'jsonp',
    success: function(tweets){
        
        $('.tweets_container').html(tweets_template({'tweets' : tweets}));
    }
});
```

{% jsfiddle aZra5 %}



###Smarty

The last library that were going to play around today is the Smarty templating engine for PHP.
And for that you need to download Smarty over at [smarty.net](http://www.smarty.net). 

The main smarty file is the `Smarty.class.php` stored in the `libs` directory.
Include it on your working file and then do the housekeeping (make an instance of the smarty class, set the template directory):

```php
<?php
require_once 'libs/Smarty.class.php';

$smarty = new Smarty;
$smarty->setTemplateDir('smarty_templates'); //this is where all your template files are stored
?>
```

Next create a template under the `smarty_templates` directory. 
The file extension for smarty templates is `.tpl`.

Next, we create our data source:

```
<?php
$names = array(
  'Yoh Asakura', 'Ichigo Kurosaki', 
  'Uzumaki Naruto', 'Edward Elric', 
  'Alibaba Saluja', 'BK201', 'Luffy'
);
?>
```

Then assign a template variable and call it `names`. 
You can use the  `assign` method to assign template variables.
It takes up 2 arguments which is the name of the variable and then the variable which stores the data.

```
<?php
$smarty->assign('names', $names);
?>
```

Note that the name of the variable doesn't necessarily need to be the same as the name you gave to the variable which stores the data. So you can also have something like:

```
<?php
$smarty->assign('anime', $names);
?>
```

For our template we simply loop through the items in the array.
Here were using `foreach` to loop through the items. 

{% raw %}
```html
<h1>Anime</h1>
{foreach $names as $n}
  <li>{$n}</li>
{/foreach}
```
{% endraw %}

For our final example were just going to reuse the cart that we had earlier:

```php
<?php
$cart = array(
  array(
    'name' => 'racket',
    'price' => 200,
    'quantity' => 5
    ),
  array(
    'name' => 'table',
    'price' => 500,
    'quantity' => 4
    ),
  array(
    'name' => 'bat',
    'price' => 300,
    'quantity' => 7
    )
);
?>
```

And for the template:

{% raw %}
```html
<h2>Cart</h2>
<table border="1">
  <!--Loop through the properties of the first item (name, price, quantity)-->
  <tr>
  {foreach $cart[0] as $h => $p}
    <th>{$h}</th>
  {/foreach}
  </tr>
  {foreach $cart as $i}
  <tr>
    <td>{$i.name}</td>
    <td>{$i.price}</td>
    <td>{$i.quantity}</td>
  </tr>
  {/foreach}
</table>

There are {$cart|count} items in the cart.
```
{% endraw %}

Some of the functions that you can use on PHP can also be used inside Smarty templates. 
For the code above we have used the `count` function. To use a function inside a template you simply specify the value that you want to supply as the argument of the function and then followed by a pipe `|` and then the function name, in this case the function name is `count` which simply returns how many items are in the array that was specified.



##Conclusion

There's not really much difference between PHP and Smarty syntax and you can actually do everything in PHP if you like. 

But why would we need to use templates instead of just plain PHP?

Because templates has much more cleaner syntax and it encourages code reuse.
Sometimes in our projects we need to make use of the same HTML structure for
the data that were presenting and often times we just repeat ourselves.
Using a template can help make our code DRYer.

Another reason is that by using Smarty and other templating engines we can avoid writing something like this:

```php
<?php
$html_str   = "<h1>Heading</h1>";
$html_str  .= "<ul>";
foreach($items as $row){
  $html_str  .= "<li>" . $row['name'] . "</li>";
}
$html_str  .= "</ul>";

echo $html_str;
?>
```

Or something like this:

```
<?php
ob_start();
?>
<h1>Heading</h1>
<ul>
<?php
foreach($items as $row){
?> 
  <li><?php echo $row['name']; ?></li>
<?php
}
?>
</ul>
<?php
$html = ob_get_contents();
ob_end_flush();
echo $html;
?>
```

The code above doesn't really look great and we can avoid having to write those kinds of codes by using templates.
This is true for all the templating libraries that we have gone around in this article and others which we haven't tackled.