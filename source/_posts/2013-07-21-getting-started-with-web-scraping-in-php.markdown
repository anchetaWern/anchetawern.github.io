---
layout: post
title: "Getting Started with Web Scraping in PHP"
date: 2013-08-07 17:22
comments: true
categories: [php, web-scraping]
published: true
updated: 2013-09-08
---


Have you ever wanted to get a specific data from another website but there's no API available for it?
That's where Web Scraping comes in, if the data is not made available by the website we can just scrape it from the website itself.

<!--More-->

But before we dive in let us first define what web scraping is. According to [Wikipedia](http://en.wikipedia.org/wiki/Web_scraping):

{% blockquote %}
Web scraping (web harvesting or web data extraction) is a computer software technique of extracting information from websites. Usually, such software programs simulate human exploration of the World Wide Web by either implementing low-level Hypertext Transfer Protocol (HTTP), or embedding a fully-fledged web browser, such as Internet Explorer or Mozilla Firefox.
{% endblockquote %}


So yes, web scraping lets us extract information from websites. 
But the thing is there are some legal issues regarding web scraping. 
Some consider it as an act of trespassing to the website where you are scraping the data from.
That's why it is wise to read the terms of service of the specific website that you want to scrape because you might be doing something illegal without knowing it.
You can read more about it in this [Wikipedia page](http://en.wikipedia.org/wiki/Web_scraping).


##Web Scraping Techniques

There are many techniques in web scraping as mentioned in the Wikipedia page earlier. 
But I will only discuss the following:

- Document Parsing
- Regular Expressions


###Document Parsing

Document parsing is the process of converting HTML into DOM (Document Object Model) in which we can traverse through.
Here's an example on how we can scrape data from a public website:

```php
<?php
$html = file_get_contents('http://pokemondb.net/evolution'); //get the html returned from the following url

$pokemon_doc = new DOMDocument();

libxml_use_internal_errors(TRUE); //disable libxml errors

if(!empty($html)){ //if any html is actually returned

	$pokemon_doc->loadHTML($html);
	libxml_clear_errors(); //remove errors for yucky html
	
	$pokemon_xpath = new DOMXPath($pokemon_doc);

	//get all the h2's with an id
	$pokemon_row = $pokemon_xpath->query('//h2[@id]');

	if($pokemon_row->length > 0){
		foreach($pokemon_row as $row){
			echo $row->nodeValue . "<br/>";
		}
	}
}
?>
```

What we did with the code above was to get the html returned from the url of the website that we want to scrape. 
In this case the website is [pokemondb.net](http://pokemondb.net).

```
<?php
$html = file_get_contents('http://pokemondb.net/evolution'); 
?>
```

Then we declare a new DOM Document, this is used for converting the html string returned from `file_get_contents` into an actual Document Object Model which we can traverse through:

```
<?php
$pokemon_doc = new DOMDocument();
?>
```

Then we disable libxml errors so that they won't be outputted on the screen, instead they will be buffered and stored:

```
<?php
libxml_use_internal_errors(TRUE); //disable libxml errors
?>
```

Next we check if there's an actual html that has been returned:

```
<?php
if(!empty($html)){ //if any html is actually returned
}
?>
```

Next we use the `loadHTML()` function from the new instance of `DOMDocument` that we created earlier to load the html that was returned. Simply use the html that was returned as the argument:

```
<?php
$pokemon_doc->loadHTML($html);
?>
```

Then we clear the errors if any. Most of the time yucky html causes these errors. Examples of yucky html are inline styling (style attributes embedded in elements), invalid attributes and invalid elements. Elements and attributes are considered invalid if they are not part of the HTML specification for the doctype used in the specific page.

```
<?php
libxml_clear_errors(); //remove errors for yucky html
?>
```

Next we declare a new instance of `DOMXpath`. This allows us to do some queries with the DOM Document that we created.
This requires an instance of the DOM Document as its argument.

```
<?php
$pokemon_xpath = new DOMXPath($pokemon_doc);
?>
```

Finally, we simply write the query for the specific elements that we want to get. If you have used [jQuery](http://jquery.com/) before then this process is similar to what you do when you select elements from the DOM.
What were selecting here is all the h2 tags which has an id, we make the location of the h2 unspecific by using double slashes `//` right before the element that we want to select. The value of the id also doesn't matter as long as there's an id then it will get selected. The `nodeValue` attribute contains the text inside the h2 that was selected.

```
<?php
//get all the h2's with an id
$pokemon_row = $pokemon_xpath->query('//h2[@id]');

if($pokemon_row->length > 0){
	foreach($pokemon_row as $row){
		echo $row->nodeValue . "<br/>";
	}
}
?>
```

This results to the following text printed out in the screen:

```
Generation 1 - Red, Blue, Yellow
Generation 2 - Gold, Silver, Crystal
Generation 3 - Ruby, Sapphire, Emerald
Generation 4 - Diamond, Pearl, Platinum
Generation 5 - Black, White, Black 2, White 2
```

Let's do one more example with the document parsing before we move on to regular expressions.
This time were going to get a list of all pokemons along with their specific type (E.g Fire, Grass, Water).

First let's examine what we have on pokemondb.net/evolution so that we know what particular element to query.

![checking](/images/posts/getting_started_with_web_scraping/check.png)

As you can see from the screenshot, the information that we want to get is contained within a span element with a class of `infocard-tall `. Yes, the space there is included. When using XPath to query spaces are included if they are present, otherwise it wouldn't work.

Converting what we know into actual query, we come up with this:

```
//span[@class="infocard-tall "]
```

This selects all the span elements which has a class of `infocard-tall `. It doesn't matter where in the document the span is because we used the double forward slash before the actual element.

Once were inside the span we have to get to the actual elements which directly contains the data that we want. And that is the name and the type of the pokemon. As you can see from the screenshot below the name of the pokemon is directly contained within an `anchor` element with a class of `ent-name`. And the types are stored within a `small` element with a class of `aside`.

![info card](/images/posts/getting_started_with_web_scraping/info-card.png)

We can then use that knowledge to come up with the following code:

```
<?php
$pokemon_list = array();

$pokemon_and_type = $pokemon_xpath->query('//span[@class="infocard-tall "]');

if($pokemon_and_type->length > 0){	
	
	//loop through all the pokemons
	foreach($pokemon_and_type as $pat){
		
		//get the name of the pokemon
		$name = $pokemon_xpath->query('a[@class="ent-name"]', $pat)->item(0)->nodeValue;
		
		$pkmn_types = array(); //reset $pkmn_types for each pokemon
		$types = $pokemon_xpath->query('small[@class="aside"]/a', $pat);

		//loop through all the types and store them in the $pkmn_types array
		foreach($types as $type){
			$pkmn_types[] = $type->nodeValue; //the pokemon type
		}

		//store the data in the $pokemon_list array
		$pokemon_list[] = array('name' => $name, 'types' => $pkmn_types);
		
	}
}

//output what we have
echo "<pre>";
print_r($pokemon_list);
echo "</pre>";
?>
```

There's nothing new with the code that we have above except for using query inside the `foreach` loop.
We use this particular line of code to get the name of the pokemon, you might notice that we specified a second argument when we used the `query` method. The second argument is the current row, we use it to specify the scope of the query. This means that were limiting the scope of the query to that of the current row.

```
<?php
$name = $pokemon_xpath->query('a[@class="ent-name"]', $pat)->item(0)->nodeValue;
?>
```


The results would be something like this:

```
Array
(
    [0] => Array
        (
            [name] => Bulbasaur
            [types] => Array
                (
                    [0] => Grass
                    [1] => Poison
                )
        )
    [1] => Array
        (
            [name] => Ivysaur
            [types] => Array
                (
                    [0] => Grass
                    [1] => Poison
                )
        )
    [2] => Array
        (
            [name] => Venusaur
            [types] => Array
                (
                    [0] => Grass
                    [1] => Poison
                )
        )
```


###Regular Expressions

Aside from document parsing we can also use regular expressions to scrape the data that we want from a specific webpage.
Regular expressions are useful if we only want to scrape actual content and not HTML elements because its difficult if not impossible to match all the possibilities of how an HTML element might have been written.
Consider the following example:

```
<link rel="stylesheet" href="style.css">
<link href="style.css" rel="stylesheet">
<link href="style.css" rel="stylesheet" />
<link href="style.css" rel="stylesheet"/>
<link rel="stylesheet" href="style.css" type="text/css">
<link type="text/css" rel="stylesheet" href="style.css">
<link type="text/css" href="style.css" rel="stylesheet">
<link type="text/css" href="style.css" rel="stylesheet" />
<link type="text/css" href="style.css" rel="stylesheet"/>
```

The code above is basically the same thing written in a bunch of ways. It would be difficult to scrape all the external stylesheets in a page using regular expressions as we would need to target every possible way that it can be written. So instead of using regular expressions we use document parsing to get all the external stylesheets. This is just one of the many cases in which regular expressions can't be used in scraping.

The main advantage of using regular expressions is its speed. The whole process of converting an HTML document into DOM and then traversing the DOM takes time especially if there are lots of elements which matches the query that you specify.
This is not the case with regular expressions as you're only working with strings and patterns with it, no conversion and traversing takes place so its very fast.

Ok enough with the explanations, here's an example on how to use regular expressions in scraping. 
Here we are specifically looking for URL's which begins with `https://safelinking.net/` and followed by any instances of letters from A to Z and its lowercase version or any instances of numbers. Remember that we need to escape forward slashes and periods using a backslash. We then use the `preg_match_all()` function to get all the matches of the specific pattern that were looking for. The `preg_match_all()` function takes the pattern as its first argument, then the actual string where we want to find the pattern as its second argument, then the third argument would be the variable that will store the actual matches.

```
<?php
$pokemon_episodes_html = file_get_contents('http://www.animekens.com/2013/04/pokemon-episode-1-82-season-1-480p60mb.html');
$pattern = '/https:\/\/safelinking\.net\/d\/[A-Za-z0-9]*/';
preg_match_all($pattern, $pokemon_episodes_html, $matches); 
?>
<pre>
	<?php print_r($matches); ?>
</pre>
```

The code above will output the following:

```
Array
(
    [0] => Array
        (
            [0] => https://safelinking.net/d/81b681a76a
            [1] => https://safelinking.net/d/04138fdd24
            [2] => https://safelinking.net/d/7378613026
```


##Web Scraping Tools

You can also use some web scraping tools to make your life easier. Here are some of the PHP libraries that you can use for scraping.


###Simple HTML Dom

To make web scraping easier you can use libraries such as [simple html DOM](http://simplehtmldom.sourceforge.net/).
Here's an example of getting the names of the pokemon using simple html DOM:

```
<?php
require_once 'libs/simple_html_dom.php';
$html = file_get_html('http://pokemondb.net/evolution');

foreach($html->find('a[class=ent-name]') as $element){
	echo $element->innertext . '<br>'; //outputs bulbasaur, ivysaur, etc...
} 
?>
```

The syntax is more simple so the code that you have to write is lesser plus there are also some convenience functions and attributes which you can use. An example is the plaintext attribute which extracts all the text from a web page:

```
<?php
echo file_get_html('http://pokemondb.net/evolution')->plaintext; 
?>
```

###Ganon

You can also use [ganon](https://code.google.com/p/ganon/) for web scraping which packs features such as support for html5, jQuery like syntax, manipulation of elements and their attributes.


Here's an example on how to use ganon to get all the images that are in a table element:

```
<?php
require_once 'libs/ganon.php';
$html = file_get_dom($url);
if(!empty($html)){
	$elements = $html('table img');

	foreach($elements as $element){
		echo $element->src . "<br/>"; //output the image source
	}
}
?>
```

##Conclusion

That's it for this tutorial! You have learned the basics of web scraping in PHP. 
You can take your adventures to the next level by scraping non-public parts of websites or scraping content that is dynamically generated. 


##Resources

- [I don't need no stinking API: Web Scraping for fun and profit](http://blog.hartleybrody.com/web-scraping/)
- [Web scraping is actually pretty easy](http://blog.webspecies.co.uk/2011-07-27/web-scrapping-is-actually-pretty-easy.html)
- [Web scraping or API](https://news.ycombinator.com/item?id=4893922)
- [Curl](http://curl.haxx.se/)
- [Simple HTML Dom](http://simplehtmldom.sourceforge.net/)
- [Ganon](https://code.google.com/p/ganon/)