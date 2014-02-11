---
layout: post
title: "Getting Started with Unit Testing in PHP"
date: 2012-12-17 14:39
comments: true
categories: [unit-testing, phpUnit]
updated: 2013-09-21
---


I finally got the time to play around with unit testing in PHP. 
I've heard about the term months ago but I really never had the time to 
play around with it because I considered it as not absolutely necessary
for my development workflow. I mean I can still produce useable programs without
writing a test for it right?

But admit it, testing the program that you have written is not really that exciting
as writing the program itself. Sometimes we even get lazy and not test the program at
all only to find things breaking on production. (Note: I'm referring to in-browser testing here)

Ok so maybe I haven't convinced you to do unit testing but I'm just here to share my first experience
of doing unit testing in PHP so I think its fine.

Let's get straight to the point and end this boring introduction.


<!--More-->


###The Process

The idea behind Unit Testing is that you should write your test first
before writing the actual program (the code that you're going to test).
This doesn't really made sense the first time I've heard of it, because how will you
test something that doesn't even exist right? But that's just how TDD (Test Driven Development) works.
It may seem difficult but if you have a crystal clear understanding of the program
that you're trying to create then writing a test before writing the actual program 
wont' be that hard. Here's the actual process:

1. Write the test code
2. Write the code to be tested
3. Run the tests
4. Refactor the code based on the test results


###Things You'll Need

- [Simple Test](http://www.simpletest.org)
- [Composer](http://getcomposer.org/) - If you're familiar with Node.js this is like ```npm``` but for PHP.
- [PHPUnit](https://github.com/sebastianbergmann/phpunit/)


###Simple Test

Before we play around with Composer and PHPUnit we'll play with Simple Test. 
If I have to describe it Simple Test is like the trimmed down version of PHPUnit that's 
why its the perfect starting place for learning unit testing in PHP. 

Simple Test can be run on the browser and on the terminal so you have the freedom to choose
where you want to run your tests.

If you haven't downloaded Simple Test yet, now is the time to do so. 
Once you're done with downloading, extract it on your working directory.
The simple test directory will look something like this:

![simple_test_dir](/images/posts/playing_with_unit_testing_php/simpletest_dir.jpg)

Ok cool, now create the test file. 
I guess the convention that most people follow is to append ```_test``` to the actual class that were trying to test.
So if we are planning to create a class called ```users``` and were writing a test for it then the 
filename for the test would be ```test_users.php```. 

Now put the following code in your ```test_users.php``` file.

```php
<?php
require_once(dirname(__FILE__) . '/simpletest/autorun.php'); //this is responsible for running your test code
require_once('users.php'); //the future file that will contain the class that we want to test 


//autorun.php file imports unit_tester.php 
//which contains the class that were extending here
class TestUsers extends UnitTestCase{ 

}
?>	
```

Like I said earlier, we must have a clear understanding of the program that we will create
before we actually code it. 

Just for the purpose of trying out unit testing in PHP were just going to create a simple class
that let's you create, update, delete, and view users. 
Yep CRUD! but were not actually going to touch the database.
Were just gonna use arrays to store our users.

With this we already know that we have to create methods for:

- creating new users
- updating current users
- delete current users
- view users


Now we have a clear understanding of the program that were going to write.
All we have to do now is to imagine that the ```users``` class has already 
been created. And all were doing now is calling the methods in that class.

Going back to ```test_users.php```. 
Create a method that will test if a user has really been created
after calling the imaginary ```create_user()``` method.

Methods for classes used for testing also has ```test``` as a prefix.
So if were trying to check if a user has indeed been created. 
Then the name of our method would be something like ```testUserCreated```.

```
<?php
public function testUserCreated(){
	$users = new Users(); 
	$old_users = $users->getUsers(); //get current users
	
	//create a new user
	$users->createUser(
		array(
			'name' => 'kirito', 
			'age' => 20, 
			'address' => 'sao'
			));

	$new_users = $users->getUsers(); //get new users 

	//compare the old user count to the new user count, 
	//returns true if the new user count is greater than the old user count
	$newcount_is_greater_than_old_count = (count($new_users) > count($old_users)); 
	$this->assertTrue($newcount_is_greater_than_old_count);
}
?>
```

We have to create an object for the class that were trying to test for every method
in the test class. This keep things at an atomic level. 
This also gives us the ability to use more than one class for each method in the test class.

At this point you can already run the test, but of course it would fail since we haven't
created the class that were trying to test yet.

Ok let's continue writing methods for our test class.
This time were going to test if the user count is what we expect
it to be after adding a couple of users.

```
<?php
public function testUserCount(){
	$users = new Users();
	$users->createUser(array('name' => 'kirito', 'age' => 20, 'address' => 'sao'));
	$users->createUser(array('name' => 'asuna', 'age' => 21, 'address' => 'sao'));
	$current_users = $users->getUsers();
	$count_is_two = (count($current_users) == 2); //after adding two users we expect that the current number of users is 2
	$this->assertTrue($count_is_two); //check if our condition has returned true
}
?>
```

Create another test method that will test if the ```deleteUsers()``` method is working:

```
<?php
public function testUserNothing(){
	$users = new Users();
	$users->createUser(array('name' => 'wern', 'age' => 20, 'address' => 'sfc')); //create a new user
	$users->deleteUsers(); //delete all the users
	$current_users = $users->getUsers(); //get all the current users

	//after deleting all users we expect 
	//that there are no more users, thus the count will be zero
	$count_is_zero = (count($current_users) == 0);

	$this->assertTrue($count_is_zero); //check if our condition has returned true
}
?>
```

Next we test if the ```deleteUser``` method is really working:

```
<?php
public function testUserDeleted(){
	$users = new Users();
	$users->deleteUsers();
	$old_users = $users->getUsers();

	$users->createUser(array('name' => 'kirito', 'age' => 20, 'address' => 'sao'));
	$users->createUser(array('name' => 'asuna', 'age' => 21, 'address' => 'sao'));
	$users->deleteUser(1);

	$current_users = $users->getUsers();
	$this->assertEqual(count($current_users), 1);
}
?>
```	

Finally, create another method that will check if the users details has really been updated:

```
<?php
public function testUserUpdate(){
	$users = new Users();
	$current_users = $users->getUsers();
	
	//first user is at index 0, which makes its id 0
	$users->createUser(array('name' => 'kirito', 'age' => 20, 'address' => 'sao'));
	$old_name = $users->getUser(0)['name'];
	$users->updateUser(array('name' => 'kirigaya kazuto'), 0); //supply the user id as 2nd argument
	$new_name = $users->getUser(0)['name'];

	$this->assertNotEqual($old_name, $new_name); //check that the old user name is not equal to the new name
}
?>
```	


###User Class

Now were ready to create the ```users``` class. 
Pretty much we already know what our class would look like
based on the methods in the test class that we created so here it is:

```
<?php
class Users{
	
	public $users = array();

	public function createUser($user_details){
		$current_users = $this->users;
		array_push($current_users, $user_details);
		$this->users = $current_users;
		return $current_users;
	}

	public function updateUser($user_details, $user_id){
		$current_users = $this->users;
		foreach($user_details as $field => $value){
			$current_users[$user_id][$field] = $value;
		}
		
		$this->users = $current_users;
		return $current_users[$user_id];
	}

	public function deleteUser($user_id){
		$current_users = $this->users;
		unset($current_users[$user_id]);
		$this->users = $current_users;
		return $current_users;
	}

	public function deleteUsers(){
		$this->users = array();
		return $this->users;
	}

	public function getUser($user_id){
		$current_users = $this->users;
		return $current_users[$user_id];
	}

	public function getUsers(){
		return $this->users;
	}
}
?>
```	

I can't think of beautiful way to mess this up and make the test fail so
if you run the test now (either on the browser or on the terminal) it will
pass. 


####Running Simple Test

You can run the test on the browser by pointing out to the test file. 
Mine is at: ```http://my.dev/tester/php/unit_testing/user_test.php```

![simple_test_browser](/images/posts/playing_with_unit_testing_php/simpletest_browser.jpg)

Or you can do it on the terminal by executing the following command:

```
php user_test.php
```

![simple_test_cmd](/images/posts/playing_with_unit_testing_php/simpletest_cmd.jpg)


I'll just leave it to you how you would want this to fail, maybe remove some
code on the ```users``` class, let it fail then fix it. The best way to learn is to 
mess things up. Try to get yourself in a deep hole then try to climb up again.
That's learning things the hard way, it would take some time but you will surely not
forget what you've learned after seeing Natalie Portman if you learn things this way.


###Composer

For the part two of this little walkthrough on PHPUnit Testing were going
to take a look at Composer (PEAR? pftt.) and how we can use it to import PHPUnit
on our directory.


####Installing Composer

As stated in the composer website, you can install composer through ```curl``` in which 
case you can download ```curl``` [here](http://curl.haxx.se/download.html) if you don't
already have it on your system.

```
curl -s https://getcomposer.org/installer | php
```

There's also the windows installer if you're on windows.

And lastly you can also install it via ```php``` itself.

```
php -r "eval('?>'.file_get_contents('https://getcomposer.org/installer'));"
```

The above methods installs composer globally and you won't have the ```composer.phar``` if composer
is installed globally. But we don't really need that so create a ```composer.json``` file instead.


####Installing PHPUnit

Inside that file were going to specify the dependencies. We only need one and that is PHPUnit.
There are a bunch of PHPUnit packages in [packagist.org](https://packagist.org/search/?q=phpunit) but were
going to use ```EHER/PHPUnit``` since it gives the idea that it can be used with composer plus it has 4000+ downloads
at the time of writing of this post which means that many people are using it.

```
{
    "require": {
        "EHER/PHPUnit": "dev-master"
    }
}
```

Once you're done with that you can now run ```composer install```. 
This can take a couple of minutes depending on your connection speed as its going
to download the dependencies that you've specified. 

Once its done you will now see a new folder called ```vendor``` which contains the following files:

![phpunit_dir](/images/posts/playing_with_unit_testing_php/phpunit_dir.jpg)


###Playing with PHPUnit

Now were ready to play with PHPUnit. 
Were going to start with something simple, a test for a calculator class.

Our simple calculator would only have 4 methods:

- method for adding an array of numbers
- method for subtracting two numbers (we can't do an array of numbers since the difference is affected by the order of the items)
- method for multiplying an array of numbers
- method for dividing two numbers


####Calculator Test

Create a new file and call it ```calculator_test.php```.

```
<?php
require_once('calculator.php'); //our calculator class which we will creater later.
class CalculatorTest extends PHPUnit_Framework_TestCase{
	
	//test if the add() method in our calculator class
	//actually returns the sum that
	//were expecting
	public function testAdd(){
		$calc = new Calculator();
		$sum = $calc->add(array(2,3,4,5));
		$this->assertEquals(14, $sum); //check if 2+3+4+5 is equal to 14
	}

	//test if the subtract() method in our calculator class
	//actually returns the difference that
	//were expecting
	public function testSubtract(){
		$calc = new Calculator();
		$difference = $calc->subtract(5,2);
		$this->assertEquals(3, $difference); //check if 5 - 2 is equal to 3
	}

	//test if the multiply() method in our calculator class
	//actually returns the product that
	//were expecting	
	public function testMultiply(){
		$calc = new Calculator();
		$product = $calc->multiply(array(1,3,5,6)); 
		$this->assertEquals(90, $product); //check if 1*3*5*6 is equal to 90
	}

	//test if the divide() method in our calculator class
	//actually returns the quotient that
	//were expecting	
	public function testDivide(){
		$calc = new Calculator();
		$quotient = $calc->divide(10,2); 
		$this->assertEquals(5, $quotient); //check if 10/2 is equal to 5
	}
}
?>
```

####Calculator Class

And the calculator class:

```
<?php
class Calculator{
	
	public function add($numbers_to_add){
		$sum = 0;
		foreach($numbers_to_add as $num){
			$sum = $num + $num;
		}
		return $sum;
	}

	public function subtract($x, $y){
		return $y - $x;
	}

	public function multiply($numbers_to_multiply){
		$product = 0;
		foreach($numbers_to_multiply as $num){
			$product = $num * $product;
		}
		return $product;
	}

	public function divide($x, $y){
		return $x / $y;
	}

}
?>
```

Ok so I've intentionally messed up the calculator class so the test would fail.
By taking a closer look you would notice what methods I've messed up but don't
fix it yet because were going to take a look at how the test can help 
us determine what exactly is wrong with our calculator class.

You can go ahead and open up a new terminal at ```vendor/bin``` then just specify the location of
your test file like this:

```
phpunit D:\web_files\tester\php\unit_testing\calculator_test.php
```

But if you don't want to specify the location of your test file everytime you run the 
test then just add the path for phpunit in your system path. 
Mine looks something like this:

```
D:\web_files\tester\php\unit_testing\vendor\bin
```

So if I'm running my tests I only have to open a new terminal on the directory
where I have my tests and run phpunit together with the name of the test file:

```
phpunit calculator_test.php
```

Were going to get an error after running the command above:

![phpunit_calcfailed](/images/posts/playing_with_unit_testing_php/phpunit_calcfailed.jpg)


We can see from here that we've messed up the ```add()``` and ```subtract()``` method.
For the ```add()``` method we were expecting to get ```14``` but our method only returned ```10```.
And for the ```subtract()``` method we were expecting to get ```3``` but it returned ```-3``` instead.

Looking closely at the ```add()``` method inside the loop
instead of adding the current sum to the current number were adding the
current number with the current number so we ended up with ```10``` as a result
because the last item in our array of number is 5. And ```5 + 5``` is ```10```.

```
<?php
public function add($numbers_to_add){
	$sum = 0;
	foreach($numbers_to_add as $num){
		$sum = $num + $num; //this line messed it up
	}
	return $sum;
}
?>
```	

So were just going to replace it with:

```
$sum = $num + $sum
```

As for the ```subtract()``` method we simply messed up the ordering
of the variables to be subtracted:

```
<?php
public function subtract($x, $y){
	return $y - $x;
}
?>
```

So were just going to replace it with:

```
return $x - $y;
```

Running the test again:

![phpunit_calcsuccess](/images/posts/playing_with_unit_testing_php/phpunit_calcsuccess.jpg)

Yay! everything passes!

Taking a look closely at the test results it said: 

```
OK (4 tests, 4 assertions)
```

Tests are the methods that you've written for testing.
Assertions are the assertion methods that you've used from the PHPUnit test suite
like ```assertEquals()```.


###More PHPUnit Fun

By now you should have probably grokked the basics of unit testing in PHP.
But were going to play around with it further. 

This time without using a class to test out. 
You may think that this beats out the purpose
of unit testing but were just here to play and see what
PHPUnit has to offer. Though I'm not forcing you to do the same. 
You can always write classes to test
out if you want.

####No Class Test

Create another test and call it ```noclass_test.php```.
As the name suggests were not going to use any class
to test out. Were going to write the functionality
itself inside our test methods.

```
<?php
class NoClassTest extends PHPUnit_Framework_TestCase{

}
?>
```

#####Assert Empty

First let's test out the ```assertEmpty()``` method 
which simply checks if the value of a variable is indeed empty.
The method below will return true since we've supplied it with an empty
array.

```
<?php
public function testEmptyArray(){
	$array = array();
	$this->assertEmpty($array);
	return $array;
}
?>
```

#####Dependencies

The methods that we write for a class isn't standalone, 
which means that we don't just call it and be done with it.
Sometimes some of our methods depends on the return value of
other methods of our class. 

And that's the idea behind dependencies. In PHPUnit we can also
have test methods that depends on the return values of other test methods.
We can specify this by adding the ```@depends``` keyword together with the 
name of the method in which our method depends on.

As you can see the method below depends on the return value of the ```testEmptyArray()``` method.
We can receive the return value of ```testEmptyArray()``` by adding a parameter in this
case we call it ```$array```. Methods can only have 1 return value so at most we'll only have
one parameter in our method to receive the return values.

```
<?php
/**
 * @depends testEmptyArray
 */
public function testAddUser(array $array){

	//push an item to the empty array returned from testEmptyArray
	array_push($array, array('name' => 'dom', 'age' => 21)); 
	$this->assertNotEmpty($array); //check if array is not empty
	return $array;
}
?>
```

Create another method and call it ```testUpdateUser()``` which will simply 
check if the old value is not equal to the value after updating.

Again were depending on another methods return value so we need to specify
at least one parameter to receive that value.

```
<?php
/**
 * @depends testAddUser
 */
public function testUpdateUser(array $user){

	//this uses the user that we pushed earlier
	//from the testAddUser() method which is: dom and 21

	$old_name = $user[0]['name'];  //dom
	$old_age = $user[0]['age']; //21

	//update it with ash and 15
	$user[0]['name'] = 'ash';
	$user[0]['age'] = 15;

	//this will return true since we've updated both values
	$this->assertNotEquals($old_name, $user[0]['name']);
	$this->assertNotEquals($old_age, $user[0]['age']);

	return $user;
}
?>
```

#####Data Providers

We can also have methods whose only job is to be a ```data provider```.
A data provider is simply a method which returns values. 
It doesn't have assert methods in it.

Here were returning an array of students with swords and skills:

```
<?php
public function sword_and_skills(){
	$students = array(
		'kirito' => array('sword' => 'dark repulser', 'skill' => 'dual blades'),
		'asuna' => array('sword' => 'wind fleuret', 'skill' => 'two handed assault sphere'),
		'klein' => array('sword' => 'karakurenai', 'skill' => 'one handed curved blade')
		);

	return $students;
}
?>
```

Let's use the above method as a data provider for our ```testContainsSwordsAndSkills()``` method.
Again were using the same format as that of ```dependencies``` only this time the keyword is ```@dataProvider``` plus
the name of the method which returns the data.

```
<?php
/**
 * @dataProvider sword_and_skills
 */
public function testContainsSwordsAndSkills($sword, $skill){
	$awesome_swords = array('dark repulser', 'elucidator', 'wind fleuret', 'karakurenai');

	$awesome_skills = array(
		'blade throwing', 'one handed curved blade', 
		'two handed assault sphere', 
		'single blade', 'dual blades'
		);

	$this->assertContains($sword, $awesome_swords); //check if all of the students has the swords considered to be awesome
	$this->assertContains($skill, $awesome_skills); //check if all of the students has the skills considered to be awesome
}
?>
```	

Examining the code above might seem confusing. And I admit that I'm still confused even now.
So if anyone of you knows what the data provider does behind the scenes then let met know in the comments.

So yup I'll give this one a shot but don't kill me if its wrong.

In our data provider we have an array which contains 3 arrays that represents the 
details (swords and skills) of the students.

```
<?php
$students = array(
	'kirito' => array('sword' => 'dark repulser', 'skill' => 'dual blades'),
	'asuna' => array('sword' => 'wind fleuret', 'skill' => 'two handed assault sphere'),
	'klein' => array('sword' => 'karakurenai', 'skill' => 'one handed curved blade')
	);
?>	
```		

In our method we have two parameters which represents the index(sword and skill) for each of the student details:

```
testContainsSwordsAndSkills($sword, $skill)
```

And that's what were checking here:

```
$this->assertContains($sword, $awesome_swords);
```

It checks whether the sword equipment of kirito, asuna and klein is in the array of awesome swords if
one of the equipped sword of the three students isn't on the array of awesome swords then the assertion would fail.
The same rule is applied with the skills.


I guess we need one more example for data provider.

```
<?php
public function anime(){
	$data = array(
			array(
				array('luffy', 'zoro', 'brook', 'sanji'),
				array('ichigo', 'zangetsu', 'toshiro', 'byakuya'),
				array('sai', 'kiba', 'gaara', 'yamato', 'jiraiya')
				)
		);
	return $data;
}
?>
```

This time were going to check if the total number of anime characters is what 
we expect it to be. As you can see from the array above we have:

- 4 characters from Onepiece
- 4 characters from Bleach
- 5 characters from Naruto

Which makes it a total of 13.

```
<?php
/**
 * @dataProvider anime
 */
public function testTotalStudents($onepiece, $bleach, $naruto){
	
	$this->assertEquals(13, count($onepiece) + count($bleach) + count($naruto));
}
?>
```

If you run the test it will pass.


Ok one last example for data provider before we proceed with the next assertion method.
This time were just going to restructure our data source:

```
<?php
public function anime(){
	$data = array(
			array(
				array('luffy', 'zoro', 'brook', 'sanji')
				),
			array(
				array('ichigo', 'zangetsu', 'toshiro', 'byakuya')
				),
			array(
				array('sai', 'kiba', 'gaara', 'yamato')
				)
		);
	return $data;
}
?>
```	

Then we'll utilize it as our data provider:

```
<?php
/**
 * @dataProvider anime
 */
public function testTotalStudents($a){
	
	$this->assertEquals(4, count($a));
}
?>
```

Here were still doing the same thing. But instead of getting the total and 
using it as compare value were going to test if the total number of students
in each array is 4. Of course this will still return true since we've already
removed jiraiya from the naruto characters array.


Did you finally grokked it? Me too! I guess its digging up to the last child of the array.
In this case its these guys:

```
<?php
array('luffy', 'zoro', 'brook', 'sanji')
array('sai', 'kiba', 'gaara', 'yamato')
array('sai', 'kiba', 'gaara', 'yamato')
?>
```

So it doesn't matter how deep your array is as it always ends up in the most deepest part.
But I can't really say for sure because I'm just concluding things based on what I've observed
by playing with PHPUnit.


####Expected Output

There's also a method used for checking the expected output of a method.
This is useful because we don't always return things using methods,
most of the time were just using methods to output things.

As you can see from the example below we first have to specify 
our expected output before we actually call the method that will 
output some string.

```
<?php
public function testOutput(){
	$this->expectOutputString("what's up world");
	echo "what's up world";
}
?>
```

####Expected Type

Yet another useful assertion method is the ```assertInternalType()``` which simply
checks if a variable or the return value of a method has the expected data type.

```
<?php
public function testType(){
	$ima_integer = 20;
	$ima_string = "meowth that's right!";
	$ima_boolean = true;
	$ima_array = array('chunibyou', 'hyouka');
	$ima_null = "nope Im not a null, im a string idjit!"; 
	$ima_float = 234.24;

	$this->assertInternalType('integer', $ima_integer);
	$this->assertInternalType('string', $ima_string);
	$this->assertInternalType('boolean', $ima_boolean);
	$this->assertInternalType('array', $ima_array);
	$this->assertInternalType('null', $ima_null); //this will fail as we supplied a string
	$this->assertInternalType('float', $ima_float);	
}
?>
```

That's all folks! You can check out the resources below if you want to learn more about unit testing.

###Resources

- [Test Driven Development](http://en.wikipedia.org/wiki/Test-driven_development)
- [PHPUnit](http://www.phpunit.de/manual/3.7/en/index.html)
- [Test-Driven PHP](http://net.tutsplus.com/sessions/test-driven-php/)