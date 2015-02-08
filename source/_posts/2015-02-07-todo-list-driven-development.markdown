---
layout: post
title: "ToDo List Driven Development"
date: 2015-02-08 16:37
comments: true
categories: ['work']
published: true
---

In my daily work as a developer I always have this file which I call `todo.txt`. It contains all the things that I plan to work on, currently working on, and those that I've already done in the past. They are ordered from the most recent day that I've worked on the project to the least recent. These todos are stored in their own folders, named after the name of the project. Here's the general format that I follow:

```
FEB 7, 2015

TODO
- list of things that I'll be doing

DONE
- list of things that I've done
=========================

FEB 6, 2015
```

This is the first file that I open when I start working. It gives me a quick overview on which things I've already finished and which things are left undone. 

The items in the todo list often represents individual features that I have to work on. If the feature is too big (may take around 2-5 days to implement), I break it down into tiny bits to reduce the mental strain. Because holding one big feature in your short term memory is hard. I want to make my todo list as stupid as possible. So I can focus on writing the code and not needing to hold many details in my head. It would often look like a step by step procedure (algorithm) of sorts. Here's an example from the booking app that I'm currently working on:

```
TODO
- add code for scheduling new appointments
 - use the combination of page url and service url as basis for selecting the needed data from the database.
 - once all the necessary data is in place, use it to get the time settings from the database.
 - use the time settings to generate an array that stores all the available times.
 - get all the times which has already been used in an appointment
 - get the settings on the maximum appointments that can be scheduled per day, the minimum scheduling notice, and the maximum number of days into the future can appointment be scheduled (to prevent scheduling something on year 2099 while its still 2015).
 - loop through all the available times. While inside the loop exclude all the times which has already been used in an appointment, also exclude the times based on the settings above.
```

Of course it doesn't end there, but you get the idea. Make every item or in this case sub-item as stupid to implement as possible. If you think it would help to break each sub-item down some more, then do it.

Aside from the features I need to implement, my `todo.txt` file is where I also put details on the current project that I'm working on. As I'm primarily using Amazon ec2 instances on my projects, the details that I put on top of the file are the ip address, the domain name assigned to the instance and then the user and password for the database. Yes it would be more secure if I put them on a password manager such as keypass or lastpass but I prefer fast access over it. I just want everything that I need for the job to be in one place. 

Lastly, when I'm doing research for the project that I'm currently working on. I also put in some relevant URLs which I could easily go back to later on once I implement a specific feature. When I find myself going back to access a specific page very often, I just copy the specific content that I need and paste it on the file. Here's a sample snippet, these are the set of commands that I use when building a phonegap app:

```
#build phonegap app
cordova build --release android

#generate app key
keytool -genkey -v -keystore stockswitch.keystore -alias switch -keyalg RSA -keysize 2048 -validity 10000

#sign the app with the key
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore stockswitch.keystore CordovaApp-release-unsigned.apk switch

#build a release version
zipalign -v 4 CordovaApp-release-unsigned.apk stockswitch.apk

#output the certificate
keytool -exportcert -alias switch -keystore stockswitch.keystore | openssl sha1 -binary | openssl base64
```

That's it! Having a `todo.txt` file at my disposal is really helpful in my day to day life as a developer. It helps keep the mental load to the minimum by having all the details that I need all in one place.