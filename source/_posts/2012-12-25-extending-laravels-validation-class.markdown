---
layout: post
title: "Extending Laravel's Validation Class"
date: 2012-12-25 18:29
comments: true
categories: [laravel-3, validation, php]
updated: 2014-01-27
---

Laravel is built with useful validation rules like required, numeric, unique data from a table in a database, etc.
But there are some situations where the built-in validation rules cannot handle.
That's where extending Laravel's validation class comes in handy.
In this post I'll be showing you how to extend Laravel's validation class. 
This will enable you to use custom validation rules specifically created for your needs.

<!--More-->


####Validating Arrays

One thing I've noticed while evaluating Laravel is that it doesn't have the methods that deals with an array of data.
For example if you have this form:

```html
<form method="post">
	<label for="">Students</label>
	<input type="text" name="student_name[]" id="student_name">
	<input type="text" name="student_name[]" id="student_name">
	<input type="text" name="student_name[]" id="student_name">
	<input type="submit" value="Save">
</form>
```

And you want every student name to be required. Using Laravel's built in methods. You do something like this:

```php
<?php
$rules = array('student_name' => 'required');

$validator = Validator::make(Input::all(), $rules);

if($validator->fails()){
	//redirect back to form with errors
}else{
	//save form to database
}
?>
```

But if you might have already noticed. This doesn't work. 
Curiosity leads us to inspecting Laravel's validation method for the required rule (```laravel/validator.php```): 

```
<?php
/**
 * Validate that a required attribute exists in the attributes array.
 *
 * @param  string  $attribute
 * @param  mixed   $value
 * @return bool
 */
protected function validate_required($attribute, $value)
{
	if (is_null($value))
	{
		return false;
	}
	elseif (is_string($value) and trim($value) === '')
	{
		return false;
	}
	elseif ( ! is_null(Input::file($attribute)) and is_array($value) and $value['tmp_name'] == '')
	{
		return false;
	}

	return true;
}
?>
```

As you can see from the above method. It doesn't seem that Laravel is automatically dealing with array as inputs for form. Looking closer this block of code seems to be close to what were looking for. But this only deals with file input(stored in ```$_FILES```). So this isn't the method were looking for.

```
<?php
elseif ( ! is_null(Input::file($attribute)) and is_array($value) and $value['tmp_name'] == '')
{
	return false;
}
?>
```

Thankfully the creators of Laravel made it incredibly easy to extend its validation class in case a need like this arises. To extend Laravel's validation class we'll need to create a new library at ```application/libraries```.
Let's name it ```Validator```.

```
<?php
class Validator extends Laravel\Validator {

}
?>	
```

Then disable the autoloading of the validator class on ```application/config/application.php``` file.

```
'Task'       	=> 'Laravel\\CLI\\Tasks\\Task',
'URI'        	=> 'Laravel\\URI',
'Validator'  	=> 'Laravel\\Validator', //remove this line
'View'       	=> 'Laravel\\View',
```

Then we create a method that will deal with array inputs:

```
<?php
/**
 * checks if an array input has no empty values
*/
public function validate_arrayfull($attribute, $value, $parameters){
	return in_array('', $value);
}
?>
```

Naturally laravel's input class would be able to capture any kind of input be it a regular string, file, or array.

Methods for the validation class accepts 3 arguments:

1. **Attribute** - the name given to the input (Eg. name, age)
2. **Value** - the value of the input (Eg. Yael, 27)
3. **Parameters** -  additional data passed after defining the rules.
For example the additional data that you pass after defining a ```unique``` rule:

```
<?php
$rules = array(
	'username' => unique:tbl_users,username
);
?>
```

The additional data that I'm referrring to is the string that comes after the colon (tbl_users,username).
In the case of defining a unique rule for a particular field. The first parameter is the name of the table, the second parameter is the name of the field.

The important thing to note here is that parameters are separated by comma.
And that method names has a prefix of ```validate_```.


Ok back to the ```arrayfull()``` method. 
Basically what the ```arrayfull()``` method does is to check whether an array contains empty values 
by using the ```in_array()``` method. The ```in_array()``` method simply returns ```true``` if it has found a specific value in the array and ```false``` if it didn't find the value:

```
return in_array('', $value);
```

####Validating Dates

One more thing I've noticed about Laravel is its date validation rules. 
It only has rules for before and after a certain date.
This is good but there should also be a validation rule for simply validating if
the user input is indeed a date. So I've written a method that does it:

```
<?php
public function validate_date($attribute, $value, $parameters){
	$e_str = explode("-", $value);
  if(count($e_str) === 3){
    
    //expected format for date input is: Y-m-d
    $year = $e_str[0];
    $month = $e_str[1];
    $day = $e_str[2];

    return checkdate($month, $day, $year); //expected format for checkdate is: m-d-y
  }
  return false;
}
?>
```

As you can see were counting the number fragments after invoking the ```explode()``` method.
Anything other than 3 is not a valid number of fragments since the expected date format is supposed
to have 3 fragments(Year-Month-Day).
Once it passes this condition we then check if the date is a valid date in the Gregorian calendar 
by invoking the ```checkdate()``` function which accepts 3 arguments(month, day, year).


####Default Validation Messages

You can just set the validation messages when creating an instance of the validator class like this:

```
<?php
$rules = array();

$messages = array(
	'username' => 'username is required'
	);
	
$validator = Validator::make(Input:all(), $rules, $messages);
?>	
```

But if you want to set default messages for your 
validation rules then you can set it on ```application/language/en/validation.php```.

```
<?php
"date"		 		=> "The :attribute is invalid date",
"arrayfull"		=> "The :attribute contains empty values",
"arrayunique"	=> "The :attribute contains duplicate values"
?>
```

The key will be the name of the validation method. 
For example if the name of your validation method is ```validate_date``` then the key will be ```date```.
The value will be the error message that you want to show up when there's an error with the validation.
```:attribute``` represents the name of the field.



###Resources

- [Laravel Documentation](http://laravel.com/docs)
- [Sample Application Source Code](https://github.com/anchetaWern/tutorials/tree/master/extending_laravels_validation_class/application)