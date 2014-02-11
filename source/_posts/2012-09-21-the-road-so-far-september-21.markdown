---
layout: post
title: "The road so far.. (September 21, 2012 Edition)"
date: 2012-09-21 11:04
comments: true
categories: [adventures, web-development]
published: true 
---

I'm a big fan of the Supernatural series so the Supernatural fans out there 
might have noticed that the title of this post came from the usual
tagline on the last episode of each Supernatural season.
This post is not any different from that idea, as I will talk about some of
my adventures in Web Development from the time I've taken it seriously up to this day.

My adventures probably started during my first year in College as I took up Information Technology.
It was around this time that I developed my interest with computers and technology.
As IT students we had classes such as Computer Fundamentals, Internet, Computer Programming, 
Data Structures, Hardware and Software, Database Design, Web Development and a bunch others which isn't really relevant
to the path that were going to take later on.

During my first year in College we mostly worked with C++, HTML and a bit of CSS. 
We built simple programs that emulates bank transaction, sorting, and other things which probably looked really 
cool to my eyes back then.
We also built web pages using tables, Frames and probably a pinch of inline css.

Second year college was about VB.Net, databases, and assembly language which I really hate because of lack of resources in the internet.
But I probably didn't have much of a Googling super powers back then so I can't find the things that I wanted.
It felt awesome building applications that run on my Windows machine. 
I got my hands dirty on Text Files, MS Access, MS Sql and MySQL while working with VB.Net.
I also built some sort of a super combination of VB.Net and PHP. 
But it wasn't really a super combination since I was only rendering things on my localhost just like a browser does.
And VB.Net used the same engine that the IE installed on my computer was using(It was probably IE 6) so it kinda suck.
The story behind that is that I didn't know how to make a login system with PHP back then as I was only starting to get
my hands dirty on that language so I kinda used VB.Net for the login and PHP for the main system.
But it was a really fun experience I dive right into connecting PHP to MySQL without learning the basics first so it took some time before it finally clicked.

It was also during that time that we started writing queries and normalizing databases (1NF, 2NF, 3NF...).
We also did some assembly language on our Operating System course but it really didn't made much impact 
since it was really boring and was only running on the command line.

Third year college was about Web Development and Software Engineering (things are getting a lot more fun).
I learned more about HTML, CSS, JavaScript and PHP. 
It was also my first encounter with the JavaScript library called jQuery which made my life easier.
We built a Cart System on our Web Development, it really took a lot of Googling as I had no idea how to build one.
But you're not really doing things the right way if you're effortlessly doing it so I really gained some experience by building that Cart System.

On our Software Engineering class we built a Point of Sale System using PHP. 
It had purchasing, selling, maintenance and reporting features. 

Fourth year college was about Practicum and Capstone Project.
The project for our Practicum and Capstone was the same as it was a semi-huge system with 3 modules(Business Permits, Tax Collection, Administration).
I had 3 team mates who worked with me on the Project which was the Business Permit and Licensing System which we created for a Local Government Unit.
And I can say that it wasn't easy I had my head ache a dozen of times. And I had a few aha! moments as well.
I also had few times to work with it in the middle of the night just to fix a bug. 
I learned more about PHP, jQuery, JavaScript, SQL and some HTML5 stuff in the process of building it.
I also learned about DomPDF, HTML2PDF, PHPMailer and other stuff which we needed to incorporate in the project.
I also dealt with some configuration issues. 
This really gave me a lot of headaches as well since the application simply refused to work on a different environment.
We developed the application while using WAMPServer then used a separate installation of PHP, Mysql and Apache 
on deployment. As expected there were lots of differences between development and production environment so I had to
do a bunch of Googling and eyeball search(literally using my eyeballs to scan the file) on each of the configuration files of PHP (PHP.ini), MySQL (My.ini) and Apache (httpd.conf).
I also did a bunch of testing and bug-fixing (I regret not learning about TDD before I started the project).


###Personal Projects

Then came vacation time after the graduation. Of course lots of us graduates only thought about resting like there's no tomorrow. 
But there were some who already started looking for a job and scouting some companies for possible employment and I wasn't one of those.
Instead I focused on further improving my programming and overall web development skills.

And so I built a few personal projects like ChatRo, Placio, and Zenoir. Here's a bit of an overview:

####ChatRo
ChatRo was an application used for conducting meetings through chat (text). It also had a file-sharing feature which allows
the people in the current chat session to share some files which can immediately be downloaded by the people who are in the same session.
There was also a file viewing feature which is limited to viewing image, audio, excel, pdf, html, and video files. 
That's probably a lot but the downside is that its not available on every existing browser. 
Playing of audio and video is only for browsers which supports html5 audio and video.

####Zenoir
I'm a fan of the PS1 Game called Legend of Legaia and the name of this application 
came from one of the monsters in the game that I really liked.
Zenoir is an online classroom that has features such as:

 * Multi-File Upload
 * Chat - implemented using node.js to make it realtime
 * Status Monitoring - posts that hasn't been read by the currently logged in user has a red star 
 * Logging - student activities such as opening up a handout, answering assignment or joining a session can be seen by the teachers and administrators

Building this application gave me a lot of experience in using the CodeIgniter framework for PHP and MVC in general.
I also gained some experience in using Node.js, Node Package Manager, Socket.io, Mysql package for Node.js, and Now.js.
 
####Placio
Placio is a project I built to have an exercise on using the Google Maps API. 
I first started out by using different libraries that abstracts the Google Maps API.
But it didn't provide with the data and power that I needed so I sort of came back to
learn the API itself. It was a bit harder to use than most of the abstractions but its
more flexible and it had almost everything I needed.
Placio is used for plotting places on the map and allows the user to save
that place on the database and then assign images to that place. Sort of like Geo-tagging.


I also built a few applications for my own consumption such us Fylo, Snipper, and Sniply.

####Fylo
Fylo is a super simple application that's used for managing collections, in my case a DVD collection of anime series.

####Snipper
Just like what the name suggests this application is used for storing  and managing code snippets. 
Syntax highlighting is provided by Google Code Prettify.

####Sniply
Probably the simplest application which only does one thing. 
It allows the users to paste an image from the clipboard to a div, downside is that it only works on Chrome.
I envisioned it to be used for bug reporting as it also had a textarea for describing the problem that was 
shown in the image and it allows the user to send it to the email that is on the config file.


###Back to Basics

May of 2012, I discovered about this American company called Village88 that is dedicated to giving Free Education on Web Software Engineering. 
So I gave it a try and their education is really something. They care a lot about code quality. 
They have mentors who will check and comment on your work until it meets their standards. 
They have courses on HTML and CSS, PHP and MySQL, jQuery and Ajax, Object Oriented PHP and CodeIgniter, Version Control using Git and SVN,
and Application Deployment. At the time of writing of this article they offer 5 certifications.
I only got certified in HTML and CSS. But I'm planning to take the other courses soon.


###Jobs and Projects

Late July of 2012 I got my first online job at RNLTEK Media where I worked with a lot of new things such as the Facebook JavaScript and PHP SDK,
Live Contacts API, Yahoo Contacts API, and some open source libraries such as OpenInviter that is used for importing contacts from different email services.
My job at RNLTEK media was part-time so I pretty much had the time to work on my personal projects and go through some free online courses
such as the JavaScript and jQuery course on appendTo, and the Computer Science course at Udacity.

I also got this project at a Local Government Unit so I worked on that too on my free time.


###Blogging

While going through some of the blogs that I read daily I came accross this blogging platform called Octopress 
and I got really interested since it had all this cool stuff like responsive design, nice syntax highlighting,
and its using this static site generator called Jekyll 


###JavaScript

I can say that my education didn't have much of a direction since I just go ahead and learn any technology that I got interested with.
But this year I've mostly done JavaScript. JavaScript is pretty much in its Renaissance period, new JavaScript libraries are popping out 
every second, lots of projects are built around JavaScript, and everyone is all about JavaScript and how awesome it is.
So I have pretty much gone with the flow and wanted to learn more about JavaScript. 
I read books like JavaScript Enlightenment, Eloquent JavaScript, and jQuery Fundamentals which is by the way absolutely free.
I learned some of the best practices and quirks in JavaScript like not using Eval, avoiding global variables as they might
cause a conflict with some of the JavaScript libraries in the page, closures and that you can use them as some sort of database which can keep variable state, 
I also learned about hoisting, and that JavaScript only have function scope.


###More Personal Projects

I had lots of ideas on projects that I want to build one of those was fgenerate which I envisioned 
to help me on generating code that I usually write like connecting to the database, html forms, and code for manipulating the database.
At the time of writing of this article I only got as far as generating html forms from the fields selected from a mysql database.
The application is probably at 10% there's still much code to write. Hopefully I'll be able to finish it.

Before I even finish fgenerate I got another idea that I wanted to execute. 
I called the project "Postr". As I haven't finished working on fgenerate yet I decided to start with
something minimal. Postr is an application which might have probably been built before. 
But it doesn't hurt to recreate the wheel sometimes especially if you can learn a thing or two by recreating the wheel.
So I don't really believe in the quote "Don't recreate the wheel".
Postr allows the users to simultaneously post status updates on 4 of the major social networking sites: Facebook, Twitter, Google Plus and Linked In.

That's pretty much the road so far and I'll keep on getting better each day by constantly practicing and keeping my knowledge current.
I'll probably do a post like this maybe 2 or 3 years from now to look back from where I came from and to assess where I am now.