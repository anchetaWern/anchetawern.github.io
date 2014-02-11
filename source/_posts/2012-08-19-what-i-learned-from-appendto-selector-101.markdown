---
layout: post
title: "What I Learned From AppendTo Selector 101"
date: 2012-08-19 18:15
comments: true
categories: [jquery, javascript]
updated: 2012-12-19 23:54
---

 * Every call of jQuery returns a jQuery object
 * Selectors:
 
```javascript
 $('#something'); //By ID
 
 $('.something'); //By Class
 
 $('input'); //By Element
 
 $('table td'); //Descendant Selector
 
 $('p > input'); //Direct Children
 
 $('p ~ input');  //Siblings
 
 $('p.someclass'); //Combined Selector
 
 $('input, select, textarea');  //Multiple Selections
```

{% jsfiddle DTURK %}


 * If possible use ```addClass()``` and ```removeClass()``` instead of ```css()``` method. Define specific styling on the css rather than JavaScript to separate application logic and markup. 

 * There is an implicit iteration in most of the jQuery methods which means that it automatically iterates through the elements that are matched by the specified selector. For example if we have this markup: 

```
<ul id='list'>
	<li>Ash</li>
	<li>Misty</li>
	<li>Brock</li>
</ul>
``` 

When we select the list items using jQuery its already understood that its going to select all of the li that is a descendant of the element with an id of ```list```.

```
$('#list li');
```

{% jsfiddle XxdEu %}


When comparing it to regular expressions, in regular expressions you have to set if its global or not, if its not global then the expression is only
going to select the first match. 

 * Every call to a jQuery method returns a jQuery object therefore the jQuery object holds a collection of element/s.
 
 * Chaining is only possible because every call to a jQuery method returns a jQuery object. A selector like ```$('input[type=button]')``` returns a jQuery object. 
 Calling ```addClass``` after the selector still returns a jQuery object so you can have as many chains as you want.
 
 * ```find()``` looks for the descendants of the specified selector. For example if we have this markup:
 
```
<div class="yoh">
   <p>this is a p</p>
   <ul>
		<li>abc</li>
		<li>def</li>
		<li>ghi</li>
   </ul>
   <div class="inner">
		I'm inner
   </div>
   <div class="inner">
		I'm also inner
   </div>
</div>
```

And we want to select all the ```li``` that is a descendant of the ```div``` with the class of ```yoh```

```
$('.yoh').find('li');
```

{% jsfiddle 9RkJV %}

In this case the ```div``` with the class of ```yoh``` is no longer the one that is selected. 
The one that is selected here is the ```li``` so if you call ```css``` on it.

```
$('.yoh').find('li').css('background-color','red');	
```

Each of the ```li``` will have a background color of red on it:

```
<div class="yoh">
   <p>this is a p</p>
   <ul>
		<li style="background-color: red; ">abc</li>
		<li style="background-color: red; ">def</li>
		<li style="background-color: red; ">ghi</li>
   </ul>
   <div class="inner">
		I'm inner
   </div>
   <div class="inner">
		I'm also inner
   </div>
</div>
```

{% jsfiddle Yerd3 %}


* ```children()``` selects the direct children of the specified selector. In the example below(were still using the same markup) were selecting the
children of the first(were zero indexed remember?) ```ul``` on the page:

```
$($('ul')[0]).children('li'); //alternative: $('ul:first')
```

{% jsfiddle vnsAC %}

We could also do it this way but that's going to select all of the ```ul``` with a children of ```li``` on the page:

```
$('ul li');
```

 * ```end()``` goes back to the original element being selected. The selector below selects all the ```li``` that is a descendant of the first ```ul```.
 
```
$($('ul')[0]).find('li'); //returns li
``` 

If we want to go back to the original selection we simply call ```end```. 

```
$($('ul')[0]).find('li').end(); //returns ul with all its descendants
```

This is specifically useful if you want to do something with a specific selection and then do something with its children.

{% jsfiddle tBZdu %}

 
 * ```delay()``` delays the execution of a function. For example you want to fade out some elements after 5 seconds(were speaking microseconds here so its 5000):
 
```
$('li').delay(5000).fadeOut();
```

{% jsfiddle LkFK8 %}

 * ```attr()``` and ```val()``` can act as a setter or getter depending on the number of parameters specified. For example if we have this markup:
```
<input type="text" id="iam_text" value="yoohoo" data-something="something"/>
``` 

and we want to get its value we don't need to specify any parameters:

```
$('#iam_text').val();
```

but if we want to set its value:

```
$('#iam_text').val('another value');
```


While ```attr()``` is slightly different since you have to specify at least one parameter if you are getting the value of a specific attribute.

```
$('#iam_text').attr('data-something');
```

It can also be:

```
$('#iam_text').data('something');
```

If you want to set the value of an attribute:

```
$('#iam_text').attr('id', 'iam_unique');
```

{% jsfiddle nVvB5 %}


 * ```attr()``` can also take in a map(collection of key value pairs) as its parameter.
 
```
var obj = {
   'data-anime': 'pokemon',
   'data-id': 11334
};

$('#iam_text').attr(obj);
``` 


{% jsfiddle ZkCgr %}

 * Instead of a selector you can pass html as a string to create elements.
 
```
$('body').html("<strong>awesome</strong>");
``` 

* You can also nest elements when creating new elements:
 
```
var html_string = "<ul><li>abc</li><li>def</li></ul>";
$('body').html(html_string);
```
 
 * ```appendTo()``` can be used to append a newly created element to an existing element.
```
var body = $('body');
$("<strong>yoh!</strong>").appendTo(body);
```
 
 * ```insertAfter()``` is just like ```appendTo``` the only difference is that you can specify where you want to
 insert the newly created element. Note that in the example below were still using the markup that we used in ```find()```.
 
```
$("<li>Im inserted after def</li>").insertAfter('ul:first li:eq(1)');
```

{% jsfiddle wVDTp %}

 * Its much less performant if you set attributes after appending a new element into the page. 
 
```
<form></form>

<script>
var obj = {
  type : 'text',
  value: 'something',
  id : 'nothing'
};

//don't do this:
$('<input>').appendTo('form').attr(obj);

//do this:
$('<input>').attr(obj).appendTo('form');
</script>
``` 

 * ```html()``` when used as a getter gets the first element from the set of matched elements while ```text()``` 
 uses implicit iteration and gets all the text of the matched elements and append them together. As you can see
in the example below(note: were still using the markup from ```find()```) ```html()``` only returns ```abc``` when in fact
it should be returning all the html/contents of the ```li``` in the first ```ul``` on the other hand ```text``` returns all
of the text inside each of the ```li``` on the first ```ul```.

```
$('ul:first li').html(); //returns: "abc"

$('ul:first li').text(); //returns: "abcdefIm inserted after defghi"
```

{% jsfiddle mpvAw %}


* ```html()``` when used as a setter uses implicit iteration which means that all the matched elements shall
have the html specified as a parameter. In the example below we replaced the html content inside each of the ```li``` on 
the first ```ul``` with the string ```yo``` in bold characters.

```
$('ul:first li').html('<strong>yo</strong>');
```

 * ```after()``` uses the select something then create something pattern while the ```insertAfter()``` uses the
create something then select something pattern. This means that ```insertAfter()``` takes in a selector
and ```after()``` takes in an element as its parameter.

```
$('ul:first li:first').after('<li>Another List Item</li>'); //select where to insert after then specify what to insert

$('<li>Yet another List Item</li>').insertAfter('ul:first li:first'); //specify what to insert then select where to insert
```

* ```remove()``` removes the element from the page(and all of its children if it has children), it still returns a jQuery object though so you can still
chain something after it or append the removed object somewhere else to recreate it. But ```remove()``` doesn't
keep the events, data attached to the element. Only use ```remove()``` when you're entirely sure that
you are not going to use the element later.

```
$('ul:first').remove(); //the first ul and its child is removed from the DOM
```

 * ```empty()``` empties the contents of the specified element but doesn't remove the selected element.

```
$('ul:first').empty(); //the descendants of this element is removed from the DOM
```

{% jsfiddle ShZVX %}

 
 * ```detach()``` is similar to ```remove()``` but when an element is detached any data or events that are attached 
to that element is actually kept so you can still reuse them later on when you append it to another element.. In the example below we
are detaching the first ```ul``` from the DOM and then inserting it again after the last ```ul```. 
```
$('ul:first').detach().insertAfter('ul:last');
```

{% jsfiddle 4zjxm %}

You can always using caching if you plan to insert them later. This is also a best practice as you don't have to make the same selections over again:

```
var first_ul = $('ul:first').detach().insertAfter('ul:last');
```
 
 * ```clone()``` clones the specified element children, data, events. Basically everything about it.

{% jsfiddle BPQ2D %} 
 
 * Tip: Utilize the jQuery documentation or the jQuery forum to find out the best way to do something in jQuery. The shortcut to remember when you're not sure what a specific jQuery function does is to access api.jquery.com/function_name. So if you want to know what the `hover` function does then you type in api.jquery.com/hover











 





 

