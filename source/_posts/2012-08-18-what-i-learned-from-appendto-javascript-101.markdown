---
layout: post
title: "What I learned from AppendTo JavaScript 101"
date: 2012-08-18 22:23
comments: true
categories: [javascript]
published: true
updated: 2012-12-19 23:54
---

I started learning JavaScript at appendTo developer learning center and found out things
about JavaScript that I didn't know before. Here are some of those:

 * Automatic type coercion - concatenating a string and a number doesn't result in an error, the type of the other variable
 is converted to the type of the other. Here's an example:
 
```javascript
console.log(25 + "yoyos"); 
//output: "25yoyos" 
```
 
 If for example the result of an operator is not a number then we get ```NaN```.
 
```
"hello" - "world"; //output: NaN
```
 
 * There's only one number data type in JavaScript which means that ```52``` and ```52.0``` are the same.
 * JavaScript is loosely typed which means that a variable can represent any data type at a given time. Here's an example:
 
```
var x = 2; //number
x = true; //boolean
x = "Im a string"; //string
```

 In the example above we changed the type of the variable ```x``` from number, to boolean and finally to a string. This is perfectly fine in 
 JavaScript unlike in other languages where you have to explicitly specify the type and you will have to stick with that while the program executes.
 
 * There are 7 falsy values:
 
```
0
-0
null
undefined
false
NaN
""
```

{% jsfiddle GvmNW %}
 
 * Force conversion from a specific type to boolean. This will most likely be used in determinining whether a variable contains a truthy or falsy value.
 
```
!!5; //output: true;
!!undefined; //output: false;
```
 
 * ```typeof``` operator allows you to determine the type currently represented by a variable. Here's an example:
 
``` 
typeof "Im a string"; //output: "string" 
typeof 2; //output: "number"
typeof 2.2 //output: "number" - like I said earlier there's only one number type in JavaScript
typeof null //output: "object" - yes JavaScript is pretty nasty sometimes
typeof NaN //output: "number" - Not a Number has a type of Number, pretty cool
typeof undefined //output: "undefined" - pretty reasonable I guess?
```
