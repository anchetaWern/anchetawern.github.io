---
layout: post
title: "Learning Markdown"
date: 2012-08-13 18:00
comments: true
published: true
categories: [markdown]
---

Octopress uses markdown for its source files so its required for me to learn 
markdown if I want to blog using Octopress.

In this article I'm going to walk you through the syntax of Markdown(this will also serve as my guide later on when I start to forget things like an old man, though not all old man forgets things).
But before we get started let me discourage you a bit. Markdown is not as complete as html. Things like table doesn't exist in markdown(though there's probably no need for it if you're doing a tech blog).

####Headers
Headers are indicated by the number of pound signs that you use before the actual header text:

```
#This is equivalent to H1 in HTML
##This is H2 since there are 2 pound signs before the text
###You get the point now(this is H3)
```

####Paragraph
You write paragraphs in markdown just like you write them when writing a letter. Just separate paragraphs with whitespaces.

```
This is a paragraph

This is another paragraph
```

####Links
Links are also easy to write just place the descriptive text inside brackets and the link itself inside parenthesis.

```
[Google.com](http://google.com/)
```

If the link is the same with the descriptive text you can just do it this way:

```
<http://google.com/>
```

####Images
Images are also written like links. The one inside the brackets is the alt text. And the one inside the parenthesis is the link to the image itself.

```
![some_image](http://localhost/someimage.png)
```

####Lists
How you write ordered lists is just like how you write them in real world:

```
 1. Im item number 1
 2. Im item number 2
 3. Don't forget the spaces between the dot(.) and the item text
```

And this is how you write unordered lists:

```
 * You can use a plus sign(+), minus sign(-), or an asterisk(*) 
 * It still renders as bulleted list
  * But the bullet style changes as the list gets deeper
     * And you can do that by using whitespaces(1, 3, 4) 
```

####Conclusion
There are more things that you can do with markdown so checkout the resources below to learn more.

###Resources
 * [Daring Fireball -  Markdown](http://daringfireball.net/projects/markdown/)
 * [Markdown Cheat Sheet](http://warpedvisions.org/projects/markdown-cheat-sheet/)
 * [Markdown Editor](http://joncom.be/experiments/markdown-editor/edit/)


