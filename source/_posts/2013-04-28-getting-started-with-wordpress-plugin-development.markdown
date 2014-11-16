---
layout: post
title: "Getting Started with Wordpress Plugin Development"
date: 2013-05-26 16:22
comments: true
categories: [wordpress, wordpress-plugin-development]
published: true
updated: 2013-09-29
---

In this article I'm going to walk you through process of creating Wordpress plugins. 
First I'm going to talk about some of the basic concepts in Wordpress plugin development like the actions, hooks, and API's that makes up Wordpress. Then were going to build a plugin where we apply some of the concepts and best practices in developing Wordpress plugins. 


<!--More-->


###Prerequisites

In order to fully benefit from this tutorial you should have a basic knowledge on PHP.
As Wordpress is running on PHP and most of the code that we will be writing will be on PHP.
A little bit of knowledge on HTML, CSS and JavaScript is also helpful but not required for this tutorial.


###Folder Structure

Download Wordpress from [Wordpress.org](http://wordpress.org/download/) and extract its contents on the web accessible folder. It's usually the `public_html`, `www` or `htdocs` folder in your server. 
Here's how the folder structure looks like:

![wordpress folder structure](/images/posts/getting_started_with_wordpress_plugin_development/folder_structure.png)

That's a lot of files and folders but there are only a few of those that we will have to touch:

- **wp-content** - this is where the plugin and theme files are stored.
- **wp-config.php** - the Wordpress configuration file where you can specify things like the database settings, character set, authentication unique keys and salts, language and many others. You can see all the possible settings from this page: [Editing wp-config.php](http://codex.wordpress.org/Editing_wp-config.php).


And under the `wp-content` folder:

- **languages** - this is where the site-wide language files are stored. They're usually in `.mo` files.
- **themes** - this is where the theme files are stored. Every theme has its own folder. 
- **plugins** - this is where the plugin files are stored. Like the theme files each plugin also has its own folder.
- **uploads** - this is where the files that were uploaded by the users goes.

If you don't know how to install Wordpress check out the guide at Wordpress codex: [Installing Wordpress](http://codex.wordpress.org/Installing_WordPress)


###Things to Remember

Here are some of the things that you have to remember when creating Wordpress plugins.


####Enable WP-DEBUG

First you have to enable `wp_debug` since its not enabled by default. 
Open up the `wp-config.php` file which you can find on the Wordpress root directory and add the following line:

```
//enable error reporting in Wordpress
define('WP_DEBUG', true);
```

When `wp_debug` is enabled the error reporting is set to `E_ALL` which means that all PHP warnings, notices and errors are outputted on the screen. By default Wordpress doesn't display these errors mainly because every Wordpress installation is production-ready. And you would never really want your users to see those errors. 



####Use Wordpress functions

Always use some of the built-in Wordpress functions when writing plugins or themes.
This is the trap where most beginners fall. And I admit that I also fell to this trap when I was just starting to get my way through wordpress. 
Beginners often do things like they normally do in PHP. For example instead of using the `wp_remote_get()` function they use `curl` or `file_get_contents()`.
Instead of using `$wpdb` they use `MySqli` or a third-party library to access the database. There's a lot of functions built into Wordpress that allows you to do almost anything so be sure to check out the [function reference](http://codex.wordpress.org/Function_Reference) first before you write a single line of code that uses PHP functions.


####Use Tools

Aside from the text-editor there are also other tools that you can use for developing Wordpress plugins and web development in general. Here are some of the tools that I recommend:

- [Chrome Developer Tools](https://developers.google.com/chrome-developer-tools/) - general web development tool.
- [Wordpress Debugger](http://wordpress.org/extend/plugins/debugger/) - debugging plugin for Wordpress.
- [Cron View](http://wordpress.org/extend/plugins/cron-view/) - allows you to view the tasks scheduled in wp-cron.
- [Wordpress Plugin Boilerplate](https://github.com/tommcfarlin/WordPress-Plugin-Boilerplate) - template for building Wordpress plugins.
- [Sublime Text Editor](http://www.sublimetext.com/)


####Use Best Practices

You have to develop Wordpress plugins using some of the best practices that are favored by the community in general. This will make your code more readable, more maintainable, more consistent and more secure. 

- [CSS Coding Standards](http://make.wordpress.org/core/handbook/coding-standards/css)
- [JavaScript Coding Standards](http://make.wordpress.org/core/handbook/coding-standards/javascript)
- [HTML Coding Standards](http://make.wordpress.org/core/handbook/coding-standards/html)
- [PHP Coding Standards](http://make.wordpress.org/core/handbook/coding-standards/php)
- [10 Must Know Skills for a Wordpress plugin Developer](http://www.sitepoint.com/10-must-know-skills-for-a-wordpress-plugin-developer/)

I recommended reading through some of the standards above then decide for yourself which to follow and apply to your own projects. At the end of the day you should only follow what specific coding style feels right for you.

Here are some of the coding standards that I specifically apply to my own projects:


#####HTML

- Use HTML5 when creating Wordpress plugins and themes. To use HTML5 all you have to do is specify the HTML5 doctype `<!DOCTYPE html>`.

Then you can start using some of the HTML5 elements and attributes:

```html
<header>
	<nav></nav>
</header>

<aside></aside>

<article>
	<section>
		<div data-id="1">
			<input type="text" data-name="lee" data-age="18">
		</div>
	</section>
</article>

<footer></footer>
```


- Single-space before closing self-closing tags.

```
<hr />
<br />
<link href="style.css" rel="stylesheet" />
```

- Comments when closing elements. Text-editors can already highlight the closing tags for a specific element if you click on its opening tag but its always nice to have visual on which tags closes what.

```
<article class="story-container">
	<div id="person">
		<span class="details"></span>
	</div><!--/#person-->
</article><!--/.story-container--> 
```


#####CSS

- Single space after the property.

```css
#container{
	width: 200px;
	border: 1px solid red;
}
```

- New line for each selector.

```
.dragon,
.pig,
.rat{
	color: blue;
	height: 20px;
}
```

- Avoiding slow selectors. Always remember that css is read by the browser from left to right. 
For example we are selecting all the anchor tags in our container:

```
#container a{
	color: brown;
}
```

Converting this css selector to plain english we get: select the element with an id of `container` and then select all the anchor tags within it.

But this is how the browser reads it: select all the anchor tags and then filter it down to just the tags that are within the element with the id of `container`.

Just by reading it in plain english we know that the latter takes more time.

Go through this article: [Writing efficient css selectors](http://csswizardry.com/2011/09/writing-efficient-css-selectors/) and learn how to write faster css selectors.


#####JavaScript 

- Use jQuery, Mootools or any other library that makes it easier for you to write code that will work across different browsers.

- Don't use reserved words when naming variables. This is true for other programming languages as well. If you're not certain that the variable that you're going to use is a reserved word then just do a quick google search or check out this [list of reserved words](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Reserved_Words) from the Mozilla Developer Network.

- Use `var` when declaring every variable. I prefer doing it this way:

```javascript
var fname = 'gon';
var lname = 'freecs';
```

Instead of this:

```
var fname = 'gon', lname = 'freecs';
```


- Always use semi-colons where appropriate. Some developers prefer to ommit the semi-colons because of this automatic semi-colon insertion thing on the browser. This makes semi-colons kinda not required for some instances because the browser already does it for you. 

- Use bracket notation when declaring arrays.

```
var names = ['gon', 'killua', 'kurapika', 'ponzo', 'hisoka'];
```

- Use the curly bracket notation when declaring objects.

```
var person = {
	'fname' : 'killua',
	'lname' : 'zoldyc',
	'nen_type' : 'transmutation',
	'abilities' : ['lightning palm', 'thunderbolt', 'godspeed']
};
```

- Always wrap the properties of an object in single-quotes. They're not really required if the property doesn't use dashes or any other fancy character but its always nice to have consistency.

- Always use the bracket notation to access values from objects and arrays.

```
console.log(person['fname']);
console.log(person['lname']);
```

The dot notation looks a bit easier to write but its limited to just strings without special characters.
You can't also use the dot notation to access array indexes:

```
console.log(person.fname);
console.log(person.lname);

console.log(names.1); //this is not possible 
```

- Always use `break` when using `switch` statements:

```
var names = ['gon', 'killua', 'kurapika', 'ponzo', 'hisoka'];

switch(names[0]){
	case 'gon':
	break;

	case 'kurapika':
	break;

	case 'hisoka':
	break;
}
```

In some cases you may want to use a fallthrough like the one below to continue execution on the next case if a single case has been met. But you normally wouldn't want to do that. Mainly becase of maintenance issues later on. You will ask yourself: "did I forgot the break here or I really intended this one to fall through?".

```
switch(names[0]){
	case 'gon':
	break;

	case 'kurapika':

	case 'hisoka':
	break;
}
```

- Use `for` loops instead of `for in` loops. 
Mainly because its faster (atleast according to benchmarks). And there's really very little use case for `for in` loops. Everything you can do with `for in` loops you can actually do by just using a `for` loop. 
Take the following example:

```
for(var d = 0; cnt = names.length, d < cnt; d++){
  var fullname = names[d]['fname'] + " " + names[d]['lname'];
  console.log(fullname);
}
```

You can always do the example above by using a `for in`. It also looks cleaner and more concise.
But I always prefer `for` loops because its more performant. 

```
for(var y in names){
  var fullname = names[y]['fname'] + " " + names[y]['lname'];
  console.log(fullname);
}
```

- Cache DOM selections when you atleast want to use those selections in 2 or more places.

```
var container = $('#container');
container.html(html);
if(container){
	//do something
}
```


#####PHP

- PHP tags should always be written like this:

```php
<?php
	echo 'hello world!';
?>
```

And not this:

```
<?
	echo 'hello world!';
?>
```


- Always include opening and closing curly braces when using `if` statements even if you don't think that there will be other things to add inside your `if` statements later on. 
So I always favor this:

```
<?php
$animal = 'dog';
if($animal == 'dog'){
	echo 'its a dog<br />';
}else{
	echo 'its a cat<br />';
}
?>
```

Instead of this:

```
<?php
$animal = 'dog';
if($animal == 'dog')
	echo 'its a dog<br />';
else
	echo 'its a cat<br />';
?>
```

The second version looks much more cleaner but see what happens when you add another line after the else:

```
<?php
$animal = 'dog';
if($animal == 'dog')
	echo 'its a dog<br />';
else
	echo 'its a cat<br />';
	echo 'duh';
?>
```

You would expect that the second line will only be outputted when the animal is a cat. But the actual output would be:

```
its a dog
duh!
```

Ommitting the curly braces only works when there's only a single line of code inside of it.
PHP actually interprets the code this way:

```
<?php
$animal = 'dog';
if($animal == 'dog'){
	echo 'its a dog<br />';
}else{
	echo 'its a cat<br />';
}
echo 'duh';
?>
```

- Variables should be named in a smart and concise way. You don't want variable names that are too long like `$first_prime_number`. Each variable should directly communicate what the value it stores is all about like `$amazon_id` or `$flickr_key`.

- Always start a new line if the line of code gets longer than the length of the whole text-editor when in its full size. I always prefer this:

```
<?php
function zam_get_user($id = ''){

	$wpdb->query(
		$wpdb->prepare(
			"SELECT username FROM $wpdb->users WHERE ID = %d", $id 
			));
}
?>
```

Instead of this:

```
<?php
function zam_get_user($id = ''){

	$wpdb->query( $wpdb->prepare( "SELECT username FROM $wpdb->users WHERE ID = %d", $id ) );
}
?>
```

- Always use prepared statements when accessing the database. 
This will improve the database security for your plugin. 
Prepared statements prevents [sql injection](http://en.wikipedia.org/wiki/SQL_injection) which is basically the use of clever techniques to get the data out of your database by manipulating sql code.

Using [prepared statements](http://en.wikipedia.org/wiki/Prepared_statement) in wordpress is easy. You just have to use the `$wpdb->prepare()` method to create a prepared statement. What makes it secure is that the query is compiled first along with the placeholders and then later on the parameters are assigned to the compiled query. Lastly it will be executed. Yes I know I haven't explained that really well but if you've used templating engines like Smarty, handlebars, or mustache before the idea of prepared statements is pretty much similar. First the template is compiled, in the case of prepared statements its the query along with the placeholders. Once its compiled the parameters for that query are assigned to the template. Lasty its executed to produce the actual results of that specific query.
Anyway here's an example on how to use a prepared statement in wordpress:

```
<?php
function zam_get_user($id){
	global $wpdb;
	$row = $wpdb->get_row(
		$wpdb->prepare(
			"SELECT fname, lname FROM $wpdb->users WHERE ID = %d", $id
			));

	return $row;
}
?>
```

- Use code formatting tools whenever you feel lazy implementing a specific coding convention. I personally use [Sublime PHP tidy](https://github.com/welovewordpress/SublimePhpTidy) to format the code to make it compliant to the Wordpress coding standards because some of the coding standards just doesn't feel right for me.
For example this specific block of code is preferred by the Wordpress community:

```
<?php
if ( $animal == 'dog' ) {
	echo 'its a dog<br />';
} else {
	echo 'its a cat<br />';
}
?>
```

While I prefer this:

```
<?php
$animal = 'dog';
if($animal == 'dog'){
	echo 'its a dog<br />';
}else{
	echo 'its a cat<br />';
}
echo 'duh';
?>
```

See the difference? I believe there's too much spaces in the first one and I'm too lazy to press the spacebar everytime I need to add those spaces. That's why its always nice to have tools like Sublime PHP Tidy to do the formatting for you. Another nice plugin is the [Sublime Alignment](https://github.com/wbond/sublime_alignment) which just allows you to select a block of code and have it aligned like this:

```
<?php
$name  = 'Eren';
$lname = 'Jaeger';
?>
```

- Namespace all your classes, functions and variables. 
This is because other plugins might be using the same variable names or function names.
This will lead to conflicts in the code and may cause errors since the default values are already overriden something that is not supposed to be the correct value.
Namespacing is a good precaution to prevent this from happening.
If you're writing your code in a procedural way then you should namespace all the variables and functions.
If you're writing your code in an object-oriented way then you should be fine with just namespacing the class since the class already encapsulates everything within.

You can namespace your methods and variables by simply prefixing it with your name and the name of the plugin.
For the plugin that were trying to create it will look something like this:

```
<?php
function nrue_zam_get_users(){
	
}
?>
```

But you can also have just the plugin name if you think the name of your plugin is unique enough and you have already done a google search for that specific plugin name. If it doesn't exists yet then you're good to go.

```
<?php
function zam_get_users(){
	
}
?>
```

If you're writing your plugin in an object-oriented way there's no need to namespace variables and methods that are inside the class. You just need to be sure that your plugin name is unique:

```
<?php
class zam{

	private $id;
	
	public function get_users(){

	}
}
?>
```

#####Data Validation

Always remember to use data validation techniques in both the client and the server side.
You need client side because you don't want the user to wait for a whole page refresh before he's informed that the data that he inputted is actually invalid. You also need server-side because some malicious users might try to compromise the site or even innocent users which didn't format their input very well. 
Wordpress has actually got our back covered because of the built-in data validation methods that they have:

- [esc_html](http://codex.wordpress.org/Function_Reference/esc_html)
- [esc_attr](http://codex.wordpress.org/Function_Reference/esc_attr)
- [esc_js](http://codex.wordpress.org/Function_Reference/esc_js)
- [esc_url](http://codex.wordpress.org/Function_Reference/esc_url)
- [$wpdb->prepare](http://codex.wordpress.org/Class_Reference/wpdb#Protect_Queries_Against_SQL_Injection_Attacks)
- [esc_sql](http://codex.wordpress.org/Function_Reference/esc_sql)

Be sure to check out each of these methods and know what they can do for you.
There's a lot more methods which you can use to validate data in Wordpress. Read the following article at Wordpress codex for more information: [Data Validation](http://codex.wordpress.org/Data_Validation)


###Important Concepts

There are only 3 important concepts that you have to remember when working with Wordpress: API's, Filters and Actions.


###API's

Wordpress is composed of many different API's. But you'll only have to tap into the API's that corresponds to what you want to do with your plugin. If you need your plugin to have an options page then look into the [options API](http://codex.wordpress.org/Options_API) and [Settings API](http://codex.wordpress.org/Settings_API). If you want your users to publish posts easily then you could use the [shortcodes API](http://codex.wordpress.org/Shortcode_API). If you want your plugin to have its on widget then you can use the [Widgets API](http://codex.wordpress.org/Widgets_API).
Here's a list of all the API's that you could use in Wordpress: [Wordpress API's](http://codex.wordpress.org/WordPress_APIs)


####Filters

These are built-in Wordpress functions which you could hook into to modify the content displayed in your site.
For example if you want to modify the content of a blog post you just add a filter to the content:

```
<?php
add_filter('the_content', function($content){
	//you're awesome code goes here
});
?>
```

So for example if the blog entry that was published has this content:

```
http://google.com
```

And you want to turn it into a link:

```
<a href="http://google.com">http://google.com</a>
```

You can just add a filter to the content and use regular expressions to find the url's in the content and wrap it in anchor tags:

```
<?php
add_filter('the_content', function($content){
	$content = preg_replace(
					"#((http|https|ftp)://(\S*?\.\S*?))(\s|\;|\)|\]|\[|\{|\}|,|\"|'|:|\<|$|\.\s)#ie", 
					"'<a href=\"$1\" target=\"_blank\">$3</a>$4'", $content
				);
	return $content;
});
?>
```


####Actions

These are built-in Wordpress functions which you could hook into to respond to some events or to execute some functions when a certain event in Wordpress happens. Some of the most commonly used actions are:

- **admin_init** - you could hook into this action to execute some code for when the admin page is initialized. 
The most common use case is when initializing the options page for your plugin:

```
<?php
add_action('admin_init', function(){
		new Zam_Options();
});
?> 
```

- **widgets_init** - you could hook into this action to register the widgets for your plugin or unregistering widgets that won't look good in the Wordpress theme that you've created.

```
<?php
add_action('widgets_init', function(){
	register_widget("zam_tweets_widget");
});
?>
```

- **wp_ajax** - you could hook into this action to register a method that would respond to ajax calls. 
Unlike other actions you can register multiple methods that would respond to specific ajax calls.
You just have to prefix the name you want to give to the method that will respond to the ajax call with either `wp_ajax` or `wp_ajax_nopriv`. `wp_ajax` only responds to users which are logged in while `wp_ajax_nopriv` only responds to ajax calls which are public or anonymous. This means that it responds only to users of your site that aren't logged in. So if you want your method to be accessible to both logged in and anonymous users then you need to hook to both `wp_ajax` and `wp_ajax_nopriv` just like in the example below:

```
<?php
add_action('wp_ajax_nopriv_get_tweets', 'zam_get_tweets');
add_action('wp_ajax_get_tweets', 'zam_get_tweets');
?>
```

- **custom action hooks** - you can also have custom action hooks which is commonly used in scheduled tasks. This can be defined by using a custom hook name which should be namespaced by the plugin name. Then supplying a callback function that will be executed once the scheduled task is executed.

```
<?php
wp_schedule_event(time() + 1200, 'daily', 'zam_save_search_images');

add_action('zam_save_search_images', function(){

	$data = ecom_save_images();
	file_put_contents($data['asin_file'], "");
});
?>
```


###About the Plugin

Before we dive into creating the plugin I'll tell you what the plugin that were going to build is all about.
The plugin will fetch the tweets of a specific user given that the tweets are not set to private. It will have an options page and a widget. 
The options page is where the admin will input the twitter ID of the person in which to fetch tweets from.
And the widget is going to display the tweets in the public area of the website.
The plugin will also have a feature of publishing tweets based on a page number supplied by the user and a random index generated by the plugin. 



###Creating the Plugin

You can create a new plugin by creating a new folder under the `wp-content/plugin` directory.
In our case the name of the plugin that were going to create is `Zam` so were going to name the folder `zam`. 
And inside it create a file and name it `zam.php`.
Open the `zam.php` file and tell Wordpress the details of your plugin. 
You can do that by putting the following information inside a PHP multi-line commment right after your first opening PHP tag:

```php
<?php
/*
Plugin Name: Zam
Plugin URI: http://zam-wp-plugin.io
Version: 1.0
Author: Nrue
Description: 
*/
?>
```


Standard plugin information includes the plugin name, plugin url or the address where your plugin can be downloaded, the version of your plugin, the author and the description. But you can also add other information like the Author URI and the license that you want to use. You can check out [tldrlegal.com](http://www.tldrlegal.com/) and search any license that you can use (E.g GPL, Apache2, MIT) and read on some of the benefits of using that particular license. Once you've selected something just put on the name of the license as the value for the `License` attribute:

```php
<?php
/*
License: Apache2
*/
?>
``` 


Once you've set that up you can already see your plugin from the list of installed plugins in the admin page:

![installed plugins](/images/posts/getting_started_with_wordpress_plugin_development/zam_plugin.PNG)

You can activate it by clicking on the `activate` link. But we won't do that for now since the plugin really does nothing at the moment.

Now that we have checked that wordpress is already aware with our plugin were ready to build the plugin.
First start of by creating a class and its constructor:

```
<?php
class Zam{

	public function __construct(){

	}

}
?>
```

{% blockquote %}
Important:
The constructor is where we initialize the data to be used by the plugin.
It is also where we call all the hooks and actions.
{% endblockquote %}

Next declare the variables that were going to use throughout the class:
 
 ```
 <?php
private $protocol;
private $settings;
private $twitter_id;
 ?>
 ```
 
The protocol stores the protocol used by the server. It can either be http or https.
The settings stores the settings for the plugin.  
The twitter id stores the twitter id of the user. This can be extracted from the settings but its better to store it in its own variable.

Going back to our constructor now we can initialize the data that the plugin will be using throughout the application: 

```
<?php
	public function __construct(){
		$this->protocol = is_SSL() ? 'https://' : 'http://';
		$this->settings = get_option('zam_options');
		$this->twitter_id = (!empty($this->settings['zam_twitter_id'])) ? $this->settings['zam_twitter_id'] : '';
	}
?> 
``` 

{% blockquote %}
Important:
Always check for the existence of a specific option item because you can't always expect it to actually have a value stored in it. This will lead to notices being outputted out if you don't perform the check first. It's always good to use ternary operators for this purpose.
{% endblockquote %}


####Plugin Options

Next create a new PHP file and call it `zam-options.php` this is where we will put the code specific to the options page of our plugin.

Then build a class which will have a constructor that will assign the options to the `$options` variable. 
This will store things like the twitter id of the user and other options that we might want to add later on.

```
<?php
class Zam_Options{

	private $options;
	
	public function __construct(){

		$this->options = get_option('zam_options');
		$this->register_settings_and_fields(); //registers all the options for the plugin
	}
}	
?>
```

In the constructor were calling the `get_option` method which simply gets a specific option from the Wordpress database. These options are stored in the `wp_options` table which has 4 fields:

- **option_id** - auto increment unique id for the option
- **option_name** - the name of the options. In this case the name of the option for our plugin is `zam_options`.
- **option_value** - this can either have a string or a serialized string. The value is a string for default wordpress options like the `siteurl` or the `blogdescription`. But for option pages its a serialized string which looks like this:

```
a:2:{s:16:"enablexmlsitemap";s:2:"on";s:36:"post_types-attachment-not_in_sitemap";b:1;}
```

This doesn't look friendly when compared to a simple json string simply because its actually storing the type of data and the length. `s:2` simply means string with a length of 2, which is true since the string "on" which is supplied as its value is a string and has 2 characters. `b:1` simply means boolean with a length of 1.

- **autoload** - can have a value of `yes` or `no`. The default value is `yes` which usually means that the option can be fetched directly when using the `get_option` method.


From the constructor were also calling the `register_settings_and_fields` this setups all the fields and sections in our plugin options page. Fields are the text fields, radio buttons, and check boxes that can be included in the options page. And sections are the groups in which these fields belong. 

```
<?php
public function register_settings_and_fields(){
	
	register_setting('zam_options', 'zam_options'); //register zam_options as an option in the option group called zam_options

	//add a section called zam_options_main 
	add_settings_section('zam_options_main', __('Main Settings', 'zam'), array($this, 'zam_options_create'), __FILE__);
	
	//create the zam_twitter_id field and add it to the zam_options_main section
	$this->create_fields(
		__FILE__,
		$this,
		'zam_options_main',
		array(
			array(
				'id' => 'zam_twitter_id',
				'label' => __('Twitter ID' , 'zam'),
				'function' => 'display_twitter_id'
			)
		)
	);
}
?>
```

You might have notice that were using `__('text', 'text')` all over the place. 
This is a good practice in Wordpress even if you don't plan to have your plugin available for many different languages. Were doing this to prepare our plugin for localization. `__()` is actually a method in wordpress used for localizing text. The first argument is the text itself and the second argument is the text domain. In this case the text domain is the name of the plugin but you can also have something else which directly relates to the plugin so that it can easily be distinguished what plugin does it belong to.

{% blockquote %}
Important:
The localization will actually work without the text domain. That is if you are certain that the words, phrases and sentences used in your plugin are already localized and is already available in your current Wordpress installation.
The importance of the text domain is to tell Wordpress that the specific text is localized for a specific plugin. 
The language file is usually stored in the languages directory in the root of the plugin. The load_plugin_textdomain is used to load those language files into Wordpress and the text is translated on the fly.
{% endblockquote %}


Back to our `register_settings_and_fields` method, we are also calling the `zam_options_create` which job is to fill the section with the desired content. Its a required parameter so we have to supply it even if were really doing nothing with it at the moment since we are going to have a separate function to display each field.

```
<?php
public function zam_options_create() {

}
?>
```

Still in our `register_settings_and_fields` method, we are also calling the `create_fields` method. 
This method will create all of the fields and sections in our plugin options page.
The first argument is the menu page in which to display the field. In this case were just going to use the built-in magic constant in PHP called `__FILE__` which simply stores the full path and the file name of the current file (zam-options.php).
The second argument is the context of the method that is going to display the specific field. 
In this case were simply going to use the  `$this` keyword, since all the methods that were going to use for displaying the fields are class members and `$this` refers to the current object of the class.
The third argument is the section id. You can name it whatever you like but be sure to name it to something unique and it must directly relate to the plugin. In this case were just going to use the plugin name and the options word as the prefix then the name of the section.
The fourth argument is an array which stores an array for each field. The array contains the unique id for the field, the label to be used for the field, and the function that will display the field. 

```
<?php
$this->create_fields(
	__FILE__,
	$this,
	'zam_options_main',
	array(
		array(
			'id' => 'zam_twitter_id',
			'label' => __('Twitter ID' , 'zam'),
			'function' => 'display_twitter_id'
		)
	)
);
?>
```

Next let's take a look at the `create_fields` method which we called above to create the sections and fields for our options page. Here we are simply looping through the contents of the fourth argument that we supplied above and passing in those arguments to the `add_settings_field` method. The `add_settings_field` method is a built-in method in Wordpress that allows us to register a field to a settings page. 
It takes the same arguments as our `create_fields` methods. Since the `create_fields` method is just some sort of a factory so we don't have to call `add_settings_field` every time we need to create a new field.

```
<?php
public function create_fields($file, $class, $section_id, $field_data){
	foreach($field_data as $field){

		add_settings_field($field['id'], $field['label'], array($class, $field['function']), $file, $section_id);
	}
}
?>
```

Next we have the `display_twitter_id` method which displays the twitter id field. Nothing fancy here were just echoing out plain old HTML and supplying the value for that specific field if its present. But a good practice in naming is using the name of the options page as somewhat like the name of the array and the id of the field as the specific key that you want to access:

```
<?php
public function display_twitter_id(){
	$zam_twitter_id = (!empty($this->options['zam_twitter_id'])) ? $this->options['zam_twitter_id'] : '';
	echo "<input type='text' name='zam_options[zam_twitter_id]' class='regular-text' id='zam_twitter_id'  value='{$zam_twitter_id}'/>";
}
?>
```

Next, the function that will display all the fields and sections in the options page.

```
<?php	
public static function display_fields(){
?>
	<div class="wrap">
		<?php screen_icon(); //display the default icon for an options page ?> 
		<h2><?php _e('Zam Settings', 'zam'); ?></h2>
		<form action="options.php" method="post" id="zam_settings_forms" data-validate="parsley">
			<?php settings_fields('zam_options'); ?>
			<table class="form-table">
				<?php do_settings_sections( __FILE__ ); ?>
			</table>
			<p class="submit">
				<input type="submit" name="submit" id="submit" class="button button-primary" value="Save Changes">
			</p>
	</div>
<?php		
	}
?>
```

The `display_fields` method will display a form element which will wrap the `settings_fields` and `do_settings_sections` method.
The `settings_field` method displays the option page fields that are added to the option group.
The option group in this case is `zam_options` which we supplied as the first argument when we called the `register_setting` field earlier.

```
<?php
register_setting('zam_options', 'zam_options'); 
?>
```

The `do_settings_sections` method displays all the sections added in a specific settings page. In this case the settings page is the file itself so were going to use the `__FILE__` magic-constant again to refer to the current settings page.


{% blockquote %}
Its a good practice to use the built-in view source feature in the browser (or better yet Chrome Dev Tools elements panel) to check out the existing mark-up that Wordpress uses in each of the pages that you want to create. This will give you an idea which classes to apply for each elements.
{% endblockquote %}



Lastly, the method that will add a menu page. The `add_menu_page` has 4 required parameters:

- page title
- menu title
- capability
- menu slug

The **page title** is the text that you see in the browser tab when you access the page.
The **menu title** is the text that you see in the Wordpress menu on the left side of the screen when you access the admin page.
The **capability** is the minimum capability required so that the current user can have access to that options page. In this case if the current user has the ability to manage the options then he can access the page. Check out the [Roles and Capabilities section](http://codex.wordpress.org/Roles_and_Capabilities) in Wordpress codex for more information on this.
The **menu slug** is simply the name which refers to that specific menu. You can think of it as the ID to that specific menu.

In the code below we also supplied a fifth argument which is the function that will display the fields for that specific menu page. We also used the `add_submenu_page` method, the only difference between this method and the `add_menu_page` is that the menu added using `add_menu_page` will be automatically displayed once you access the specific options page. And the `add_submenu_page` is simply used to add a submenu for that options page which means that it will be displayed right after the menu added using the `add_menu_page`.

```
<?php
public static function add_menu(){

	add_menu_page(__('Zam', 'zam'), __('zam', 'zam'), 'manage_options', 'zam-options', array( 'zam_options', 'display_fields' ));

	add_submenu_page('zam-options', __('Settings', 'zam'), __('Settings', 'zam'), 'manage_options', 'zam-options', array( 'zam_options', 'display_fields' ));
}
?>
```


####Plugin Widget

Now let's create the widget that will display the tweets of the user supplied in the options page.
Create a new file and call it `zam-tweets-widget.php`. You can place the widgets in a separate directory if you want but since we only have one widget for this plugin we will put it in the same directory as the main plugin file.

First thing that you need to do is to declare a class and call it `Zam_Tweets_Widget`. Unlike the options class and the plugin class that we created earlier this will extend from the `WP_Widget` class which is stored in the `wp-includes/widgets.php` file. Because of this Wordpress widgets are always written in an object-oriented way.

```
<?php
class Zam_Tweets_Widget extends WP_Widget{

}
?>	
```

Like all the classes that we have created so far the widget class will also have a constructor. 
But since we are extending from the `WP_Widget` class we need to make sure that the constructor of the `WP_Widget` will also run. In PHP this is done by calling `parent::__construct()`. The constructor of the `WP_Widget` class expects the id of the widget as the first parameter, the name of the widget as the second, and the third will be an array of the widget options.

```
<?php
	public function __construct(){

		parent::__construct(
			'zam_tweets_widget', __('Zam Tweets Widget', 'zam'),
			array( 'description' => __('A widget for displaying tweets', 'zam'))
		);

	}
?>
```

A wordpress widget commonly has 3 functions which are all set to `public`:

- form
- update
- widget

The **form** function is the function that will display the widget form that the admin sees in the back-end of the site. 
This is where the admin can change the options for that specific widget. A common option which can be customized is the widget title.

The **update** function is the function that will be executed when the admin saves the widget options. 

The **widget** function is the function that will display the widget on the front-end. This is what the users will see when they visit the site.

Now that you're familiar what each function does let's go ahead and create the **form** function.
The **form** function has the `$instance` parameter which basically stores the data for that specific instance of the widget. If you played quite a bit with Wordpress you will notice that you can actually have many instances of the same widget. 

First we check if the `title` and the `tweets_to_show` options for that specific instance of the widget already has a value. If it has a value then we use it. If it doesn't have a value we set an empty string as the value. Next we simply output a standard text field for the widget title and a drop-down box for the number of tweets to show. Always remember to put it the css classes that wordpress already uses to make your form fields match the styling of the other widgets.

```
<?php
	public function form($instance){

		$title = __('', 'zam');
		$tweets_to_show_range = range(3, 11);
		$tweets_to_show = 3;

		if(isset($instance['title'])){
			$title = esc_attr($instance['title']);
		}

		if(isset($instance['tweets_to_show'])){
			$tweets_to_show = esc_attr($instance['tweets_to_show']);
		}
?>
		<p>
			<label for="<?php echo $this->get_field_id('title'); ?>"><?php _e('Title', 'zam') . ":"; ?></label>
			<input type="text" class="widefat" id="<?php echo $this->get_field_id('title'); ?>" name="<?php echo $this->get_field_name('title'); ?>" value="<?php echo $title; ?>" />
		</p>

		<p>
			<label for="<?php echo $this->get_field_id('tweets_to_show'); ?>"><?php _e('Tweets to show', 'zam'); ?></label>
			<select class="widefat" id="<?php echo $this->get_field_id('tweets_to_show'); ?>" name="<?php echo $this->get_field_name('tweets_to_show'); ?>">
				<?php
				foreach($tweets_to_show_range as $num){
					$checked = '';
					if($num == $tweets_to_show){
						$checked = 'selected=true';
					}
				?>
				<option value="<?php echo $num; ?>" <?php echo $checked; ?>><?php echo $num; ?></option>
				<?php	
				}
				?>
			</select>
		</p>
<?php
	}
?>
```

Next is the **update** function which has 2 parameters, the new instance stores the new option values after the widget options has been updated and the old instance stores the option values before the widget options was updated.
What were doing below is simply using the values for the new instance and then returning it.

```
<?php
public function update($new_instance, $old_instance) {

	$instance = array();
	$instance['title'] = strip_tags($new_instance['title']);
	$instance['tweets_to_show'] = strip_tags($new_instance['tweets_to_show']);

	return $instance;
}
?>
```

Finally the **widget** function where we display the latest tweets from the user with the twitter ID inputted in the plugin options page. It will have an `$args` and `$instance` as parameters.

The `$args` stores standard widget information such as the name, description, class, widget id and widget name. It also stores the HTML that would show up before and after every widget title.

The `$instance` simply stores the widget information entered by the admin from the back-end such as the widget title and the number of tweets to show.

We used the built-in PHP method called `extract` below to extract the array into each of their own variables. Next we echo the html stored in the `$before_widget`,  `$before_title` , `$after_title` and `$after_widget` variables which were extracted from the widget's `$args` argument. 
Then we call the `get_tweets` method which we will create later. This method returns an array of tweets by the user specified in the plugin options page. Lastly we simply `break` once the current iteration is equal to the number of tweets to show. 

```
<?php
	public function widget($args, $instance) {

		global $zam;

		extract($args);
		extract($instance);

		if(empty($title)){
			$title = __('Tweets', 'zam');
		}

			echo $before_widget;
			echo $before_title . __($title, 'zam') . $after_title;
			$tweets = $zam->get_tweets();
?>
			<div id="zam_tweets">
			<?php
			foreach($tweets as $index => $tweet){
			?>
				<li><?php echo $tweet; ?></li>
			<?php
				if($tweets_to_show == $index + 1){
					break;
				}	
			}
			?>
			</div>
<?php
				echo $after_widget;
	}
?>
```


Going back to our main plugin file we will now initialize our plugin options page once the admin page has been initialized. So we simply create a callback function on the `admin_init` action hook and create a new instance of the `Zam_Options` class. The `Zam_Options` class if you can remember is the class name of our plugin options page. Simply instantiating this class will build the options page.

```
<?php
add_action('admin_init', function(){
		new Zam_Options();
});
?> 
```

But aside from building the options page we also need to add the menu items as well since there would be no way for the admin to access our plugin options page if we don't add a menu that he can easily click. What the code above did was to simply add the options page, the admin can access it by typing the menu slug directly into the address bar of the browser but he can't access it directly from the admin menu.

```
<?php
public function zam_admin_init(){
	Zam_Options::add_menu();
}
?>
```

We can just hook this function to the `admin_menu` hook which is a hook which is used for adding extract submenus to the admin panel. 

```
<?php
add_action('admin_menu', array($this, 'zam_admin_init'));
?>
```


Next we now create the `get_tweets` method which we called earlier from our widget. For this were going to use the twitteroauth library which was created by Abraham Williams to easily make calls to the Twitter API using PHP.

You can download the two files that we will be needing from this method from here: [Twitteroauth library](https://github.com/abraham/twitteroauth/tree/master/twitteroauth). After you've downloaded that just put those 2 files in a folder called `libs` in the main plugin directory. After that, create a `twitteroauth` directory and put those 2 files so we will have no problems distinguishing which files belongs to which library later on.

Once you're done with that go ahead and include the `twitteroauth.php` inside the `get_tweets` method. Then create a new object for the `TwitterOAuth` class. The constructor needs a couple of things which you can get from the [Twitter Developer Site](https://dev.twitter.com/) by registering an app. You can simply login using your existing twitter account then under [my applications](https://dev.twitter.com/apps) choose `create new application` if you don't already have an application. I won't dive into much detail on how to create an application, all you have to do is to fill in the required details and agree to the terms and conditions set by twitter. Then after that click on the `create access token` button to create an access token for your app since its not automatically created.
Finally, just supply the `consumer key`, `consumer secret`, `access token`, and `access token secret`.

To get the tweets of the user we simply call on the `get` method from the `TwitterOAuth` library and supply 2 arguments. The first one is the method that we want to use, in this case we only want to get the tweets for a specific user so we will use the [statuses/user_timeline](https://dev.twitter.com/docs/api/1.1/get/statuses/user_timeline) method which requires arguments such as the `user_id` or the `screen_name` , `since_id`, `count`, `max_id`, `page`, and `exclude_replies`. But we will only use the `screen_name` or the twitter handle, `count`, `page` and `exclude_replies`. The `screen_name` is simply the username of the twitter user that you wish to get, the `count` is the number of tweets to return, and the `exclude_replies` requires a boolean value to specify whether you want to exclude the replies to a specific twitter (true) user or not (false). The `page` is simply the page where you want to fetch the tweets, this will largely depend on the value you specified for the `count`. For example if the user has the following tweets (ordered from most recent to less recent):

```
Super Cool!
Pretty Dang Cool!
Dang Cool!
Kewl!
Uber Cool!
Mega Super Duper Cool!
```

And the value for `count` is 3 and the `page` is 1 it will only return the first 3 tweets:

```
Super Cool!
Pretty Dang Cool!
Dang Cool!
```

Another example when specify `count` to be 3 and `page` to be 2, it will return the following tweets:

```
Kewl!
Uber Cool!
Mega Super Duper Cool!
```

But if you specify the `count` to be `5` and the `page` to be `2` you only get the following:

```
Mega Super Duper Cool!
```

By default the tweets that are returned are ordered from the most recent to less recent tweet.

```
<?php
public function get_tweets($page = 1){
	
	require_once 'libs/twitteroauth/twitteroauth.php';

	//access the twitter API
	$twitterConnection = new TwitterOAuth(
		'',	//consumer key
		'', //consumer secret
		'', //access token
		''  //access token secret
	);

	$twitterData = $twitterConnection->get(
	  'statuses/user_timeline',
	  array(
	    'screen_name'     => $this->twitter_id,
	    'count'           => '11',
	    'exclude_replies' => true, //exclude replies to a specific twitter user,
	    'page' => $page
	  )
	);

	$tweet_text = array();
	
	//if the request was successful
	if($twitterConnection->http_code == 200){	
		foreach($twitterData as $t){
			
			//wrap all the url's with anchor tags
			$text = preg_replace(
				"#((http|https|ftp)://(\S*?\.\S*?))(\s|\;|\)|\]|\[|\{|\}|,|\"|'|:|\<|$|\.\s)#ie", 
				"'<a href=\"$1\" target=\"_blank\">$3</a>$4'", $t->text
			);

			$tweet_text[] = $text;
		}
	}

	return $tweet_text;
}
?>
```

Next is the `save_tweet` method which we will use to save the text of the randomly selected tweet into the database.
This method will have a `$post_id` argument when attached to the `save_post` method. This stores the post id of that specific post. We can use this to get the data associated with the post such as the post title and the post content.

Inside the method we access the global object called `$wpdb` so that we can do some CRUD operations with the Worpdress database. 

Next we pick a random number from 0 to 10, this will be used later to get a specific tweet with the random index. As you might already know, the most recent tweet will have an index of 0 and the one after that will have an index of 1 and so on.

Next we get more information regarding the post by using the `get_post` method and passing in the post id as its argument. This will return all the information about the post which you can normally find in the `wp_posts` table in the Wordpress database. But we only need to get 3 fields: the post title, post content and the post type.

The `wp_posts` table doesn't just store blog posts it also stores pages, attachments, and revisions for specific posts that's why we need to get the post type as well because the post type that we need is only the `post`. You can read more about [Post Types](http://codex.wordpress.org/Post_Types) on Wordpress codex.

Next we check whether the post is a revision by using the `wp_is_post_revision` method which takes up the post id as its argument. This returns true if the post is a revision and false if its not. Note that Wordpress doesn't just store the most recent version of a specific posts it also stores some revisions. So for example if you have edited a post twice then it would have 2 revisions that will also be saved in the `wp_posts` table.
We also check if the post type is `post` to make sure were only running this method if the post is an actual blog post and not an attachment, revision, a page, or some other [post types](http://codex.wordpress.org/Post_Types).

Next we check for the pattern of our shortcode if it exists in the current post. 
If it doesn't exists then we do nothing, but if it exists then we extract the `page` attribute from the results that were returned which is stored in index 1. Index 0 stores the whole pattern that was matched. 

Parenthesis are capturing groups in PHP regular expressions so we have the actual page number stored in index 1 because we wrapped the pattern for selecting the numbers 0-9 in parenthesis. Then we use the page number as part of the parameter for the url to get the tweets. Then we call the `get_tweets` method, this time specifying the page which was inputted by the user as its argument. After that we simply extract the text for that specific tweet by specifying the index number as the random index number that we generated earlier. Then we check the database if an existing entry in the tweets table has already the same post id as the post that were trying to save. We only insert into the database if it doesn't exists yet which is indicated by the number of rows returned from the last select query using `$wpdb->num_rows`. If it doesn't exist yet then `$wpdb->num_rows` returns 0, if it already exists it returns any number greater than 0 depending on the number of occurence of that specific post id.


```
<?php
public function save_tweet($post_id){

	global $wpdb;
	
	$random_index = rand(0, 10);

	$post = get_post($post_id);
	$post_title = $post->post_title;
  	$post_content = $post->post_content;
  	$post_type = $post->post_type;

	if(!wp_is_post_revision($post_id) && $post_type == 'post'){

		$pattern = '/\[zam_tweets page=([0-9])\]/'; //the general pattern for the shortcode
		preg_match($pattern, $post_content, $matches);
		if(!empty($matches)){

			$page = $matches[1]; //extract the page from the matches returned
			
			$tweets = $this->get_tweets($page);
			$tweet = $tweets[$random_index];

			$tweets_table = $wpdb->prefix . 'zam_tweets';

			$wpdb->query("SELECT id FROM $tweets_table WHERE post_id = '$post_id'");

			if($wpdb->num_rows == 0){
				$wpdb->insert($tweets_table, array('post_id' => $post_id, 'tweet' => $tweet));
			}


			
		}

	}

}
?>
```


The `save_tweet` method would be hooked into the `save_post` action which is executed every time a post is saved or updated. 

```
<?php
add_action('save_post', array($this, 'save_tweet'));
?>
```

Next is the `shortcode_to_tweet` method, this will convert the shortcode to a content. In this case the content is simply the tweet that was saved in the database when we first published our post. Again we check for the existence of the pattern used for our shortcode. We only perform the query that selects the tweets from the database if the post actually contains the pattern.

```
<?php
public function shortcode_to_tweet($attrs){
	
	global $wpdb;

	$post_id = get_the_ID(); //get the id of the current post
	$post_content = get_the_content(); //get the content of the current post

	$pattern = '/\[zam_tweets page=([0-9])\]/'; //pattern for our shortcode
	preg_match($pattern, $post_content, $matches); 

	if(!empty($matches)){ //check if the pattern exists

		$tweets_table = $wpdb->prefix . 'zam_tweets';
		$result = $wpdb->get_var("SELECT tweet FROM $tweets_table WHERE post_id = '$post_id'"); //select the tweet from the posts table
		$content = $result; //assign the content to be the result returned from the database
	}

	return $content;
}
?>
```

Next we just inform Wordpress about this new shortcode by passing the name of our shortcode (zam_tweets) and the name of the method (shortcode_to_tweet) that would process the shortcode to the `add_shortcode` method. You can learn more about Shortcodes in the [Shortcode API Documentation](http://codex.wordpress.org/Shortcode_API).

```
<?php
add_shortcode('zam_tweets', array($this, 'shortcode_to_tweet'));
?>
```

By doing this Wordpress already knows that once an author publishes a post using the `zam_tweets` shortcode it uses the `shortcode_to_tweet method` to convert the shortcode into an actual content. The shortcode for our plugin would look like this:

```
[zam_tweets page=1]
```


Next create the `installation_housekeeping` method which will run once our plugin is installed by the user.
This isn't usually needed especially for simple plugins which only does one thing. But for this plugin we need a table to store the tweets. This will serve as a cache for the tweets that the admin has published using shortcodes. 
The table would only have 3 fields: ID, post_id and tweet where the ID is an auto-increment primary key and the post_id is the id of the post and the tweet is the text content of that specific tweet.

One thing to remember here is to not use `$wpdb` when creating or dropping tables. We use `dbDelta` instead but we have to include the `upgrade.php` file under the `wp-admin/includes` directory before using it.
Another thing to remember is when creating tables you should always use the `$wpdb->prefix` which is a value that you can specify on the table prefix variable in the `wp-config.php` file:

```
<?php
public function installation_housekeeping(){

	global $wpdb;
	
	$tweets_table = $wpdb->prefix . 'zam_tweets';

	$tweets_sql = "CREATE TABLE $tweets_table (
	  id INT(10) NOT NULL AUTO_INCREMENT,
	  post_id BIGINT(20) NOT NULL,
    tweet VARCHAR(160) NOT NULL,
		PRIMARY KEY id (id)
	);";

	require_once ABSPATH . 'wp-admin/includes/upgrade.php';

	dbDelta($tweets_sql);
}
?>
```

We can then hook it up on the event that the plugin is installed:

```
<?php
add_action('activate_zam/zam.php', 'installation_housekeeping');
?>
```

The syntax that we used is: `prefix + underscore + plugin name + slash + plugin file name`.
So if your plugin name is max and its file name is `max.php` then your hook should look like this:

```
<?php
add_action('activate_max/max.php', 'installation_housekeeping');
?>
```

Of course anything that we do on plugin install we must undo once the user uninstalls our plugin. 
This often depends on the user whether he wants to keep the data that was added by a specific plugin or not. We can actually give the user the option to keep the data or not. But to keep things simple were going to stick to the rule: if the user doesn't want it anymore then we remove everything. 

To tell Wordpress what to do once the user uninstalls the plugin (clicking on the delete link). 
Create a new file and name it `uninstall.php`. We don't really have a choice with the naming here, this is a way to tell Wordpress to execute the `uninstall.php` just before it deletes the plugin. 
For this plugin all we have to do is to drop the tweets table and delete `zam_options` option which is the option that we used earlier to store the users twitter id. 

```
<?php
if(!defined('WP_UNINSTALL_PLUGIN'))
exit();
global $wpdb;
$tweets_table = $wpdb->prefix . 'zam_tweets';
$wpdb->query("DROP TABLE $tweets_table");
delete_option('zam_options');
?>
```

Finally, we just have to add all of our hooks to the constructor so that Wordpress would be aware of all the code we've written up until now once the class for our plugin is instantiated.

```
<?php
public function __construct(){

	$this->protocol = is_SSL() ? 'https://' : 'http://';
	$this->settings = get_option('zam_options');
	$this->twitter_id = (!empty($this->settings['zam_twitter_id'])) ? $this->settings['zam_twitter_id'] : '';

	//add the options page
	add_action('admin_init', function(){
		new Zam_Options();
	});

	add_action('admin_menu', array($this, 'zam_admin_init'));

	//register the tweets widget
	add_action('widgets_init', function(){
		register_widget('zam_tweets_widget');
	});

	//hook up the save_tweet method to the save_post action
	add_action('save_post', array($this, 'save_tweet'));

	//tell wordpress about the zam_tweets shortcode
	add_shortcode('zam_tweets', array($this, 'shortcode_to_tweet'));

	//activation hook
	add_action('activate_zam/zam.php', 'installation_housekeeping');

}
?>
```




###Conclusion

That's it! You've learned how to create Wordpress plugins. You've also learned some of the best practices and coding standards in developing Wordpress plugins. Now go and create some plugins! 

 

###Resources

- [Wordpress Coding Standards](http://codex.wordpress.org/WordPress_Coding_Standards)
- [Wordpress Plugin Development Best Practices](http://wp.tutsplus.com/tutorials/7-simple-rules-wordpress-plugin-development-best-practices/) 
- [Two ways to develop Wordpress plugins](http://wp.tutsplus.com/tutorials/plugins/two-ways-to-develop-wordpress-plugins-object-oriented-progamming/)
- [Core Contributor Handbook](http://make.wordpress.org/core/handbook/)
- [Zam Plugin Source Code](https://dl.dropboxusercontent.com/u/126688107/tutorials/zam.7z)
