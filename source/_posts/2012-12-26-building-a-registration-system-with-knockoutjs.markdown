---
layout: post
title: "Building a Registration System Using Knockout.js"
date: 2012-12-26 16:25
comments: true
categories: [javascript, knockout.js]
---

Organizing JavaScript code is not really that easy especially if you have to do it from scratch. 
Event handlers, DOM Manipulation code, form validation code,
code for generating effects, code for submitting data or getting data from the server
can be all over the place. This is the reason why some smart people created JavaScript frameworks
like Knockout.js, Ember.js, Backbone.js, and Batman.js to make organizing JavaScript code much easier.

In this tutorial were going to build a very simple registration system using knockout.js.
Were going to use PHP and MySQL for the backend.

Here's what our final output would look like:

![output](/images/posts/registration_system_knockoutjs/output.jpg)


<!--More-->


You can pretty much improve the css if you want to but here are the only functionality that its going to have:

- **Create New Student**
- **Update Student**
- **List Existing Students**
- **Delete Student**

It's basically a simple CRUD app that we will implement using Knockout.js.


###Things We'll Need

Go ahead and download the following:

- **jQuery** - mainly for talking to the server since knockout.js can also handle events
- **Knockout.js**

Saving to MySQL database is optional you can skip it if you only want to learn about knockout.js.
But if you also want to do it then you must also have PHP, Apache and MySQL installed on your machine.


###Database

For the database we'll only use 1 table and the table would have 4 fields:

- **ID** - unique identifier for the student
- **Name**
- **Age**
- **Status** - used for setting if a record has been deleted or active

You can go ahead and execute the following on MySQL to build the database structure and put some data:

```sql
-- Dumping database structure for tutorials
CREATE DATABASE IF NOT EXISTS `tutorials` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `tutorials`;


-- Dumping structure for table tutorials.students
CREATE TABLE IF NOT EXISTS `students` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- Dumping data for table tutorials.students: ~6 rows (approximately)
DELETE FROM `students`;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` (`id`, `name`, `age`, `status`) VALUES
	(1, 'monkey d. luffy', 15, 1),
	(2, 'ron', 20, 0),
	(3, 'angel', 20, 0),
	(4, 'son goku', 30, 1),
	(5, 'naruto uzumaki', 16, 1),
	(6, 'draco', 15, 1);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
/*!40014 SET FOREIGN_KEY_CHECKS=1 */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
```

###Markup

Include the dependencies:

```html
<link rel="stylesheet" href="main.css">
<script src="knockout.js"></script>
<script src="jquery.js"></script>
```

For the markup you can see that we have this ```data-bind``` attribute.
This is basically used for binding data that is used by knockout.js to do its magic.
Take the time to read the values in the ```data-bind``` attributes:

```
<div class="container" data-bind="load: loadData()">
	<div class="new_student">
		<input type="text" class="name" placeholder="name" data-bind="value: person_name, hasfocus: person_name_focus()">
		<input type="text" class="age" placeholder="age" data-bind="value: person_age">

		<button data-bind="click: createPerson">Create</button>		
	</div>

	<table data-bind="visible: people().length > 0" class="students">
		<thead>
			<tr>
				<th>Name</th>
				<th>Age</th>
				<th>Remove</th>
				<th>Update</th>
			</tr>
		</thead>
		<tbody data-bind="foreach: people">
			<tr>
				<td>
					<span data-bind="text: name, click: nameUpdating, visible: !nameUpdate()"></span>
					<input type="text" class="name" data-bind="value: name, visible: nameUpdate, hasfocus: nameUpdate">
				</td>
				<td>
					<span data-bind="text: age, click: ageUpdating, visible: !ageUpdate()"></span>
					<input type="text" class="age" data-bind="value: age, visible: ageUpdate, hasfocus: ageUpdate">
				</td>
				<td data-bind="click: $root.removePerson"><a href="#">remove</a></td>
				<td data-bind="click: $root.updatePerson"><a href="#">update</a></td>
			</tr>
		</tbody>
	</table>	
</div>
```

The first data binding is in the container. 
Basically what it does is to call the function ```loadData()``` which loads the existing student records from the server. 

```
<div class="container" data-bind="load: loadData()">
```

And by the way the ```load``` property is totally made up because in knockout.js you can't just
call functions as they are. You need to have a property where you can call it. 
You can check out the knockout.js documentation for the properties that you can use.
Here are some of the most commonly used properties:

- **value** - used to specify the value of a form element
- **text** - used to specify the text within an element
- **click** - used to specify a function that will be executed when an element has been clicked
- **hasfocus** - used to specify a function that will be executed when a form element has focus
- **visible** - used to specify if an element is visible. 
Normally a variable is used as a value which stores either ```true``` or ```false```. 
If the value of the variable is ```true``` then the element is visible, otherwise its hidden.
If ```true``` and ```false``` bores you, then you can also use any truthy or falsy value in javascript.

Next is for the name input. As you can see we can use several properties separated by commas.
The value of this text field will be whatever is stored on the ```person_name``` variable and it will have focus on it if ```person_name_focus``` stores a truthy value.

```
<input type="text" class="name" placeholder="name" data-bind="value: person_name, hasfocus: person_name_focus">
```

Next is the button that the user will click to create a new student. 
This will just call the ```createPerson``` method. 
Yep! ```createPerson``` is a method but why are we not calling it like a normal method?
Go ahead and try putting ```createPerson()``` and see what happens. 
Whether you tried it or not here's what it actually does if you try to put it that way.
It executes the method immediately on page load. You don't want this to happen since you only want to execute it once the button is clicked. If you might have also noticed if you have some value on the text field and you press on tab it also executes the method and this messes up the default behavior(cursor goes to next form field).

```
<button data-bind="click: createPerson">Create</button>	
```

Next is the table were we will list all the student data that were fetched from the database.
Here I've used the ```visible``` property to make the table visible if there are actually records which are stored in the ```people``` variable. ```length``` is a property that we commonly have for strings and arrays in JavaScript so we can just use that as the condition for setting the visibility of the table.

```
<table data-bind="visible: people().length > 0" class="students">
```

Next we have the ```foreach``` property binded to ```tbody```.
This is used to iterate over the contents of an array.

```
<tbody data-bind="foreach: people">
```

Were already inside a loop so the context already changes. 
This means that we already have access to the objects which are stored in the array.
As you can see we have a ```span``` and an ```input```. The ```input``` is hidden by default and it only becomes visible when the user clicks on the span at that point the span will also be hidden.

```
<span data-bind="text: name, click: nameUpdating, visible: !nameUpdate()"></span>
<input type="text" class="name" data-bind="value: name, visible: nameUpdate, hasfocus: nameUpdate">
```

The ```text``` for the ```span``` and the ```value``` for the ```input``` are the same. 
This means that when you click on the ```span``` it will be hidden then the ```input``` will show up with the value that is the same with the one in the ```span```.

![output](/images/posts/registration_system_knockoutjs/text_focus.jpg)

When you click on the ```span``` it executes the ```nameUpdating``` method 
which simply changes the value of ```nameUpdate``` to ```true```.

Pretty much we've just specified the following behavior:

**span**

- visible if the text doesn't currently has focus.
- hidden if the text is focused

**input**

- visible if the text currently has focus
- hidden if the text is not focused

Next is the binding for when the user clicks on the remove link.
This simply calls the ```removePerson``` method which deletes the selected student from the array.

Knockout.js has pretty smart defaults because if you put a data binding to 
an anchor tag it prevents the default behavior(loads the address) when you click on it.

Here we've specified the context to be ```$root```. 
This simply tells that the method ```removePerson``` is declared in the model in which you applied the bindings.

```
<td><a href="#" data-bind="click: $root.removePerson">remove</a></td>
```

Next is the binding for when the user clicks on the update link.
This simply calls the ```updatePerson``` method which updates the current record based on the changes made to it.

```
<td><a href="#" data-bind="click: $root.updatePerson">update</a></td>
```

I have just given you an overview of what each method does. 
I'm going to go more in-depth in the Script section of this tutorial.


###Style

Here's the css code that I've used for this mini project.
You can copy it if you want but I recommend you to write your own if you think you need
more practice with css.

```css
.new_student {
  margin-bottom: 20px;
}

td, th {
  padding: 10px;
}

.container {
  padding: 16px;
}

thead {
  background-color: #ccc;
}

td {
  background-color: #dee;
}

.age {
  width: 37px;
}

.name {
  width: 218px;
}
```

###Script

If the explanations in the markup section didn't make much sense to you then fret not because in this section we'll go in-depth with how things really work in knockout.js.


####Student Model

First we need to have a model that represents the data available for each student.
As you can see we cache the current value of ```this``` which refers to the ```personModel```.
Why do we need to do this? Because the value of ```this``` changes depending on the scope.
This means that we can still have access to the properties 
and methods of the ```personModel``` even when inside a function 
which is called on a different context (E.g. Callback function for AJAX requests).

```javascript
var personModel = function(id, name, age){
	var self = this; //caching so that it can be accessed later in a different context
	this.id = ko.observable(id); //unique id for the student (auto increment primary key from the database)
	this.name = ko.observable(name); //name of the student
	this.age = ko.observable(age);

	this.nameUpdate = ko.observable(false); //if the name is currently updated
	this.ageUpdate = ko.observable(false); //if the age is currently updated

	//executed if the user clicks on the span for the student name
	this.nameUpdating = function(){
		self.nameUpdate(true); //make nameUpdate equal to true
	};
	
	//executed if the user clicks on the span for the student age
	this.ageUpdating = function(){
		self.ageUpdate(true); //make ageUpdate equal to true
	};

};
```

We also have this ```ko.observable``` method which makes the variable observable.
So if you make a change to the current value stored in that variable the underlying model is also updated.
The default behavior for updating the underlying model is when an input loses its focus(onBlur).
Making a variable observable means that you can execute an event whenever the value of the observable variable changes.
The values of observable variables are accessed like functions. 
For example if you have this observable variable:

```
this.name = ko.observable("someone");
```

You can access its current value by calling it like a function: ```this.name()```.

The ```nameUpdate``` and ```ageUpdate``` stores the update state(either true or false).
If the user clicks on the span the update state is updated to true. 
This also triggers the text field to show up and span to be hidden.

The ```nameUpdating``` and ```ageUpdating``` updates ```nameUpdate``` and ```ageUpdate``` to true.
These 2 functions are executed when the user clicks on the span for the student name or age.


####Model

Next is the model in which the knockout.js bindings will be applied:

```
var model = function(){
};
```

Inside the model we declare the default values for the students name, age, focus state of the student name text field, and the array that will store all the student details.

Here we have used ```ko.observableArray``` method which makes an array observable.
Remember that ```ko.observable``` is only used to monitor 
single values while ```ko.observableArray``` is used to monitor each of the items in the array. 

```
var self = this; //cache the current context
this.person_name = ko.observable(""); //default value for the student name
this.person_age = ko.observable("");
this.person_name_focus = ko.observable(true); //if the student name text field has focus
this.people = ko.observableArray([]); //this will store all the students
```

####Create Student Record

Next is the code for creating a new student record.
Since were good citizens of the web we also validate the values entered by the user 
before actually submitting it to the server.
If the validation passes we build the data to be submitted to the server, 
submit it to the server via ```POST``` method, and once the new student record is saved into the database it returns the id of the student then the new student record is pushed into the observable student array. 
Since its observable, the moment we push a new student record into the array the user interface is also updated (the new student record is displayed on the table).

This is the beauty of using JavaScript MV* frameworks. Once the underlying model is updated, the UI is also updated. You don't have to write a single line of code that updates the UI. Pretty sweet right?

```
this.createPerson = function(){
	if(self.validatePerson()){ //if the validation succeeded
	
		//build the data to be submitted to the server
		var person = {'name' : this.person_name(), 'age' : this.person_age()};
		
		//submit the data to the server		
		$.ajax(
			{
				url: 'refresher_save.php',
				type: 'POST',
				data: {'student' : person, 'action' : 'insert'},
				success: function(id){//id is returned from the server
				
					//push a new record to the student array
					self.people.push(new personModel(id, self.person_name(), self.person_age()));
					
					self.person_name(""); //empty the text field for the student name
					self.person_age(""); 
				}
			}
		);			
		
	}else{ //if the validation fails
		alert("Name and age are required and age should be a number!");
	}
};
```

The default behavior for an observable array (```ko.observableArray```) when a new record is pushed is that it  appends the new record after the last record. While the default behavior for an observable item (```ko.observable```) is just updating the UI to match the current value in the model. But you can also add effects or execute functions for when a value of an observable variable changes(E.g. fadeOut effect for when an item is removed from an observable array).


####Validate User Input

Here's the code for validating user input. We simply check if the student name and age is not empty. And check if the age is a number. If all of these conditions passes then we simply return ```true```, otherwise ```false```.

```
this.validatePerson = function(){
	if(self.person_name() !== "" && self.person_age() != "" && Number(self.person_age()) + 0 == self.person_age()){
		return true;
	}
	return false;
};
```

####Fetching Student Records

For the fetching of student records from the database all we have to do is to issue an AJAX request to the server.
The server then returns a JSON string representing all the student records that was fetched from the database.
And since were specifying the ```dataType``` to be ```json``` if the server doesn't return a json string nothing will actually be returned from the server. This also means that we no longer have to convert the returned json string manually by using something like ```JSON.parse``` to convert the json string to a JavaScript object.
As you can see were immediately looping through the returned data and pushing each of the student details to the observable array for storing student data:

```
this.loadData = function(){

	//fetch existing student data from database
	$.ajax({
		url : 'refresher_save.php',
		dataType: 'json',
		success: function(data){ //json string of the student records returned from the server
			
			for(var x in data){

				//student details
				var id = data[x]['id'];
				var name = data[x]['name'];
				var age = data[x]['age'];

				//push each of the student record to the observable array for 
				//storing student data
				self.people.push(new personModel(id, name, age));
			}
			
		}
	});
};
```

####Delete Student Record

Looking at the code below we have this ```person``` variable available to us.
This represents the current student. In the screenshot below the current student is Son Goku.

![delete_link](/images/posts/registration_system_knockoutjs/delete_link.jpg)

Having access to the current student means that we also have access to the value of its properties like id, name and age.

```
this.removePerson = function(person){
	
	$.post(
		'refresher_save.php', 
		{'action' : 'delete', 'student_id' : person.id()}, 
		function(response){
			
			//remove the currently selected student from the array
			self.people.remove(person);
		}
	);
};
```

####Update Student Record

For the updating of student record we also have access to the current student.
In this case we'll have to get all the user details that are to be submitted to the server(id, name, age):

```
this.updatePerson = function(person){
	//get the student details
	var id = person.id();
	var name = person.name();
	var age = person.age();

	//build the data
	var student = {'id' : id, 'name' : name, 'age' : age};
	
	//submit to server via POST
	$.post(
		'refresher_save.php', 
		{'action' : 'update', 'student' : student}
	);
};
```

Then we just apply the knockout.js bindings to the model. 
This simply means that were binding the UI to the model so that any changes to the model will also update the UI.

```
ko.applyBindings(new model());
```

One thing to remember is that you can apply bindings to multiple elements.
In the above example we haven't applied the bindings to any particular element. 
This means that were applying it globally. Which means that the model is applicable to all the markup.

Here's an example where we are binding only to a particular element.
In this case were binding to the ```div``` with a class of ```container```.
We can simply use a jQuery selector to select the element but it returns a jQuery object which 
knockout.js doesn't understand. So the solution 
would be to convert it to a DOM node by using ```[0]``` right after the selector.

```html
<script src="knockout.js"></script>
<script src="jquery-1.8.2.js"></script>
	
<div class="container">
	<input type="text" data-bind="value: name" autofocus>
	<button data-bind="click: echoName">Echo</button>
</div>	

<button data-bind="click: echoName">Echo</button>

<script>
var model = function(){
	var self = this;
	this.name = "";
	this.echoName = function(){
		console.log(self.name);
	};
};

ko.applyBindings(new model(), $(".container")[0]);
</script>
```

As you can see from the example above we have this ```button``` both inside and outside the container.
The one inside the container will obviously work since its a children of the element to which the bindings are applied. 
The one outside the container will just be a normal button without events attached to it.

```
<button data-bind="click: echoName">Echo</button>
```

This can be used to better organize your javascript code. So if you have multiple models you can also have multiple bindings.

###Server-side Code

####Database Connection

For the purpose of this tutorial were just using the ```MySqli``` driver for PHP
to connect to the MySQL database. But you can also use other database drivers if you want to. 

```php
<?php
$db = new MySqli('localhost', 'user', '', 'tutorials');
?>
```

The default data that is expected to be passed to the server is the ```action``` and the student data(id, name, age).
Here were checking if each of those are empty. If its empty then we assign an empty string to it, if not then we assign the value that was submitted. 
The action simply contains a string describing the action to be performed. 
The default action is fetching the records from the database.
The other actions are insert(for inserting a new student record), update(for updating an existing student record), and delete(for deleting an existing student record). 

```
<?php
$action = (!empty($_POST['action'])) ? $_POST['action'] : ''; //action to be used(insert, delete, update, fetch)
$student = (!empty($_POST['student'])) ? $_POST['student'] : ''; //an array of the student details

//check if the student is not an empty string
//and assigns a value to $name and $age if its not empty
if(!empty($student)){
	$name = $student['name'];
	$age = $student['age'];	
}

switch($action){
	//actions here...
}
?>
```

####Fetch All Student Records

For the fetching of student records were only selecting the records with the status of 1(active records).
What were doing here is looping through the results that were returned, add the update status for name and age. And then store those in the array. Once that's done we simply use ```json_encode()``` to convert the array to a json string.

```
<?php
default:
	//only select student records which aren't deleted
	$students = $db->query("SELECT * FROM students WHERE status = 1");
	$students_r = array();
	
	while($row = $students->fetch_array()){

		//default student data
		$id = $row['id'];
		$name = $row['name'];
		$age = $row['age'];

		//update status
		//its false by default since
		//this is only true if the user clicks
		//on the span
		$name_update = false;
		$age_update = false;

		//build the array that will store all the student records
		$students_r[] = array(
			'id' => $id, 'name' => $name, 'age' => $age, 
			'nameUpdate' => $name_update, 'ageUpdate' => $age_update,
			'nameHasFocus' => $name_focus, 'ageHasFocus' => $age_focus
			); 
	}

	echo json_encode($students_r); //convert the array to JSON string
break;
?>
```


####Insert Student Record to Database

For the insertion of new record to the database we simply execute an insert query
using the data passed via AJAX. After that we use ```insert_id``` to get the last 
auto-increment id from the database. We then pass it back to the client side by echoing it out.
The id is then used as the id for the new record in the student array.

```
<?php
case 'insert':

	$db->query("INSERT INTO students SET name = '$name', age = '$age'"); 
	echo $db->insert_id; //last insert id
break;
?>
```


####Update Student Record

For the updating of student record we have an additional data which is the student id. 
This will be used as a basis for updating the record.

```
<?php
case 'update':

	$id = $student['id'];
	$db->query("UPDATE students SET name = '$name', age = '$age' WHERE id = '$id'");
break;
?>
```

####Delete Student Record

For the deletion of student record we only have the student id.
Were not actually executing a delete query in here instead were 
just updating the ```status``` to ```0```. 
Delete queries are really dangerous because you can't restore the records
later on in case the user changes their mind.
I think having a field that stores the state of the record is better.

```
<?php
case 'delete':

	$id = $_POST['student_id'];
	$db->query("UPDATE students SET status = 0 WHERE id = '$id'");
break;
?>
```

###Demo

I've re-implemented the code above using `localStorage` as a data store. Here's the demo:

{% jsfiddle eFwQp %}


That's it! The best way to really learn things is to build something with it. 
Be sure to check out the resources below if you get stuck and you want to learn more about knockout.js.


###Resources

- [Understanding MVC and MVP](http://addyosmani.com/blog/understanding-mvc-and-mvp-for-javascript-and-backbone-developers/)
- [Knockout.js Documentation](http://knockoutjs.com/documentation/introduction.html)
- [Knockout.js Live Examples](http://knockoutjs.com/examples/)
- [Knockout.js Learning Site](http://learn.knockoutjs.com/)
- [Sample Application Source Code](https://dl.dropboxusercontent.com/u/126688107/tutorials/registration_system_using_knockoutjs.7z)


