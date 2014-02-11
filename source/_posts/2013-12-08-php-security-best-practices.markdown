---
layout: post
title: "PHP Security Best Practices"
date: 2013-12-15 11:00
comments: true
categories: [php, security, best-practices]
published: true
updated: 2014-01-08 10:00
---

In this post were going to have a look at some of the best practices in PHP when it comes to security. 

{% blockquote %}
Disclaimer: I am not a security expert. This guide is purely based on the practices that I'm currently following that I believe to be secure. I've done a lot of research before putting any of the information here. But if you find something that you consider to be insecure please do share in the comments.
{% endblockquote %}

<!-- more -->

###Always Update

If possible always use the latest stable release of PHP because it contains some security updates and bug fixes. This will make applications written on top of it more secure.


###Secure Configuration

- Disable exposure of which PHP version your server is using. You can do it by searching for `expose_php` in your `php.ini` file and set it to `Off`:

```
expose_php = Off 
```

This will disable the inclusion of the PHP version in the response headers under the `X-Powered-By` attribute. 
Here's an example of a site which has set `expose_php` to `On`. As you can see the value `X-Powered-By` attribute is `PHP/5.4.17` so we pretty much know which PHP version the server is running. An attacker can use this information to exploit the security vulnerabilities of this specific PHP version.


![response headers](/images/posts/php_security_best_practices/response_headers.png)


- Make sure that you don't have any files in your server that calls the `phpinfo()` function. If you want to make use of it, make sure the filename can't easily be guessed like `phpinfo.php` and don't store it on the root of your web accessible directory. Don't forget to delete it once you're done.

- Log errors instead of displaying them. Errors, notices and warnings in your web application can provide valuable information to attackers such as filenames and the name of fields that you used on your tables. Make sure you set the following in your `php.ini` file:

```
display_startup_errors = Off #disable displaying of startup errors
display_errors = Off #disable displaying of errors
html_errors = Off #disable formatting of errors in HTML
error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT #report all errors, warnings and notices including coding standards
log_errors = On #log errors to a file
```

- Disable file uploads when not needed. 


```
file_uploads = Off
```

If your web application has a file upload feature then you need to make sure that you know some of the best practices in securing file uploads. Here's a good article from Sitepoint on [how to create a secure file upload in PHP](http://www.sitepoint.com/file-uploads-with-php/). You can also make use of a library that's specifically created for handling file uploads such as the [Upload library from Josh Lockhart(Codeguy)](https://packagist.org/packages/codeguy/upload).

- Disable remote file execution. If you don't need to use functions such as `fopen`, `fsockopen` or `file_get_contents` then you can just set `allow_url_fopen` to `Off`. `Curl` can provide with similar functionality so most of the time you won't really need it. 

```
allow_url_fopen = Off #disables processing of urls
allow_url_include = Off #disable including of urls to files (e.g include 'http://iamanevilfile.php')
```

- Limit the maximum size of POST data to a value that you think is enough for your web application needs. This is to prevent attackers from flooding your web application by POSTing huge amounts of data. Note that this can be expressed in kilo (K), mega (M) or giga (G).

```
post_max_size = 10M
```

Do note that the value that you set for `post_max_size` should be larger than the `upload_max_filesize` since uploaded files are also submitted via POST. 

```
upload_max_filesize = 5M 
```

`memory_limit` should also be larger than the `post_max_size`.

```
memory_limit = 25M
```

- Limit maximum input time. This will limit the amount of time for PHP to parse input data from either `$_POST` or `$_GET`.
Note that the value is expressed in seconds.`

```
max_input_time = 5
```

- Limit maximum execution time to a reasonable value. This will automatically terminate a running PHP script once the maximum execution time is over. The default value of 30 seconds seems reasonable enough so in most cases you won't really need to change it. 

```
max_execution_time = 30
```

- Limit the use of shell functions such as `exec`, `passthru`, `shell_exec`, `proc_open`, and `popen`. If there's no other option for implementing something and you absolutely need to use it make sure that users of your web application will not be able to execute any system commands. If you need user input for executing system commands then make sure that you're validating the data correctly.


- Only allow execution of PHP files on a specific directory. Preferably this should be the web accessible root directory.

```
open_basedir = /var/www/public_html
```

- Set temporary upload directory to a path outside of the `open_base_dir`. This prevents files in the temporary upload directory from being executed.

```
upload_tmp_dir = /var/www/uploads/tmp
```

- Make sure that your web accessible directory is set to `read-only`.

```
sudo chmod -R 0444 /var/www/public_html
```

###Use CURL

Always use the CURL extension when making requests to other servers especially if you're working with sensitive data. 
This is because CURL by default makes requests securely over SSL/TLS (Secure Socket Layer/Transport Security Layer). 
Here's an example on how to perform requests using CURL:

```php
<?php
$url = 'https://bitpay.com/api/invoice';
$req = curl_init($url);
curl_setopt($req, CURLOPT_RETURNTRANSFER, TRUE);
$response = curl_exec($req);
?>
```

Also make sure to set the following options when you're working with sensitive data:  

- **CURLOPT_SSL_VERIFYPEER** - should be set to `TRUE` always. This will tell CURL to check if the remote certificate of the server where you're performing a request is valid.
- **CURLOPT_SSL_VERIFYHOST** - should be set to `TRUE` always. This tells CURL to check that the Certificate was issued to the entity that you're requesting to.


###Input Validation and Filtering

Input validation is the first layer of defense when it comes to securing your PHP applications. User input should never be trusted thus we need to filter and validate. But first lets differentiate filtering from validation:

- **Filtering** - also called sanitization. This is used for ensuring that the data is properly formatted before we try to validate. An example of filtering is removing whitespaces from a string or removing any invalid characters from an email address.

- **Validation** - the process of making sure that the data is what you expect it to be. For example if the web form asks for the age then you expect the age to be a number so the code must validate that what is inputted in the age field is indeed a number. And not just any number. If you expect the users who will fill out the form to be between ages 20 - 40 then you must also validate that the age that was inputted falls within that range. There are lots of things to consider when validating user input, as programmers its our duty to ensure that we've covered most of the scenarios.


####Filtering

PHP comes with filtering functions that you can use to sanitize data before saving into the database.

- **addslashes** - adds a backslash before a single quote (`'`), double quote (`"`), and NULL byte (`\`).
- **filter_var** - sanitizes strings based on the filters listed [here](http://www.php.net/manual/en/filter.filters.sanitize.php)
- **htmlspecialchars** - converts HTML strings into their corresponding entity.
- **htmlentities** - the same as `htmlspecialchars` the only difference is that `htmlentities` try to encode all characters which have HTML character entity equivalents. What this means is that you will have a much longer resulting string if the string that you're trying to use contains not only HTML but also characters which has an HTML entity equivalents.
- **preg_replace** - replaces all the string that matches the pattern that you specify.
- **strip_tags** - strips all HTML and PHP tags from the original string.
- **trim** - used for trimming leading and trailing whitespaces from the original string.

What function you use depends on your specific needs. If you need to save a string into the database and you expect that there will be a single quote or double quote on that string then you should call `addslashes` before saving into the database. This ensures that you won't get any unexpected character errors when inserting the string.


####Validation

PHP also comes with validation functions one of those is the `filter_var`. You can use it to validate different types of data:

- **FILTER_VALIDATE_BOOLEAN** - used for validating if the value is either `true` or `false`
- **FILTER_VALIDATE_EMAIL** - used for validating if the value is a valid email
- **FILTER_VALIDATE_REGEXP** - used for validating if the value matches a specific expression
- **FILTER_VALIDATE_URL** - used for validating if the value matches the accepted pattern of a URL
- **FILTER_VALIDATE_INT** - used for validating if the value is an integer
- **FILTER_VALIDATE_FLOAT** - used for validating if the value is a float or a decimal number
- **FILTER_VALIDATE_IP** - used for validating if the value is a valid IPv4 or IPv6 IP address

Here's how to use the `filter_var` function to validate user input:

```php
<?php
$email = filter_var($_POST['email'], FILTER_VALIDATE_EMAIL);
$age = filter_var($_POST['age'], FILTER_VALIDATE_INT);

if($email && $age && ($age >= 14 && $age <= 30)){
	//do something
}
?>
```

Note that the `filter_var` function returns the original value that you specified as the first argument if the value is valid and returns `false` if its not valid. 

There are also a bunch of PHP functions that checks for a specific data type and returns `true` if the value meets

- **is_array** - checks if a variable contains an array.
- **is_bool** - checks if a variable contains a boolean value.
- **is_double** - checks if a variable contains a double.
- **is_float** - checks if a variable contains a floating point number.
- **is_integer|is_long|is_int** - checks if value is a valid integer. Note that this doesn't check for the data type since all user input is always in string so either the value `'1'` or simply `1` will pass. 
- **is_null** - checks if a variable is `NULL`
- **is_numeric** - checks if a value is a valid number, the main difference of this function with `is_int` is that it also checks for the data type so string numbers such as `'1'`, `'23'`, or `'14'` will return `false`. 
- **is_object** - checks if a variable contains an object.
- **is_resource** - checks if a variable contains a resource.
- **is_scalar** - checks if a variable contains a scalar value.
- **is_string** - checks if a variable contains string.

And there are also those that checks for the presence of a specific value:

- **isset** - checks if a specific variable has been set or declared. Note that this disregards the actual value so if the variable in question doesn't have a value assigned to it (aka `undefined`) then it will still return `true`.
- **empty** - checks if a specific variable has a truthy value. Here's a good reference on this subject: [type comparisons](http://www.php.net/manual/en/types.comparisons.php)


####Input Filtering and Validation Libraries


Here are some libraries that you can use for input validation and filtering:

- [Respect\Validation](http://documentup.com/Respect/Validation/)
- [Filterus](https://github.com/ircmaxell/filterus)
- [Valitron](https://github.com/vlucas/valitron)
- [HTML Purifier](http://htmlpurifier.org/)

###Working with Databases

####Limit User Privileges

When working with databases its a good practice to not use the root user as the user of the database. Sometimes out of laziness we tend to use the default database user in MySQL when connecting to the database like this:

```php
<?php
$db = new Mysqli("localhost", "root", "", "my_db"); 
?>
```

This is not a good practice since the root user has the privilege to perform almost all the operations that you can perform in all of the database that's currently residing in the MySQL server. Selecting data, inserting new data, updating, deleting, truncating tables, dropping tables, dropping a whole database. All of these can be performed by the root user so a successful SQL injection attack can pretty much give an attacker the privilege to do all of these operations.

Limiting the user privileges is really simple. In the screenshot below I'm using a tool called phpmyadmin to create a user that has only read privileges:

![mysql read privileges](/images/posts/php_security_best_practices/mysql-privileges.png)


While you're there you can also set resource limit to the user. Setting a reasonable resource limit reduces the possibility of malicious users flooding your database with lots of queries. Just be sure to do your research first before setting resource limits to a specific database user, you don't want the limit to run out on genuine users of your application:

![limit](/images/posts/php_security_best_practices/resource-limits.png)


Limiting user privileges effectively reduces the risk of a successful SQL injection attack. It means that even if an attacker manages to execute a query like the following:

```
DROP TABLE tbl_users
```

It won't be allowed by the database if the database user that was used doesn't have a privilege to drop a table. 
But what if an attacker successfully gains access to a database user that has all the privileges to make a successful attack? For example a System Administrator user account has been hacked and now the attacker can simply use SQL injection to do all sorts of evil stuff with the database. That's where the use of PDO and prepared statements comes in.


####Use PDO Or MySQLi

Use the PDO or MySqli extension when building applications that connect to the MySQL database. The original PHP MySQL API is already deprecated and therefore no longer recommended. Using PDO or MySqli will give you the benefit of using parametrized queries which effectively reduces the risk of SQL injection attacks if used correctly. Here's an example on how to perform database queries using PDO:

```php
<?php
$user_id = $_GET['id'];
if(is_int($user_id)){ //check if id is an integer

	try{
	    $conn = new PDO("mysql:host=localhost;dbname=my_db", $_SERVER['db_user'], $_SERVER['db_password']);
	    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); //tell PDO to throw exceptions  
	     
	    $sql = $conn->prepare("SELECT username, role FROM tbl_users WHERE user_id = :user_id");
	    $sql->bindParam(':user_id', $user_id, PDO::PARAM_INT); //safely substitute the placeholder(:user_id) to the real value ($_GET['id'])
 	    $sql->execute(); //execute the query
	 
	 	$user = $sql->fetch();
	 	echo $user['username'];
	  
	}catch(PDOException $e){
	    log_exception($e->getMessage()); //log the exception, don't echo 
	}
}
?>
```

How does PDO make things more secure you ask? Its more secure in the sense that it sends the query and data (user input) separately to MySQL. So what happens is that the SQL string that you supplied as the argument for the `prepare` method is parsed and then later on using `bindParam` the placeholder is safely substituted to the user input. Finally the query is executed. In simple terms MySQL considers every user input as a string with no meaning when PDO is used so SQL injection is effectively prevented. 

If you want to learn more about PDO be sure to check out the [PDO tutorial for MySQL Developers](http://wiki.hashphp.org/PDO_Tutorial_for_MySQL_Developers)


####Storing Passwords

One more thing to consider when working with databases is how to safely store passwords. You probably already know that its a bad practice to simply store passwords in plain text. Because this means that when attackers were successfully able to dump the contents of a user table then they will basically have access to all of the users information which includes things such as credit card numbers, favorite TV show or the name of your first crush. 

And it might already be old news to you but these functions for hashing passwords isn't that safe as attackers can use brute force attack or rainbow tables in order to determine a password:

- **md5**
- **sha1**

You can use the following functions instead:

- **hash_pbkdf2**
- **crypt**
- **password_hash**

Note that some of the hashing functions like `hash_pbkdf2` and `password_hash` are only available on PHP 5.5. `crypt` is available on PHP 4 and 5.

Here are some examples on how to use each of the above hashing methods:

```php
<?php
$password = 'mySupeRandomPassword'; //note: don't use a password like this

//using hash_pbkdf2
$salt = mcrypt_create_iv(16, MCRYPT_DEV_URANDOM); //generate a random salt
$iterations = '1525';
$hash = hash_pbkdf2("sha256", $password, $salt, $iterations, 30); //hashing algorithm, raw password, random salt, iterations, hash length

//using crypt
$salt = mcrypt_create_iv(20, MCRYPT_DEV_URANDOM); //generate a random salt
$hash = crypt($password, $salt); //raw password, random salt


//using password_hash
$hash = password_hash($password, PASSWORD_DEFAULT); //PASSWORD_DEFAULT uses the Bcrypt alogrithm, you can also use PASSWORD_BCRYPT if you want to use the CRYPT_BLOWFISH algorithm for hashing the password
?>
```

You can implement the `hash_pbkdf2` method by storing both the hash and the salt in a single field (prepend the salt to the hash). 

```php
<?php
//verifying using hash_pbkdf2
$password = $_POST['password'];

/*
get hash and salt from database
*/

$hash = hash_pbkdf2("sha256", $password, $salt_from_db, $iterations, 30);
if($hash_from_db == $hash){
	//do something
}
?>
```

Some people say that you should store your salt strings to a database separate from the database where you store your hashes. Maybe this is true if you don't use random salts for each of the passwords. An attacker would still have difficulty in cracking a password even if he has access to both salt and hash as long as the salt is random for each user.

For `crypt` and `password_hash` there's no need to store the random salts separately since you can verify if the password is valid without specifying the salt that was used:

```php
<?php
//verifying using crypt
$password = $_POST['password'];

/* 
get hash from database
*/

if(crypt($password, $hash) == $hash){ //check if password is valid
	//do something
}


//verifying using password hash
if(password_verify($password, $hash)){
	//do something
}
?>
```

Note that you can also use the `password_verify` method for verifying hashes that are created by using the `crypt` method `password_hash` and `crypt` methods as they both use the [C Crypt Scheme](http://en.wikipedia.org/wiki/Crypt_(C)).

You can also use password hashing libraries like [PHPAss](https://github.com/hautelook/phpass/) or [Password-Compat](https://github.com/ircmaxell/password_compat) if you want. The main benefit of using libraries is that they're often compatible with lower PHP versions but are still secure. Here's an example on how to use each of those:


```php
<?php
//using password-compat
require 'vendor/ircmaxell/password-compat/lib/password.php'; 
$hash = password_hash($password, PASSWORD_BCRYPT);

//verifying
if(password_verify($password, $hash)){
	//do something
}
?>
```

```php
<?php
//using PHPAss
$cost = 8; //algorithmic cost that should be used, you can play around this value but this is mostly dependent on your servers hardware
$portable_hash = false; //do not store salts along with hash
$phpass = new PasswordHash($cost, $portable_hash);  

$hash = $phpass->HashPassword($password);

//verifying
if($phpass->CheckPassword($password, $hash)){
	//do something
}
?>
```

Note that the password-compat library uses the same syntax as the password hashing method `password_hash` in PHP 5.5. But this library works for PHP 5.3.7 and above. So this library is intended for providing forward compatibility to PHP versions lower than 5.5. This means that there's no real need to use this library if you're already using PHP 5.5.


Other things to remember when storing passwords:

- Do not email or log passwords if your users forgot their password just email them a link that will allow them to update their password.
- Do not store passwords in plain text (yeah I know I said this already)
- Use random password salts
- Do not limit the length of passwords that can be entered by your users
- Encourage your users to use long, secure and random passwords by implementing password strength meters on the front-end of your application. Passwords doesn't really need to be memorable as users can pretty much use password managers like [keepas](http://keepass.info/) to store their passwords. 


###Working with Uploaded Files

When working with uploaded files do not use the `$_FILE` super global in determining the type of the file as the can be easily spoofed by simply changing the file extension:

```php
<?php
if($_FILES["file"]["type"] == 'jpg'){
	//do something with the file
}
?>
```

Use the `finfo` class to determine the actual mime type of a file instead. This is slower than simply checking the file type from the `$_FILE` super global but it does the job of determinining the real file type:

```php
<?php
$file_info = new finfo(FILEINFO_MIME_TYPE);
$file_contents = file_get_contents($_FILES['iamnotanevilfile']['tmp_name']);
$mime_type = $file_info->buffer($file_contents);
//this will return any valid mime type listed here: http://en.wikipedia.org/wiki/Internet_media_type
?>
```

Better yet use a library that's especially created for this type of task like the [upload library](https://github.com/codeguy/Upload) by Josh Lockhart. Here's how you can use it to verify that the file that was uploaded is an image file that's not greater than 2 MB in size.

```html
<form method="POST" enctype="multipart/form-data">
    <input type="file" name="some_file" value=""/>
    <input type="submit" value="Upload File"/>
</form>
```

```php
<?php
$upload_path = new \Upload\Storage\FileSystem('/upload_path');
$file = new \Upload\File('some_file', $upload_path);

$image_types = array('image/gif', 'image/png', 'image/jpeg', 'image/bmp');

$file->addValidations(array(
    new \Upload\Validation\Mimetype($image_types), //can also supply a string
    new \Upload\Validation\Size('2M') //size should be 2 MB or less, you can also use B, K, G as the size unit
));

//try to upload the file
try{
    $file->upload(); //the file is uploaded if it successfully pass through the validation
}catch(\Exception $e){
    $errors = $file->getErrors(); //the file upload failed
}
?>
```

##Conclusion

In this article you've learned some of the basic ways you can add security to your PHP projects. We've barely scratch the surface with this guide. There's a lot more you can do to improve the security of the applications that you're writing. Be sure to check out the resources below if you want to learn more about securing PHP applications.


##Resources

- [OWASP PHP Security Cheat Sheet](https://www.owasp.org/index.php/PHP_Security_Cheat_Sheet)
- [Survive the Deep End: PHP Security](http://phpsecurity.readthedocs.org/)
- [PHP.Net Security Manual](http://www.php.net/manual/en/security.php)
- [PHP Security Guide](http://phpsec.org/)
- [PHP Security Best Practices for Sys Admins](http://www.cyberciti.biz/tips/php-security-best-practices-tutorial.html)



