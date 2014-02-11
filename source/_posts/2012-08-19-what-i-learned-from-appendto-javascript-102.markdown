---
layout: post
title: "What I Learned From AppendTo JavaScript 102"
date: 2012-08-19 08:37
comments: true
categories: [javascript] 
published: true
updated: 2012-12-19 23:54
---

Here are some of the things that I've learned on AppendTo Developer Learning Center on their JavaScript 102 course:

 * Block scope doesn't exist in javascript

 * Arguments in JavaScript are being passed by value. Pass by reference simply doesn't exist in JavaScript. 
 So for example if you have a function that will change the value of a variable:

```javascript 
 var str = "Im a string";
 function change_str(){
   str = str + " not a number";
 }
 
 change_str(str);
 console.log(str);
```

It won't work. There's only function scope in JavaScript.

 * Functions can be created in two ways. A function declaration:

```
 function funk(){
   console.log("Im being called from a function");
 }
``` 

  Or a function expression:

```
 var funk = function(){
   console.log("Im being called from a function");
 }
``` 

 * You can create objects within objects. In the example below we created another object called ```friends``` inside the object called ```obj```
 then we created 2 other objects inside the ```friends``` object and we call it ```onix``` and ```psyduck```

```
var obj = {
  name : "pikachu",
  trainer : "ash",
  skills : ["thundershock", "thunderbolt", "tail attack"],
  friends : {
    onix : {
      trainer : "brock",
      skills : ["rock throw", "tail whip"]
    },
    psyduck : {
      trainer : "misty",
      skills : ["confusion", "headbutt"]
    }
    
  }
}
``` 

 * You can iterate over objects using the ```for in``` loop. Here we have a simplified version of the object a moment ago:

```
var obj = {
  name : "pikachu",
  trainer : "ash",
  skills : ["thundershock", "thunderbolt", "tail attack"]
}
``` 

Were going to loop over it using the ```for in``` loop:

```
for(var x in obj){
  console.log(x + " : " + obj[x]);
}
```

The output will be something like this:

```
name : pikachu
trainer : ash
skills : thundershock,thunderbolt,tail attack
```

As you can see the ```x``` represents the current property that is being iterated in the object. So to access the value you just need to use ```x``` as the property that you
want to access.

 * An array can contain any data type, even mix data types within each array. Doing something like this is perfectly fine with JavaScript. This behavior is still
 due to the fact that JavaScript is a loosely typed language.

```
var r = [1, 2, true, "four", "five"]
``` 

 * You can access properties within objects using either the bracket or dot notation.

```
var obj = {
  name : "pikachu",
  trainer : "ash",
  skills : ["thundershock", "thunderbolt", "tail attack"]
}
``` 

Accessing the ```name``` property using dot notation:

```
 console.log(obj.name); //output: "pikachu"
```

Accessing the ```trainer``` property using bracket notation:

```
 console.log(obj["trainer"]); //output: "ash"
```

*Its important to note that you cannot access properties using dot notation everytime especially if you have to access properties which doesn't follow the variable naming conventions in JavaScript.
Here are a few of the variable names that isn't accepted by JavaScript. You will pretty much get an unexpected token error when you create variables that has these names:*

```
%name
#age
@course
^school
bin-go
```

 * Objects can also contain functions or methods:

```
var obj = {
  name : "pikachu",
  trainer : "ash",
  skills : ["thundershock", "thunderbolt", "tail attack"],
  attack : function(){
    console.log("Pikachuuu!!!!");
  }
}
```  

* Array is also an object. So for example if you have an array:

```
var r = [1, 2, 3];
```

You can actually add properties to it using the dot or bracket notation:

```
r['boom'] = 'doom';
```

But this won't actually add the item into the array:

```
console.log(r); //output: [1,2,3] 
```

But you can access it like how you normally access them in objects:

```
console.log(r['boom']); //output: doom
```

 * You can augment an object anytime you want. 

```
var obj = {
  name : "pikachu",
  trainer : "ash",
  skills : ["thundershock", "thunderbolt", "tail attack"],
  attack : function(){
    console.log("Pikachuuu!!!!");
  }
}
``` 
That means that we can change the values of each properties that already exists in the object or add new properties to it.

```
obj.evolution = "raichu"; //add a new property called evolution
obj.trainer = "Ash Ketchum"; //changing trainer from ash to Ash Ketchum
```

 * Don't use for in loop when iterating over the items in an array, use ```for loop``` instead since ```for in``` loop is used to iterate over the properties of an object. 
This means that if you have an array with a property assigned to it(which you won't probably have if you're writing a program for the real world) then it will also
be iterated over when using ```for in```. So for example if you have this array:

```
var r = [1, 2, 3]; 
``` 
Then you assigned a property to it:

```
r.log = function(){
  console.log("Im also an object");
}
```

Then don't loop through it using ```for in```:

```
for(var x in r){
  console.log(x + " : " + r[x])
}
```

Use ```for loop``` instead:

```
var len = r.length; //its good practice to put this outside the loop so JavaScript won't have to execute r.length everytime the loop executes.
for(var i=0; i < len; i++){
  console.log(r[i]);
}
```
