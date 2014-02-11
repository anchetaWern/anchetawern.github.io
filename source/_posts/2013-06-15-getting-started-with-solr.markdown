---
layout: post
title: "Getting Started with Apache Solr"
date: 2013-06-15 12:35
comments: true
categories: [solr, search-server]
published: true
---

In this tutorial we'll be looking at Apache Solr. 
Apache Solr is a search server. Its features include blazing fast searches, faceted search, handling of files such as PDF and Word.


<!--More-->


##Installing Solr

If you're on Windows you can install Solr by getting the installer from [BitNami](http://bitnami.com/stacks).
Just search for Solr, download the installer and install it on your machine.


##Solr Manager

After the installation is complete you can now access the Solr Manager where you can Start, Stop or Restart the server.
If its not started yet click on the start button.

![solr manager](/images/posts/getting_started_with_solr/solr_manager.PNG)


##Solr Admin

To test if Solr is working, access the Solr admin page from your browser. For me its at:

```
http://localhost:8080/solr/#/
```

The port depends on what port you have selected when you installed Solr.
If you're using Virtual hosts you can also access the Solr admin page using it:

```
http://my.dev:8080/solr
```

The Solr admin page currently looks like this. I'm running version 4.3.0. It might look a little bit different if you have installed a different version:

![solr admin](/images/posts/getting_started_with_solr/solr_admin.PNG)

There's not really much that you can do with the Solr admin page. 
The only parts that you might want to look at is the Logging and Core Selector.

The logging is where you can find warnings and errors with regards to the whole runtime of the Server.
The core selector is where you can select the collection that you want to manage.
Upon installation Solr already creates a default collection called `collection1`. 
Any documents that you add will be automatically added to this collection.
That said, you can think of collections as drawers in which you store your documents. 
In database terms they are like your database and the documents that you store on it are like the tables in a database.
Throughout this tutorial we'll only be working with the `collection1` collection.


###Overview

Once you have selected a collection you can see an overview of it by clicking on the overview tab:

![collection overview](/images/posts/getting_started_with_solr/overview.PNG)

Information like the date the collection was last modified, number of documents, maximum number of documents, deleted documents can be seen from this page.


###Query

The query tab is where you can play with some queries to manipulate the current collection. The default query is the select query which simply returns results which matches your query.
There's also the update query which is mainly used to update the contents of documents.

{% blockquote %}
Note that when using the select query in Solr you don't usually specify the document in which the results that you're looking for is stored. Solr simply knows where to find what you're looking for without telling it where to find something.
{% endblockquote %}

To use the query builder you simply need to specify what you're looking for.

![query json](/images/posts/getting_started_with_solr/query_json.PNG)

Here are some of the parameters that you can specify:

- **request handler** - the action that you want Solr to do. The most common ones are `select` and `update`. 
You can also create your own request handlers but that would be best discuss on another article.
- **q** - your query. Its common format is:

```
field name:"query"
```

So imagine we have added a document into Solr which composed of book names and their authors. If you want to get all the books whose title begins with the word 'national' then here's what your query would look like:

```
q=book_title:"national*"
```

- **fq** - short for filter query. If you want to filter the results returned by your query you can make use of this parameter. For example, if you want to select only the books which has a price within the range of 19 to 90 you do something like this:

```
fq=price:[19 TO 90]
```

- **sort** - sort is how you would like the results to be sorted. So if you want to sort the results by price in ascending order, that is books with lower price comes first and books with higher prices comes later. You do something like this:

```
sort=price asc
```

- **fl** - short for fields. This is the parameter where you can specify the fields that you want to return. So for example if you only want to return the book title and the price of the book you do something like:

```
fl=book_title,price
```

- **wt** - short for writer type, but that doesn't make any sense so we'll go by the name response type. This allows you to specify the way the results will be formatted. In solr you can have one of the following:

	- json
	- xml
	- php
	- ruby
	- python
	- csv

The default one used by Solr is `xml`. But the most commonly used is `json` since you can simply convert it to a data readable by php, ruby, python, javascript or probably any language that you can think of.


###Schema

The schema tab is where the `schema.xml` file can be previewed in a nicely formatted way (with all the syntax highlighting goodness). The `schema.xml` file simply describes the fields for each collection. If you have worked with MySql database for a while this is like the `information_schema` database which shows you all the information you want to know about each of the databases, tables and fields in MySql.
But for the `schema.xml` file it only contains information about a specific collection. So each collection have its own `schema.xml` file. The `schema.xml` file is stored in the following directory for `collection1`:

```
C:\BitNami\solr-4.3.0-0\apache-solr\solr\collection1\schema.xml
```

The `schema.xml` file contains a lot of information regarding the data stored in a collection. You can add new fields and field types into this file so that Solr will know what type of data the specific documents will store.
Fields in Solr comes in 2 forms:

- **Fields** - allows you to specify field names that will directly match what field names you include in the documents that you want to add to Solr. Here's how to define a field that will store book titles:

```xml
<field name="book_title" type="string" indexed="true"  stored="true"  multiValued="false" />
```

Fields commonly has 5 attributes which you can specify:

- **name** - the name that you want to give to the field. This would be the same as the naming conventions for every database system or programming language that you can think of. So numbers and symbols can't be used as the start of a field name. Only alphanumeric characters and underscores are allowed for the field name.

- **type** - the type of data that the field will store. Common data types are: `float`, `long`, `short`, `double`, `string`, `date` and `text`.

- **indexed** - can either have a value of `true` or `false`. If you do not want the specific field to be searched you can use `false`. Using `false` simply means that using the specific field in a query won't return anything since it can't be searched on.

- **stored** - can either have a value of `true` or `false`. Use `false` if you do not want the field to be retrievable. 

- **multivalued** - can either have a value of `true` or `false`. You use `true` if the field contains more than one value. For example a tag for a specific blog post. A blog post can have many tags so the tag field should have its `multivalued` attribute set to `true`.

- **Dynamic Fields** - allows you to specify a common data type, indexed, and stored value for fields which has a specific suffix. Here's how to define a dynamic field for fields which has integer and string data types:

```
<dynamicField name="*_i"  type="int"    indexed="true"  stored="true" />
<dynamicField name="*_s"  type="string"  indexed="true"  stored="true" />
```

You can also add copy fields which are used for copying one document to another when a document is added in the Solr index. It can be used to index the same field in a different way or adding multiple fields to the same field for faster indexing. Copy fields has 2 attributes, the `source` and the `destination`. The `source` is the field which you want to add a copy field to. And the destination can either have a value of a data type or an existing field.

Here's how to add a copy field into the `book_title` field to store a copy of the field with a data type of text:

```
<field name="book_title" type="string" indexed="true"  stored="true"  multiValued="false" />
<copyField source="book_title" dest="text"/>
```

Dynamic fields can also be used as the value for destination. So for example you have a field called `author` which has a data type of `text_general`. You add a copy field to it using the dynamic field which has a suffix of `_s`. So the value for destination would be the name of the field plus the suffix used in the dynamic field. The copy field would now be stored as a string since it will simply inherit the data type of the dynamic field:

```
<field name="author" type="text_general" indexed="true" stored="true" />
<dynamicField name="*_s"  type="string"  indexed="true"  stored="true" />
<copyField source="author" dest="author_s" />
```


##Adding Documents

By default Solr doesn't have any documents that you can work on. You'll have to manually add them. 
There are 2 ways in which you can add documents. Either by using `post.sh` or `curl`. 

There are some sample documents stored in the following directory in Windows once you install Solr:

```
C:\BitNami\solr-4.3.0-0\apache-solr\exampledocs
```

Examine each of those files to see what's common with them. Solr expects a specific format in which the documents will be. For xml files it should adhere with this format:

```
<add>
	<doc>
		<field name="id">123</field>
		<field name="book_title">Don't Make me think</field>
		<field name="price">39</field>
	</doc>
	<doc>
		...
	</doc>
	<doc>
		...
	</doc>
</add>
```

You can see from the markup above that you have to use `add` tags as a wrapper. This will tell Solr that the documents inside of it will be added to the index.
And each row in that document will be wrapped in `doc` tags. Each field will be wrapped in `field` tags.
Each field will have an attribute called `name` in which you specify the name of the field in which the value specified belongs.

{% blockquote %}
Note that documents has a required field called id. Your document won't be indexed by Solr if it doesn't have an `id` field. This uniquely identifies the row. If you have examined the sample documents you will see that each of them has an id field. Also note that the fields that you used in the documents that you want to add to Solr has fields which are already added to the schema.xml file otherwise the document won't be added.
{% endblockquote %}

To add those documents into the Solr index open the command line and navigate to the directory where the documents are stored:

```
cd c:\BitNami\solr-4.3.0-0\apache-solr\exampledocs
```

Then run the following command to add all of the xml documents to the Solr index:

```
post.sh *.xml
```

If you want to add a specific xml file:

```
post.sh books.xml
```

{% blockquote %}
Note that only xml documents can be added using post.sh. You can try using the curl method if you want to add a json document or any other type of document to the solr index.
{% endblockquote %}

If you don't see any sort of errors once the command finished executing then you're good to go. 
If not then you might need to add the fields used in each of those documents in the `schema.xml` file which you can find in the following directory if you're on Windows:

```
C:\BitNami\solr-4.3.0-0\apache-solr\solr\collection1\conf
```

To add a field you simply add a line like this in your `schema.xml` file:

```
<field name="book_title" type="string" indexed="true"  stored="true"  multiValued="false" />
```

This will tell Solr that the `book_title` field can be used in any of the documents that you will add to the Solr index. 

{% blockquote %}
Note that you have to stop the Solr service from running when you're editing the schema.xml file.
Once you're done with the changes you can simply start the service again so that the changes that you have in the schema.xml file will be reflected to the current instance of the service. 
{% endblockquote %}


##Manipulating the Data

You can access the data from Solr server by going to the browser and visiting the following address:

```
http://localhost:8080/solr/select?q=*:*
```

The host will normally be `localhost` if you're using Solr on your machine. The port depends on the port that you selected when you installed Solr. I've already discussed earlier how you can query the Solr server. So what I'll discuss in this section is how to access and manipulate the data coming from Solr using PHP and JavaScript.


###Getting Data using JavaScript

You can use an ajax request to request for the data from the Solr server. The easiest way to perform an ajax request is by using the jQuery library. In the example below were specifying the value for the request url to be the same as the url that were using to access the data directly from the browser. Were also specifying the type as `GET`, this means that we will perform a `GET` request to the server. The value used for the `dataType` is `jsonp` since the Solr server is running on a different port from the apache server on the local machine. 

```javascript
$.ajax({
	url: 'http://localhost:8080/solr/select?q=*:*',
	type: 'GET',
	dataType: 'jsonp',
	success: function(response){
		//do some magic with the data
	}
});
```


###Getting Data using PHP

You can get the data using PHP by using the `file_get_contents` method. Then you can convert the json string returned using the `json_decode` method. After that you can just loop through the data like a normal PHP array.

```php
<?php
$url = 'http://localhost:8080/solr/select?q=*:*';
$contents = file_get_contents($url);
$data = json_decode($contents, true);
?>
```

###Updating the Data using PHP

You can update the data in Solr by updating the contents of the document that you want to update and then re-indexing it again using the `post.sh` utility. But you can also update the documents using PHP.

First get the data that you want to update:

```php
<?php
$url = 'http://localhost:8080/solr/select?q=*:*';
$contents = file_get_contents($url);
$data = json_decode($contents, true);
$docs = $data['response']['docs'];
?>
```

Next do the updates. In the example below were adding a new field called course into the document. We also have to unset the version since Solr will be the one to update this attribute. Then we simply copy the current row into the `$new_docs` variable:

```
<?php
$new_docs = array();
foreach($docs as $d){
	$id = $d['id'];
	$course = get_course($id);
	$d['course'] = $course;
	unset($d['_version_']);

	$new_docs[] = $d;
}
?>
```

Then we use `curl` to update the document in Solr. Solr allows you to update documents using the `update` path and the format in which the data passed is formatted. In this case its in json format.

```
<?php
$json_doc = json_encode($new_docs); //convert the array to a json string

$curl = curl_init();

curl_setopt_array($curl, array(
    CURLOPT_RETURNTRANSFER => 1, //curl will return something instead of directly outputting
    CURLOPT_HTTPHEADER => array("Content-type:application/json"), //specify content type as json
    CURLOPT_URL => 'http://localhost:8080/solr/update/json', //the request url
    CURLOPT_POST => 1, //set the request type to POST
    CURLOPT_POSTFIELDS => $json_doc, //the data that we want to pass in
));

curl_exec($curl); //execute, you can assign a variable to this to check if the request suceeded or not
curl_close($curl);
?>
```

The data has already been updated but it hasn't been committed yet. So we have to make a separate request to commit the recent changes. That is by using the parameter `commit` and specifying its value as `true`.

```
<?php
//commit the changes
$curl = curl_init();
curl_setopt_array($curl, array(
	CURLOPT_URL => 'http://localhost:8080/solr/update?commit=true'
));

curl_exec($curl);
?>
```

Once you check the results returned from the browser you'll see that the data has already been updated.

```
http://localhost:8080/solr/select?q=*:*
```

##Conclusion

That's it! We have only scratched the surface in this introduction to Solr. 
Be sure to check out the resources below if you want to learn more about Solr.


##Resources

- [BitNami](http://bitnami.com/stacks)
- [SolrWiki](http://wiki.apache.org/solr/FrontPage)
- [SolrTutorial](http://www.solrtutorial.com/)

