---
layout: post
title: "What I Learned From AppendTo JavaScript 103"
date: 2012-08-19 11:48
comments: true
categories: [javascript]
published: true
updated: 2012-12-19 23:54
---

 * Functions are special type of objects which can be invoked.
 * You can specify the context that will be used by an object using the ```apply``` method.
 * The main difference between ```call``` and ```apply``` is that ```call``` can accept any number of parameters separated by comma
 while ```apply``` only accepts 2 parameters: first is the function context and the second is an array of parameters to be used by the function
 you are calling the ```apply``` from.
 * You can use objects as parameter to functions. In the example below we define a function which iterates over an object using the ```for in``` loop.
First let's define the object:

```javascript
var obj = {
  name : "ash",
  bestfriend : "pikachu"
};
```

Then define the function. 
This takes up a single object as its parameter and it simply iterates over its properties using the ```for in``` loop.

```
function funk_obj(obj){
  for(var x in obj){
    console.log(x + " : " + obj[x]); //print the current property + its value
  }
}
```

Invoking the function:

```
funk_obj(obj);
/*
output:
name : ash
bestfriend : pikachu
*/
```
 
 * You can use a function as parameter to functions(did I just confused you? sorry about that). 
First let's define the object(its basically the same object that we used a moment ago, coz I freaking love pokemon).

```
var obj = {
  name : "ash",
  bestfriend : "pikachu"
};
```

And define the function. 

```
var funky = function(obj, funk){
   for(var x in obj){
     funk.call(obj[x], x); //set the context to the current property iterated over, the second parameter is the index.
   }
}
``` 

Then we call it and specifying the object ```obj``` as the first parameter and an anonymous function as the second parameter. This
function will be called inside the for in loop in the function definition earlier. The context used by the anonymous function 
is now the object ```obj``` the second parameter in the ```funk.call``` earlier is actually represented by the ```index``` parameter in our
anonymous function(it's really confusing, better read up some more stuff about this if my explanation didn't make any sense).

```
funky(obj, function(index){
  console.log(index + " : " +obj[index]);
})
```

 * ```arguments``` object can be used to access the value of an argument in a specific index. ```arguments``` contains
 all the arguments passed in from the invoker. 
You can access the arguments using the index, the first argument passed in when the function is invoked will be at index 0 and so on.

```
function args(){
  console.log(arguments[0] + " " + arguments[1]); 
}
``` 

Invoking it:

```
args("happy", "birthday"); //output: "happy birthday"
```
 
 * You can pass any number of parameters when executing a function. What I mean by that the number of arguments that you pass in 
when invoking a function doesn't necessarily have to match the number of parameters that you have specified when you defined your function. 
In the example below we didn't define the parameters that will be taken by the ```args_taker()``` function.

```
function args_taker(){
  for(var x = 0; len = arguments.length, x <= len ; x++){
    console.log(arguments[x]);
  }
}
``` 

But once we invoke it we pass in 5 arguments:

```
args_taker("pikachu", "squirtle", "bulbasaur", "blastoise", "charizard");
/*
output:
 pikachu
 squirtle
 bulbasaur
 blastoise
 charizard
*/
```

 * You can declare a function inline as a parameter to a certain function. You've already seen this earlier when we called the ```funky()``` function
 and passed in an anonymous function as its second parameter.

```
funky(obj, function(index){
  console.log(index + " : " +obj[index]);
})
``` 

 * Default object is the ```DOMWindow object``` or ```[object Window]```. Try typing ```this``` on chrome console if you don't believe me.
 * A function called directly without an explicit owner object causes the value of ```this``` to be the default object. We can prove that by
 creating a function which prints the value of ```this``` into the console. The result will be the ```Window object```.
 
```
function x(){
  console.log(this);
}

x(); //output: Window object
```

 * Only the owner object can determine the value of ```this```
 
 


