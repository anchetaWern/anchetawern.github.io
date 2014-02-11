---
layout: post
title: "Unit Testing Wordpress Plugins"
date: 2013-09-29 15:30
comments: true
categories: [wordpress, unit-testing, phpunit]
published: true
---

In this article I'm going to show you how to do unit testing in Wordpress plugins.
Previously I've written an article on [Getting Started with Wordpress Plugin Development](http://anchetawern.github.io/blog/2013/05/26/getting-started-with-wordpress-plugin-development/) and in that article I've created a simple Wordpress plugin that saves some tweets in the Wordpress database and displays them on a widget.
This time I'm going to walk you through setting up unit testing in Wordpress then write some tests for that specific plugin. If you want to follow along you can download the source from [here](https://dl.dropboxusercontent.com/u/126688107/tutorials/zam.7z).


###Installing Composer

First you have to install composer. From your terminal execute the following command to install composer:

```
curl -s https://getcomposer.org/installer | php
```



###Installing PHPUnit

Next on your project directory. In my case its in:

```
home/wern/web_files/wordpress/wp-content/plugins/zam
```

Create a `composer.json` file then put the following contents:

```
{
    "require": {
        "EHER/PHPUnit": "dev-master"
    }
}
```

Once you're done, save the file then execute the following command from your terminal:

```
composer install
```

This will install PHPUnit which we will be using for unit testing.



###Setting Up Wordpress Tests

Another prerequisite before we can start writing our unit tests is installing [Wordpress Tests](https://github.com/nb/wordpress-tests) which is a tool that was created to help in unit testing Wordpress plugins. The main benefit of using this tool is that it has access to all the Wordpress classes so the unit testing environment is pretty much the same as the environment where your Wordpress plugins runs.

Next create a `src` folder from the root directory of your plugin. 
Then install Wordpress Tests inside of it. You can install by cloning the repo by executing the following command from the terminal:

```
git clone https://github.com/nb/wordpress-tests.git
```

Or simply download the `master.zip` file from the master branch of the project if you don't have [Git](http://git-scm.com/) installed.

Next create a `tests` directory (still on the root directory of your plugin). Then inside it create another directory and name it the same name where your Wordpress plugin is stored. In this case I've named it `zam` since its the name of the directory where the main plugin file is located.

Then create a `bootstrap.php` file just beside the directory that you've just created and put the following contents:

```php
<?php
$path = '/home/wern/web_files/wordpress/wp-content/plugins/zam/src/wordpress-tests/bootstrap.php';

if( file_exists( $path ) ) {
  
    require_once $path;
} else {
    exit( "Couldn't find path to wordpress-tests/bootstrap.php\n" );
}
?>
```

Ok not exactly the same contents but at least the same format. All you're going to need to have to change here is the value for the `$path`. It should be where the main `bootstrap.php` file is stored. Not the `bootstrap.php` that you've just created but the `bootstrap.php` file that's inside the `wordpress-tests` project which you cloned earlier.

Next inside the `tests/zam` directory create the file were we are going to write all the tests later on. As a convention the naming should be the name of the plugin followed by the word `Test`. So for the sample plugin that were going to test the name would be `zamTest.php`.


Next navigate to the root directory of your plugin and create a `phpunit.xml` file and put the following contents:

```xml
<?xml version="1.0" encoding="UTF-8"?>

<phpunit backupGlobals="false"
         backupStaticAttributes="false"
         colors="true"
         convertErrorsToExceptions="true"
         convertNoticesToExceptions="true"
         convertWarningsToExceptions="true"
         processIsolation="false"
         stopOnFailure="false"
         syntaxCheck="false"
         bootstrap="tests/bootstrap.php"
>
    <testsuites>
        <testsuite name="Ecom Test Suite">
            <directory>tests/</directory>
        </testsuite>
    </testsuites>
</phpunit>
```

The `phpunit.xml` file simply points out where the test directory is located and some options for PHPUnit.
In the `phpunit.xml` file above we've used the following options:

- **backupGlobals** - setting this to `false` tells PHPUnit to disable global state between tests
- **backupStaticAttributes** - setting this to `false` disables the backup and restore operations for static class attributes
- **colors** - setting this to `true` enables syntax highlighting when running tests on the terminal
- **convertErrorsToExceptions** - setting this to `true` converts errors to exceptions
- **convertNoticesToExceptions** - setting this to `true` converts notices to exceptions
- **convertWarningsToExceptions** - setting this to `true` converts warnings to exceptions
- **processIsolation** - setting this to `false` disables running each test in a separate PHP process
- **stopOnFailure** - setting this to `false` disables stopping of execution upon first error or failure. This means that the test will continue to run even after encountering a failure
- **syntaxCheck** - setting this to `false` disables checking of syntax
- **bootstrap** - where the `bootstrap.php` file is located


###Setting Up the Test Database

If your plugin uses the Wordpress database then its a requirement that you also have to setup the testing database so that running the tests won't affect your actual database. 

To do that go ahead and backup your Wordpress database using a tool like [Phpmyadmin](http://www.phpmyadmin.net/home_page/index.php).
Then restore the backup this time giving it a different name, something like `wp_db_tests` to indicate that its a database that will be used for testing.
Next modify `wp-config.php` to make use of the test database temporarily.

```php
<?php
define('DB_NAME', 'wp_db_tests');
?>
```

After that you can install the [Wordpress reset plugin](http://wordpress.org/plugins/wordpress-reset/) to reset the database that will be used for testing.

Once the test database has been successfully reset you can now revert the changes to `wp-config.php` and use your old database:

```
<?php
define('DB_NAME', 'wp_db');
?>
```

###Unit Test Configuration

Next we can now specify the options to the unit test configuration file (`unittests-config.php`) which you can find inside the `src/wordpress-tests` directory.
The only things that you might want to change here are the values for `ABSPATH`, `DB_NAME`, `DB_USER`, `DB_HOST`, `WP_TESTS_DOMAIN`, `WP_TESTS_EMAIL`, `WP_TESTS_TITLE`, and `WP_TESTS_NETWORK_TITLE`.

```
<?php
/* Path to the WordPress codebase you'd like to test. Add a backslash in the end. */
define('ABSPATH', '/home/wern/web_files/wordpress/'); 

define( 'DB_NAME', 'wp_db_tests' ); //the database that will be used for testing
define( 'DB_USER', 'root' );
define( 'DB_PASSWORD', '' );
define( 'DB_HOST', 'localhost' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );


define( 'WP_DEBUG', true ); //display all errors, warnings and notices
define( 'WP_DEBUG_DISPLAY', true );

define( 'WP_TESTS_DOMAIN', 'localhost/wordpress' );
define( 'WP_TESTS_EMAIL', 'youremail@gmail.com' );
define( 'WP_TESTS_TITLE', 'Some Site' );
define( 'WP_TESTS_NETWORK_TITLE', 'Test Network' );
define( 'WP_TESTS_SUBDOMAIN_INSTALL', true );
$base = '/';

/* Cron tries to make an HTTP request to the blog, which always fails, because tests are run in CLI mode only */
define( 'DISABLE_WP_CRON', true );

$table_prefix  = 'wp_';

define( 'WP_PHP_BINARY', 'php' );
?>
```

###Examining the Testing Suite

Now were ready to write some unit tests. Go ahead and navigate to the following directory:

```
/home/wern/web_files/wordpress/wp-content/plugins/zam/tests/zam/zamTest.php
```

Open up the `zamTest.php` file and put the following contents:

```
<?php
/**
 * Zam Tests
 */
require_once('/home/wern/web_files/wordpress/wp-content/plugins/zam/zam.php'); //path to the main plugin file

class ZamTest extends WP_UnitTestCase{

	public $zam;
    public $plugin_slug = 'zam';
    public $options;


    public function setUp() {

    }


    public function tearDown() {

    }

    //unit tests here
}
?>
```

The unit testing class will simply extend the `WP_UnitTestCase` class which is inside the `src/wordpress-tests/lib/testcase.php` file.

Let's take a moment to inspect it before proceeding with writing our tests.
As you can see the `WP_UnitTestCase` class is simply extending the `PHPUnit_Framework_TestCase` which is the main testing suite that is used for most PHPUnit based test classes.


```
<?php
class WP_UnitTestCase extends PHPUnit_Framework_TestCase {

	function setUp() {
		global $wpdb;
		$wpdb->suppress_errors = false;
		$wpdb->show_errors = true;
		$wpdb->db_connect();
		ini_set('display_errors', 1 );
		$this->clean_up_global_scope();
		$this->start_transaction();
	}

	function tearDown() {
		global $wpdb;
		$wpdb->query( 'ROLLBACK' );
	}

	function clean_up_global_scope() {
		$_GET = array();
		$_POST = array();
		$this->flush_cache();
	}

	function flush_cache() {
		global $wp_object_cache;
		$wp_object_cache->group_ops = array();
		$wp_object_cache->stats = array();
		$wp_object_cache->memcache_debug = array();
		$wp_object_cache->cache = array();
		if ( method_exists( $wp_object_cache, '__remoteset' ) ) {
			$wp_object_cache->__remoteset();
		}
		wp_cache_flush();
	}

	function start_transaction() {
		global $wpdb;
		$wpdb->query( 'SET autocommit = 0;' );
		$wpdb->query( 'START TRANSACTION;' );
	}

	function assertWPError( $actual, $message = '' ) {
		$this->assertTrue( is_wp_error( $actual ), $message );
	}

	function assertEqualFields( $object, $fields ) {
		foreach( $fields as $field_name => $field_value ) {
			if ( $object->$field_name != $field_value ) {
				$this->fail();
			}
		}
	}

	function assertDiscardWhitespace( $expected, $actual ) {
		$this->assertEquals( preg_replace( '/\s*/', '', $expected ), preg_replace( '/\s*/', '', $actual ) );
	}

	function checkAtLeastPHPVersion( $version ) {
		if ( version_compare( PHP_VERSION, $version, '<' ) ) {
			$this->markTestSkipped();
		}
	}

	function go_to( $url ) {
		// note: the WP and WP_Query classes like to silently fetch parameters
		// from all over the place (globals, GET, etc), which makes it tricky
		// to run them more than once without very carefully clearing everything
		$_GET = $_POST = array();
		foreach (array('query_string', 'id', 'postdata', 'authordata', 'day', 'currentmonth', 'page', 'pages', 'multipage', 'more', 'numpages', 'pagenow') as $v) {
			if ( isset( $GLOBALS[$v] ) ) unset( $GLOBALS[$v] );
		}
		$parts = parse_url($url);
		if (isset($parts['scheme'])) {
			$req = $parts['path'];
			if (isset($parts['query'])) {
				$req .= '?' . $parts['query'];
				// parse the url query vars into $_GET
				parse_str($parts['query'], $_GET);
			} else {
				$parts['query'] = '';
			}
		}
		else {
			$req = $url;
		}

		$_SERVER['REQUEST_URI'] = $req;
		unset($_SERVER['PATH_INFO']);

		$this->flush_cache();
		unset($GLOBALS['wp_query'], $GLOBALS['wp_the_query']);
		$GLOBALS['wp_the_query'] =& new WP_Query();
		$GLOBALS['wp_query'] =& $GLOBALS['wp_the_query'];
		$GLOBALS['wp'] =& new WP();

		// clean out globals to stop them polluting wp and wp_query
		foreach ($GLOBALS['wp']->public_query_vars as $v) {
			unset($GLOBALS[$v]);
		}
		foreach ($GLOBALS['wp']->private_query_vars as $v) {
			unset($GLOBALS[$v]);
		}

		$GLOBALS['wp']->main($parts['query']);
	}

}
?>
```


The `setUp` method sets the `supress_errors` attribute of the `$wpdb` object to `false` this means that all database errors will be displayed if there are any. The `$wpdb` variable is an instance of the Wordpress database class. It's also setting the `show_errors` attribute to `true`. Then it connects to the database that we have set on the `unittests-config.php` file earlier using the `db_connect()` method. It also sets `display_errors` to `1` which basically means that all errors, warnings and notices will be displayed if there are any.
Then the `clean_up_global_scope()` method is called, this simply empties out global variables such as `$_GET` or `$_POST`. This method also calls up another method which is the `flush_cache()` which simply resets the Wordpress object cache. All of this is done to prevent any external variable or cached data from interfering with the values used for the current test. The `setUp` method also calls up the `start_transaction()` method which sets database `autocommit` to `0`. This means that even if you execute a query like:

```
INSERT INTO wp_tbl_users SET name = 'matthew', age = 21
```

It won't actually commit the changes to the database. This means that the changes aren't permanently added into the database. After that it also starts a transaction using the `START_TRANSACTION` command. What this does is to ensure that the `autocommit` remains disabled while the transaction hasn't been ended yet. You can only end a transaction using either the `COMMIT` or `ROLLBACK` command. The `COMMIT` command simply commits all the changes in the database. The `ROLLBACK` command rolls back everything that was done after the `START_TRANSACTION` command.

When you check out the `tearDown()` method you will see that the `WP_UnitTestCase` class uses the `ROLLBACK` command. This means that every change brought by each test is rolled back to its previous state.

So even if a test method does a couple of queries:

```
<?php
$wpdb->query("INSERT INTO wp_postmeta SET post_id = '23', meta_key = 'somekey', meta_value = 'somevalue'");
$wpdb->query("INSERT INTO wp_options SET option_name = 'some_option', option_value = 'some_optionvalue'");
?>
```

Once the the execution of the test method ends, the `tearDown()` method will be called and the database will be rolled back to its previous state before any of the queries above were executed.
This effectively brings back the test database to a state similar to that of when your first installed Wordpress on every test.


There's also the `assertWPError()` method which simply asserts a Wordpress error if its `true`.

The `assertEqualFields()` method simply checks if each key-value pair that you supply it has equal values. If not the test will fail.

The `assertDiscardWhitespace()` method simply removes all the whitespace from 2 strings and compare it with each other.

The `checkAtLeastPHPVersion()` method checks if the PHP Version number that you specify as its argument is higher than that of PHP Version in the machine where you are running the tests. 

Lastly there's the `go_to()` method which sets up the objects which you might want to check when navigating a specific URL. For example if you want to assert the title of a specific page you do something like:

```
$this->go_to('http://mysite.me/?p=125');
```

Then you simply use an instance of the `$wp_query` class to get the queried objects from that specific URL. 
This will then contain some attributes like the `post_title` or `post_content` which you can assert:


```
<?php

public function testPostTitle() {
	global $wp_query;
	$post = $wp_query->get_queried_object();
	$this->assertEquals('Zup World!', $post->post_title);
}
?>
```


###Writing Unit Tests

Now that we know what the `WP_UnitTestCase` class does we can now proceed with writing the actual tests for our simple plugin.


####The Setup

The `setUp` method is where we setup the things that the plugin needs during its runtime. For example if the plugin that you are testing involves creating database tables or adding new entries to the `wp_options` table then you set those all up in the `setUp` method. Think of it as emulating what would usually happen once the plugin is activated on a Wordpress site. The same thing should happen in the `setUp` method.

The first thing that we need to do inside the `setUp` method is call the `setUp` method in the `WP_UnitTestCase` class. This simply cleans up the global scope and start a database transaction as we discussed earlier.

Next we create a new object for the `Zam` plugin class and call its `installation_housekeeping()` method which creates the tables that will be needed by the plugin. Finally, we set the option that will be used by the plugin. 
Here were setting the `zam_twitter_id` under the `zam_options` option group to be equal to `Wern_Ancheta`. This should be a valid twitter username otherwise it wouldn't work.

```
<?php
public function setUp() {

	parent::setUp();
	$z = new Zam();

	$z->installation_housekeeping();
	update_option('zam_options', array(
		'zam_twitter_id' => 'Wern_Ancheta'
	));
}
?>
``` 

{% blockquote %}
Remember that the `setUp` method runs before every test is executed.
{% endblockquote %}



####Teardown

Next is the `tearDown()` method. This is the opposite of the `setUp` method in that it is run after every test has been executed. What it does is to simply clean up the things which aren't cleaned up by the `setUp` method. In this case were simply calling the `uninstall_housekeeping()` method which drops the tables that are used by the plugin.

```
<?php
public function tearDown() {

    Zam::uninstall_housekeeping();

}
?>
```

Now were ready to test the actual methods in the plugin. For this tutorial were only going to test 2 core methods which the plugin uses, the `get_tweets()` and `save_tweets()` method. 

The convention that I've used in the following methods is to prefix the actual name of the methods that I'm testing with the word `test_`. Of course you can use other conventions but remember to use one that's already followed by your plugin. For example here I've used underscores to separate each word in the method. You can also use camel casing or hungarian notation if you're already using it. What's important is that the test should follow the convention used by the actual class that you're testing.


####Get Tweets Test

To test the `get_tweets()` method first you have to instantiate the plugin. 
This should be true for every method to avoid storing of values in the class itself. 
Once you've instantiated the class, call the `get_tweets()` method using the object that you've used.

We expect the `get_tweets()` method to return 11 tweets by default so we use `assertCount` to assert that the number of items stored in the `$tweets` variable is indeed 11.

```
<?php
public function test_get_tweets(){

	$z = new Zam();
	
	$tweets = $z->get_tweets();
	$this->assertCount(11, $tweets);
}
?>
```

####Save Tweets Test

Finally we test the `save_tweet` method. This method saves a random tweet from a page specified by the user in a specific Wordpress post. 

```
<?php
public function test_save_tweets(){

    global $wpdb;
    $z = new Zam();

    $page = '1';
    $post = array(
        'post_title' => 'sample save tweet',
        'post_content' => '[zam_tweets page=' . $page . ']',
        'post_type' => 'post'
    );

    $post_id = wp_insert_post($post);

    $tweets_table = $wpdb->prefix . 'zam_tweets';
    $content = $wpdb->get_var("SELECT tweet FROM $tweets_table WHERE post_id = '$post_id'");

    $tweets = $z->get_tweets($page);
    $result = in_array($content, $tweets);
    $this->assertTrue($result);
}
?>
```

This method is using the [Shortcode API](http://codex.wordpress.org/Shortcode_API) which has a general syntax similar to this one:

```
[zam_tweets page=3]
```

Where `zam_tweets` is the specific shortcode ID used by the plugin. And `page` is the attribute and `3` is the value for that attribute. 

What were doing here is simply emulating what would actually happen in an actual scenario. First the user creates a new post, puts in the shortcode then publish the post. But when testing we can take shortcuts as we don't need to navigate to the post page and click on the add new post. All that we need to do is to publish the actual post and that is done by calling the `wp_insert_post()` method. This takes a couple of arguments but here were only specify the `post_title` or the actual title of the post, the `post_content` or the shortcode itself, and the `post_type` which is `post`. 

Then we get the tweet from the tweets table, call the `get_tweets()` method, this time specifying the same page that was used in the shortcode. Finally we simply assert that the `in_array()` method which checks if the tweet that was found in the database is in the array of tweets returned by the `get_tweets()` method is `true`.


###Running the Tests

Once you're done writing the tests you can simply open up the terminal on the root directory of the plugin and execute the following command:

```
phpunit
```

Once its done running you will see a screen similar to this:

![passing tests](/images/posts/unit_testing_wordpress_plugins/terminal.png)