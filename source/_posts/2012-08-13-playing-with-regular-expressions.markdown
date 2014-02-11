---
layout: post
title: "Playing with Regular Expressions"
date: 2012-08-13 21:18
comments: true
categories: [regex]
published: true
---

Let's learn by examples this time. This kind of thing has already been done a couple of times by awesome people but I also want to do it so no amount of
duplication is going to make me stop doing this. It's my own version of an introduction to regular expressions after all. Be sure to checkout the resources.

 * ```g``` makes the match global, just add this character at the end of your pattern like this: ```/PATTERN/g```
 * ```\d``` matches all the digits
 * ```\D``` matches all non-digits this includes letters(both uppercase & lowercase), symbols, whitespaces
 * ```\s``` matches all whitespaces
 * ```\S``` matches all non-whitespace this letters(both uppercase & lowercase), symbols, numbers
 * ```()``` used for grouping
 * ```(a|b|c)``` matches every occurence a, b or c
 * ```(cat)``` matches every cat
 * ```[]``` character set. it's kind of the same with using the parenthesis but when using this you don't need the pipes(|) to separate what specific group of characters you want to match since everything inside the brackets is treated as a single entity
 * ```[\w]``` matches a single character of any word character
 * ```\w``` matches all words
 * ```{3}``` specific length
 * ```\d{2}``` matches every digit which has a length of 2
 * ```{1,3}``` range
 * ```\b``` boundary. You can use this to set boundaries. For example if you only want to select 3-digit numbers you might try doing this: ```\d{3}``` but this selects every digit which has a length of 3. So if you have 300500, it selects 300 and then 500 but what we want to select is only numbers which are 3-digit like 500, 100, 200, 450, etc.
 * ```\b\d{3}\b``` so you do something like this to specify a boundary that you only want numbers which are 3-digit independently so that 300500 won't be selected
 * ```\b[a-zA-z]{4}\b``` selects every 4 letter word(words without numbers on it) which independently exists			
 * ```\w{10}``` matches every word which has a length of 10
 * ```[a-zA-Z](a|e|o)y``` matches anything that begins with a letter(both uppercase and lowercase) which is immediately followed by an a,e or u then immediately followed by a y
 * ```+``` matches everything preceeding the string specified 
 * ```.``` matches every character(symbols, numbers, whitespaces, letters)
 * ```\.```  matches the dot symbol. You can pretty much apply this to every special character that is used in Regular Expressions such as ```$, ^, +``` for matching symbols.
 * ```\b[\w-]+@[A-Za-z]+\.[a-z]{2,4}\b```  matches an email. An email composes of a username, the @ sign, then the domain name(gmail,ymail), the . sign, then a 2-4 character extension(edu, ph, com)
 * ```\b[\w-]+@[A-Za-z]+\.[a-z]{2,4}+(\.[a-z]{2})?\b```  matches an email which has a country extension after the actual domain name extension(org, edu, com) like: abc@yahoo.com.jp for people from Japan


###Resources
 * [Introduction to Regular Expressions](http://codular.com/regex)
 * [You don't know anything about regular expressions](http://net.tutsplus.com/tutorials/javascript-ajax/you-dont-know-anything-about-regular-expressions/)
 * [8 regular expressions that you should know](http://net.tutsplus.com/tutorials/other/8-regular-expressions-you-should-know/)
 * [Regular Expressions Official Site](http://www.regular-expressions.info/)
 * [Regular Expressions for Dummies](http://net.tutsplus.com/tutorials/php/regular-expressions-for-dummies-screencast-series/)
 * [Regular Expressions Playground](http://gskinner.com/RegExr/) - you can play with Regular Expressions to your hearts content using this tool(available on both desktop and browser)
