---
layout: post
title: "What I learned From AppendTo on jQuery Methods and Events"
date: 2012-08-21 21:07
comments: true
categories: [jquery, javascript]
updated: 2013-04-20 14:58 
---

 * You can specify an anonymous function as parameter to ```text``` method.
 
 {% jsfiddle SMVQA %}
 
 * When calling named functions inside ```each``` you don't need the ```()``` 
 
 {% jsfiddle YcrU8 %}
 
 * ```bind``` can be used to bind multiple events to a selection
 
 {% jsfiddle a3ybw %}
 
 
 * ```toggleClass``` can be used to force the adding or removing of class.
 
 {% jsfiddle zxadp %}
 
 
 * ```unbind``` to unbind events from specific elements
 
 {% jsfiddle wXDVC %}
 
 * ```one``` executes the function only once
 
 {% jsfiddle x4Qj4 %}
 
 * ```event.preventDefault()``` prevents the default behavior of an element from occuring. For example, links automatically brings you to the page that is linked. If you call this right after the click event of an anchor tag then the default behavior won't occur, ```event.stopImmediatePropagation()``` prevents the rest of the events from being executed and prevents it from bubbling up the DOM tree, ```event.stopPropagation()``` prevents the parent elements from catching the events binded to a child element. You might have noticed that when you just binded an event to a child element the event is also triggered by their parents. ```event.stopPropagation()``` prevents this from happening.
 
 
 * namespacing events ```event.namespace``` this is used to separate other from each other. This is a nice way to organize
 code.
 
 
 * You can actually specify a ```title``` attribute to a label or any element to act as a tooltip.
 
 
