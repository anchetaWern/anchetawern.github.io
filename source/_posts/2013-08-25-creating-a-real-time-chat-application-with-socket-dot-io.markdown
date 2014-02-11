---
layout: post
title: "Creating a Real Time Chat Application With Socket.io"
date: 2013-08-25 13:58
comments: true
categories: [node.js, express.js, socket.io, redis, jquery]
published: true
updated: 2013-09-08 20:30
---

In this article I'm going to walk you through the process of building a real time chat application using Socket.io.
I just said Socket.io but socket.io isn't the only technology that were going to use for this mini project. Basically were going to make use of the following technologies:

- **Node JS** - this is the core technology that were gonna be using. Its basically just JavaScript on the server side
- **Redis** - were going to use it to store the messages sent by each user
- **Socket.io** - for real-time goodness!
- **Express JS** - a framework for Node JS, were going to use express JS for a more cleaner and expressive syntax


###Installation

First let's go ahead and install the things that we need for this project.

####Redis

You can install redis by downloading the latest stable release from the [redis website](http://redis.io/download).
After that you can use `tar` to extract its contents:

```
tar xvzf redis-stable.tar.gz
cd redis-stable
make
```

Then try if the build works by executing `make test` from the terminal to test if you have successfully installed redis.

If you're on Windows you can follow the instructions from here: [install redis on Windows](http://codingsteps.com/install-redis-on-windows/)

Once you have installed redis, you can test it out by opening a terminal and execute `redis-cli`. 
This will allow you to interact with redis. You can try inserting a new record by using the following command:

```
set name "iron man"
```

Then retrieve it using the following command:

```
get name //outputs: iron man
```


####Node JS

You can install node js through the terminal using `apt-get` if you're on linux:

```
sudo apt-get install python-software-properties python g++ make
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install nodejs
```

If you are on Windows you can simply download the installer from the [node js website](http://nodejs.org/download/)


###Setting Up the Application

Next we can now create the directory where our little chat application will reside. You can create it anywhere you want since Node.js doesn't need a server like Apache or Nginx to work. But for me I'll just be putting it on the web accessible folder intended for my Apache server. This won't have any effect since we'll be serving the chat application in its own port.


####Specify Dependencies

Next specify the dependencies of our little chat application. Simply create a `package.json` file and put in the following:

```
{
   "name": "realtime_chat_app",
   "description": "real time chat application",
   "version": "0.0.1",
   "dependencies": {
      "express": "3.x",
      "socketio" : "latest",
      "redis" : "latest"
   }
}
```

To break it down:

- **name** - this is the name of the application that you're trying to create.
- **description** - a short description of what the application is.
- **version** - the version number of the application, you can have any version number you want.
- **dependencies** - the node packages in which the application depends on in order to work. This takes up a set of key-value pairs. With the key being the name of the package and the value being the version number of the package. Here we've specified `express`, `socketio`, and `redis` as the dependencies. It's a good practice to actually specify the actual version number of the dependency instead of just specifying `latest` since there might be some breaking changes to the API in the future and your application will simply refuse to work by that time. But I don't think `socketio` and the redis client for node js is going to change its API anytime soon so let's stick with using the latest version for now. If you are not sure of the name of the dependency that you are trying to install, you can always make use of the [npm website](https://npmjs.org/) to find dependencies and their actual names.

![npm website](/images/posts/realtime_chat_socketio/npm.png)

Once you're done with that, save the file and open up the terminal in the same location where you have the `package.json` file then execute the following command:

```
npm install
```

This will install the dependencies under the `node_modules` directory.


###Building the Application

####Directory Structure

Now were ready to build the application. But first go ahead and create the following files and directories in your working directory:

```
 - chat_app (your working directory)
 	- public
 		- css
 			- main.css (the main css file for styling the chat app)
 		- img
 		- js
 			- vendor
 				- jquery.min.js (you can download it from jquery.com or simply load it from a cdn)
 	- views - index.html
 	- app.js

```

####Server-side Code

#####Initializing the Application

Open up the `app.js` file and initialize the app by declaring the following variables:

```javascript
var app_port = 8000; //the port in which the application will run
var io_port = 3333; //the port in which socket io will run

var express = require('express'); //include the express js framework
var app = require('express')(); //create an app using express js
var server = require('http').createServer(app); //create an express js server

var io = require('socket.io').listen(server); //start socket io

var redis = require("redis"); //include the redis client
var redis_client = redis.createClient(); //create a redis client
```

What you have just declared are the variables that's going to be used throughout the app.
The `app_port` is the port in which our app will run. So if you start the app by executing the following command:

```
node app.js
```

You can access it by going to `http://localhost:8000`. You can also use other ports aside from `8000` as long as its not already used by another running process.

The `io_port` is the port in which socket io will run. In this case were using port `3333`. Again you have to make sure that the port is not already in use by another process otherwise it wouldn't work.

The `express` variable contains the reference to the express js framework.
The `app` variable stores the reference to the new app created using express js.
The `server` variable contains the reference to the server that we create using express js.

The `io` variable contains the reference to socket io. We then immediately let it listen for events triggered from the express js server.

The `redis` variable contains the reference to the redis client. The redis client is a means of interacting with the redis server that we installed earlier. Its like an interface between node js and the redis server.

Then we create redis client and store it on the `redis_client` variable.

Then we set our app to use the `bodyParser`. The main usage for the `bodyParser` in our app is for parsing the request parameters when were sending parameters to the server. We also set the directory for static files to be served by the server using the `static()` method. The `static()` method takes up the name of the directory which contains the static files that you want to serve. In this case its the `public` directory in the root of our app.

```
app.use(express.bodyParser());
app.use(express.static('public'));
```

Next we create the variables that will store the names of the people who are currently on the chat and the chat messages.

```
var chatters = [];
var chat_messages = [];
```

#####Getting Users from Redis

Then we get the names of the people in the chat that are stored in the database. If it exists then we assign it to the `chatters` variable. We only store the stringified version of the JavaScript Object so we need to use `JSON.parse()` before assigning it to the variable.

```
redis_client.get("chat_app_chatters", function(err, reply){
	if(reply){
		chatters = JSON.parse(reply);
	}
});
```

#####Getting Messages from Redis

We also get the messages stored in the database and assign it to the `chat_messages` variable if it exists. 

```
redis_client.get("chat_app_messages", function(err, reply){
	if(reply){
		chat_messages = JSON.parse(reply);
	}
});
```

#####Index Page

Next let's set what happens when users try to access the root url (http://localhost:8000).
Here were using the `get()` method which takes up 2 arguments. The first argument is the path, and the second argument is the callback function in which the request (req) and response (res) are passed behind the scenes.
All you need to remember here is that the `req` variable stores the request parameters such as the form data that you pass when requesting for the specified path (/). And the `res` variable contains methods which you can use for the response. In this case were simply sending the static `index.html` file. This means that when users request for `http://localhost:8000` the `index.html` under the `public/views` directory will be rendered in the browser.

```
app.get('/', function(req, res){
	res.sendfile('./views/index.html');
});
```

#####Initializing Socket.IO

Next we initialize socket io. Here were listening to 2 events, the `message` event and the `update_chatter_count` event. These 2 events are custom events so you can name it anything you want as long as it has a reciprocal event on the client side. When the `message` event happens we immediately emit the `send` event to each of the users that are currently on the chat room. The same is true with the `update_chatter_count` event, we immediately emit the `count_chatters` event to the rest of the clients when this event happens. But we don't just emit the event, we also pass in the data that come from the client who emmited the event.

```
io.sockets.on('connection', function(socket){
  
  socket.on('message', function(data){
  	io.sockets.emit('send', data);
  });

  socket.on('update_chatter_count', function(data){
  	io.sockets.emit('count_chatters', data);
  });
});
```

Yes I know this is really confusing, I also got confused at first so I recommend you to just play around with the code until it finally ticks.
What you have to remember is that both the server and the client should have the code that both listens and emit the events. What you emit in the client side you should listen for it on the server side, and what you listen for in the client side should be emitted from the server side.


#####Joining the Chat Room

Next is the code for joining the chat room. What were doing here is to get the username passed in from the client side, then check if the username already exists in the array of usernames by using the `indexOf()` method. 
The `indexOf()` method returns a value of `-1` if the value that you specified doesn't exists yet.
If the user doesn't exists yet we simply push it into the `chatters` array which stores a list of usernames. Then we also save it into the database. The way we save into redis is to call the `set` method provided by the redis client for node. The `set` method takes up a `key` and a `value` as its arguments. Here were storing the stringified version of the `chatters` array. Finally we send a response to the client containing the current value of the `chatter` array and a `status` of `ok`. Otherwise we send a `failed` status if the user already exists.

```
app.post('/join_chat', function(req, res){

	var username = req.param('username');
	if(chatters.indexOf(username) == -1){
		chatters.push(username);
		redis_client.set('chat_app_chatters', JSON.stringify(chatters));
		res.send({'chatters' : chatters, 'status' : 'ok'});
	}else{
		res.send({'status' : 'failed'});
	}
});
```

#####Leaving the Chat Room

Next is the code for leaving the chat room. 
This takes up the username of the user whose going to leave the chat room.
We simply remove it from the array of chatters by using the `splice` method which takes up the index of the item that we want to remove in the array and the number of items that we want to remove. We then commit it back to the database and send an ok status to the client.

```
app.post('/leave_chat', function(req, res){

	var username = req.param('username');
	chatters.splice(chatters.indexOf(username), 1);	
	redis_client.set('chat_app_chatters', JSON.stringify(chatters));
	res.send({'status' : 'ok'});
});
```

#####Sending Messages

Next is the code that handles the messages that are sent from the client side.
This takes up the username (sender) and the actual message. We then push these values to the `chat_messages` array which stores the sender names and their messages. Then we also commit the stringified version back to the database.

```
app.post('/send_message', function(req, res){
	var username = req.param('username');
	var message = req.param('message');

	chat_messages.push({'sender' : username, 'message' : message});
	redis_client.set('chat_app_messages', JSON.stringify(chat_messages));
	res.send({'status' : 'ok'});
});
```

#####Getting Messages

Next is the code that returns the messages. This doesn't take up any parameters from the client side, it simply returns the `chat_messages` array. This will be used in the client side to load the messages for a person who enters the chat room later than the others. If you remember earlier were updating the database every time a message is sent. And on every page load were assigning the value for the `chat_messages` array to be equal to the messages that are currently on the database. This means that all the messages that has been previously sent by other users in the chat room will be stored in the `chat_messages` array which we are returning here.

```
app.get('/get_messages', function(req, res){

	res.send(chat_messages);
});
```

#####Getting the People in the Chatroom

We also have this code for returning the people who are currently on the chat room. 
This will be used in the client side to determine the number of people who are currently on the chat room.

```
app.get('/get_chatters', function(req, res){

	res.send(chatters);
});
```

Finally we make our server listen to port 8000 so that we actually see something once we access `http://localhost:8000` in the browser.

```
server.listen(8000);
```

####Client-side Code

#####Markup

Next is the markup for our simple chat application. I tried to make it as simple as possible so we only have a simple form in here that asks for the username, then a join chat button to actually join the chat room. We also have this `.chat-info` div which we will use later on to show the number of users that are currently on the chat room. Then we have this `.chat` div which serves as a container for everything that has something to do with the chat.
The `.messages` div which is directly inside of it will be used as a container for all the messages sent by each of the users in the chat room. Then we also have this `#message` textarea which will be used by users to input their messages. Then we have buttons for leaving the chat room and sending the message. Finally we include the socket io client side script, jquery, and our main JavaScript file.

```html
<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Simple Chat Application</title>
	<link rel="stylesheet" href="/css/main.css">
</head>
<body>
	<div class="container">
		<h1>Simple Chat Application</h1>
		<div class="join-chat">
			<label for="username">Username:</label>
			<input type="text" id="username" name="username" />
			<input type="button" id="join-chat" value="Join Chat" />
		</div>
		<div class="chat-info"></div>
		<div class="chat">		
			<div class="messages">
				
			</div>
			<textarea name="message" id="message" cols="93" rows="5"></textarea>
			<input type="button" id="leave-chat" data-username="" value="Leave Chat">
			<input type="button" id="send-message" data-username="" value="Send Message">
		</div>
	</div>
	<script src="/socket.io/socket.io.js"></script>
	<script src="/js/vendor/jquery.min.js"></script>
	<script src="/js/main.js"></script>
</body>
</html>
```

#####Styling

For the stylesheet. The main container would be at the center of the screen. 
The container for the messages will have a border of black. 
For the chat container its initially set to be not displayed as users would have to join the chat first before they can see what's going on in the chat room. The container for an individual message sent by a user is going to have a width which occupies the entire width of its parent which is the div with a class of `messages`.
Finally, each `user` container would be floated to the left so that the username would always appear on the left side of the screen.

```css
.container {
    width: 777px;
    margin: 0 auto;
}

.messages {
    border: 1px solid;
    width: 769px;
    height: 240px;
}

.chat{
	display: none;
}

.msg {
    width: 100%;
}

.user {
    float: left;
    margin-right: 10px;
    font-weight: bold;
}
```

On our main JavaScript file `main.js` we declare the `socket` variable globally. 
It would be a good practice to actually enclose it inside an immediately invoked function expression so that it won't be accessed from the outside but for this tutorial let's just stick with declaring it globally.
The `socket` variable is our means of connecting to the socket io server which is running on the server.

```javascript
var socket = io.connect('http://localhost'); //connect to the socket io server
var chatter_count; //stores the current number of users in the chat room
```

######Getting Current Users

Next we get the users who are currently on the chat room. Here were using the `$.get` jQuery method to request the data from the server using the `GET` method. If you remember earlier we used `app.get('/get_chatters')` on our server-side code. Here were simply telling the server to give us the value returned from that function that we declared earlier. So the `response` here is actually the array of users that are currently on the chat room.
We simply get the built-in attribute for arrays which is `length` to get the number of users who are currently in the chat room. We then use this value to update the contents of the `.chat-info` div and the `chatter_count` variable.

```
$.get('/get_chatters', function(response){
	$('.chat-info').text("There are currently " + response.length + " people in the chat room");
	chatter_count = response.length; //update chatter count
});
```

######Joining the Chat Room

Next is the code for joining the chat room. Here were simply requesting for the `/join_chat` path that we declared earlier on the server. If you go back to that code you'll see that were getting `req.param('username')`. That's exactly what were passing in here, the username of the user who wants to join the chat room. 
If the username doesn't already exists  we emit the `update_chatter_count` event passing in an object which contains the specific action that we want to perform with the `chatter_count` variable. In this case were telling it to increase since a new user just joined the chat room. We also update the UI to show the chat container. We also update the buttons for leaving the chat room and sending a message to include a data attribute of `username` which simply stores the username of the user who just joined the chat room.
After that we request for the chat messages from the server. If there's actually a message returned we update the chat box to include these messages. It's a good practice to store the html for updating the UI in a variable then updating the UI after you already got everything to reduce the need to update the browser. It's also a good practice to use templating engines such as Mustache or Handlebars but let's just stick with appending HTML this time to keep things simple. After that we simply hide the container for joining the chat room so that the user cannot join again.
If the username already exists then we simply `alert` the user that the username that he inputted already exists, then we re-focus to the username input field to make it easier to input a username again.

```
$('#join-chat').click(function(){
	var username = $.trim($('#username').val());
	$.ajax({
		url: '/join_chat', 
		type: 'POST',
		dataType: 'json',
		data: {
			'username' : username
		},
		success: function(response){		
			if(response.status == 'ok'){ //username doesn't already exists
				
				socket.emit('update_chatter_count', {'action' : 'increase'});
				$('.chat').show();
				$('#leave-chat').data('username', username);
				$('#send-message').data('username', username);

				$.get('/get_messages', function(response){
						
					if(response.length > 0){
						var message_count = response.length;
						var html = '';
						for(var x = 0; x < message_count; x++){
							html += "<div class='msg'><div class='user'>" + response[x]['sender'] + "</div><div class='txt'>" + response[x]['message'] + "</div></div>";
						}
						$('.messages').html(html);
					}
				});			
				
				$('.join-chat').hide(); //hide the container for joining the chat room.

			}else if(response.status == 'failed'){ //username already exists
				alert("Sorry but the username already exists, please choose another one");
				$('#username').val('').focus();
			}
		}
	});
});
```

######Leaving the Chat Room

For the code for leaving the chat room, we simply pass in the `username` to the server side. 
If the response is `ok` we emit the `message` event containing an object that contains the `username` of the user who left the chat room along with a final message which simply says `user x has left the chat room` so that other users will also know that a specific user has already left. Then we also emit the `update_chatter_count` event and pass the object which simply tells to every listener to `decrease` the chatter count. Finally we simply hide the chat container, show the join chat container, empty the username field and alert the user that he has successfully left the chat room.

```
$('#leave-chat').click(function(){
	var username = $(this).data('username');
	$.ajax({
		url: '/leave_chat',
		type: 'POST',
		dataType: 'json',
		data: {
			'username' : username
		},
		success: function(response){
			if(response.status == 'ok'){
				socket.emit('message', {'username' : username, 'message' : username + " has left the chat room.."});
				socket.emit('update_chatter_count', {'action' : 'decrease'});
				$('.chat').hide();
				$('.join-chat').show();
				$('#username').val('');
				alert('You have successfully left the chat room');
			}
		}
	});
});
```

######Sending Messages

Next is the code for sending a message. 
Here were passing along the `username` of the user who sent the message along with his `message`.
If the response from the server is `ok` then we simply emit the `message` event containing an object which contains the username of the sender and his actual message. All the listeners to this event would be able to get this data and do something with it.

```
$('#send-message').click(function(){
	var username = $(this).data('username');
	var message = $.trim($('#message').val());

	$.ajax({
		url: '/send_message',
		type: 'POST',
		dataType: 'json',
		data: {
			'username' : username,
			'message' : message
		},
		success: function(response){
			if(response.status == 'ok'){
				socket.emit('message', {'username' : username, 'message' : message});
				$('#message').val('');
			}
		}
	});
});
```

######Updating the UI

Next is the code for listening to the `send` event. 
This is responsible for updating the UI every time the `message` event is emitted. 
What it does is to simply append another row which contains the sender name and the actual message to the chat box.

```
socket.on('send', function(data){
	var username = data.username;
	var message = data.message;

	var html = "<div class='msg'><div class='user'>" + username + "</div><div class='txt'>" + message + "</div></div>";
	$('.messages').append(html);
});
```

Finally the code for listening for the `count_chatters` event. This is responsible for updating the UI every time the `update_chatter_count` event is emitted.

```
socket.on('count_chatters', function(data){
	if(data.action == 'increase'){
		chatter_count++;
	}else{
		chatter_count--;
	}
	$('.chat-info').text("There are currently " + chatter_count + " people in the chat room");
});
```

This is what our simple chat application would look like once its done:

![Simple Chat Application](/images/posts/realtime_chat_socketio/simple-chat-app.png)


##Resources

- [Node JS](http://nodejs.org/)
- [ExpressJS](http://expressjs.com/)
- [Introduction to Express](http://net.tutsplus.com/tutorials/javascript-ajax/introduction-to-express/)
- [Socket IO](http://socket.io/)
- [Try Redis](http://try.redis.io/)
- [Long Polling VS Short Polling](http://codertalks.com/long-polling-vs-short-polling/)


##Conclusion

You've learned how to create a simple chat application using NodeJS, ExpressJs, Socket.IO, Redis and jQuery.
As you can see from the code that we've written its very easy to create real-time applications with these technologies. 