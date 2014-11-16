---
layout: post
title: "Getting Started with RabbitMQ in PHP"
date: 2014-11-16 15:11
comments: true
published: true
categories: [php, rabbitmq]
---

{% blockquote %}
This article was originally published at Binpress:
http://www.binpress.com/tutorial/getting-started-with-rabbitmq-in-php/164
{% endblockquote %}


In this tutorial I'm going to walk you through how you can use RabbitMQ in PHP. But first what is RabbitMQ? RabbitMQ is a message broker software. It acts as a middleman between a producer and a consumer. Producer being the data that we want to pass, and consumer being the entity that we want to pass it to. RabbitMQ uses a queue, you can think of it as a mailbox where you drop your letters. RabbitMQ then takes the letters and delivers it to its destination.

###Installing RabbitMQ

In Ubuntu and other debian based operating system you can install RabbitMQ by executing the following commands from your terminal:

```
echo "deb http://www.rabbitmq.com/debian/ testing main"  | sudo tee  /etc/apt/sources.list.d/rabbitmq.list > /dev/null
sudo wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
sudo apt-key add rabbitmq-signing-key-public.asc
sudo apt-get update
sudo apt-get install rabbitmq-server -y
sudo service rabbitmq-server start
sudo rabbitmq-plugins enable rabbitmq_management
sudo service rabbitmq-server restart
```

What the first command does is to append the rabbitmq source to the software sources list. Next we download the rabbitmq signing key using `wget`. Then add the key to Ubuntu. Next we call `apt-get update` to update the software sources list. Next we install the RabbitMQ server, start it then enable RabbitMQ management plugin. This provides an HTTP-based API management for monitoring your RabbitMQ server. Finally we restart the RabbitMQ server so that changes will take effect.
The default username and password is `guest`. And the default port in which it runs is `5672`.

If you're on another operating system, you can find how to install RabbitMQ for your specific operating system here: [Downloading and Installing RabbitMQ](http://www.rabbitmq.com/download.html).

###Working with RabbitMQ

Once you're done installing RabbitMQ, we can now install the AMQP library for PHP. This implements the AMQP (Advanced Messaging Queue Protocol) protocol. As the name suggests it is a protocol used for messaging. 
Start by creating a new directory, this is where we will put all the files for testing RabbitMQ. Next create a composer.json file and add the following:

```
{
  "require": {
      "videlalvaro/php-amqplib": "2.2.*"
  }
}
```

Next, open up your terminal and `cd` into the directory you created earlier then execute `composer install` to install the AMQP library.

Before we move on, lets also install [Swiftmailer](http://swiftmailer.org/). You can do that by executing the following command from your terminal. This also adds an entry to Swiftmailer to your composer.json:

```
composer require swiftmailer/swiftmailer @stable
```

We will be using Swiftmailer for the sample app that were going to create. What we will do is create an app that will send emails for our users. Normally emails takes a few seconds before it is sent, adding an attachment to the email also adds to that time. In the real world we don't really want our users to wait. What we want to do is make them believe that we have already sent the email for them by outputting to the screen that their message has been sent.
This is where RabbitMQ comes in. We will use it as some sort of a mailbox in which multiple users can just drop their messages in. RabbitMQ will then take care of sending the messages in the background.

####Sending Messages

First lets create the form to be used for sending emails. This will accept the name and email address of the sender, the email address of the receiver and then the subject and message. Name the file `form.php`:

```html
<?php
if(!empty($_GET['sent'])){
?>
<div>
    Your message was sent!
</div>
<?php
}
?>
<form action="mailer.php" method="POST">
    <div>
        <label for="from">From</label>
        <input type="text" name="from" id="from">       
    </div>
    <div>
        <label for="from_email">From Email</label>
        <input type="text" name="from_email" id="from_email">       
    </div>
    <div>
        <label for="to_email">To Email</label>
        <input type="text" name="to_email" id="to_email">           
    </div>
    <div>
        <label for="subject">Subject</label>
        <input type="text" name="subject" id="subject">
    </div>
    <div>
        <label for="message">Message</label>
        <textarea name="message" id="message" cols="30" rows="10"></textarea>   
    </div>
    <div>
        <button type="submit">Send</button>
    </div>
</form>
```

Next, create the file which will push the message into the queue. Name the file `sender.php`. 
Require the `autoload.php` file so that our dependencies will be automatically loaded by PHP. Then use the `AMQPConnection` and `AMQPMessage` from the AMQP library. `AMQPConnection` allows us to create a new connection to the RabbitMQ server and `AMQPMessage` allows us to create messages that we can push to the queue.

```php
<?php
require_once __DIR__ . '/vendor/autoload.php';
use PhpAmqpLib\Connection\AMQPConnection;
use PhpAmqpLib\Message\AMQPMessage;

$connection = new AMQPConnection('localhost', 5672, 'guest', 'guest');
$channel = $connection->channel();

$channel->queue_declare('email_queue', false, false, false, false);

$data = json_encode($_POST);

$msg = new AMQPMessage($data, array('delivery_mode' => 2));
$channel->basic_publish($msg, '', 'email_queue');

header('Location: form.php?sent=true');
?>
```

Breaking it down, first we create a new connection by creating a new instance of the `AMQPConnection` class. This requires the following arguments: 

- **host** - the host in which the RabbitMQ server is running. In this case we've installed RabbitMQ on the same computer we are running the script in. So it should be `localhost`. Note that in the real world we install RabbitMQ on a another server, different from the one were using to serve our websites. So instead of `localhost` we use the public ip address of that server.
- **port** - the port in which the RabbitMQ server is running.
- **user** - the username to use for logging in to the server. By default the username is set to `guest`.
- **password** - the password of the user. By default the password is set to `guest`.

Next we create a channel. We can do that by calling the `channel()` method from the connection that we have just declared.

```
<?php
$channel = $connection->channel();
?>
```

Next we declare the queue to be used by calling the  `queue_declare` method.

```
<?php
$channel->queue_declare('email_queue', false, false, false, false);
?>
```

The `queue_declare` method takes up the following arguments:

- **queue name** - a name that you want to use for the queue, you can supply anything for this. 
- **passive** - a boolean value for specifying whether to check for an existing exchange.
- **durable** - a boolean value for specifying whether the RabbitMQ holds on to a queue when the server crashes.
- **exclusive** - a boolean value for specifying whether the queue is used by only one connection.
- **auto-delete** - a boolean value for specifying whether the queue is deleted when the last subscriber unsubscribes.

Next we convert the POST data that we receive from the form to a JSON string. We can only pass strings as a message so we'll have to convert this later on into an array on the receiver's end.

```
<?php
$data = json_encode($_POST);
?>
```

Next we create a new message. This accepts 2 arguments: the data and an array of options. For the array of options we specify the `delivery_mode` to 2 which means that the message is persistent. This means that it isn't lost when the server crashes or an error occurs.

```
<?php
$msg = new AMQPMessage($data, array('delivery_mode' => 2));
?>
```

Next we publish the message by calling the `basic_publish()` method on the channel. This accepts 3 arguments: the message, the exchange and the name of the queue. If you're wondering why we set the value of exchange to an empty string, that's because we don't really need it. The exchange is commonly used for pub-sub patterns. What were using here is just basic publish.

```
<?php
$channel->basic_publish($msg, '', 'email_queue');
?>
```

Finally we just redirect the user to the form.

```
<?php
header('Location: form.php?sent=true');
?>
```


####Receiving Messages

Now were ready to write the code that will receive the messages sent by users. Name the file `receiver.php`. Here's the full contents of the file:

```
<?php
require_once __DIR__ . '/vendor/autoload.php';
use PhpAmqpLib\Connection\AMQPConnection;

$connection = new AMQPConnection('localhost', 5672, 'guest', 'guest');
$channel = $connection->channel();

$channel->queue_declare('email_queue', false, false, false, false);

echo ' * Waiting for messages. To exit press CTRL+C', "\n";

$callback = function($msg){

    echo " * Message received", "\n";
    $data = json_decode($msg->body, true);

    $from = $data['from'];
    $from_email = $data['from_email'];
    $to_email = $data['to_email'];
    $subject = $data['subject'];
    $message = $data['message'];

    $transporter = Swift_SmtpTransport::newInstance('smtp.gmail.com', 465, 'ssl')
      ->setUsername('YOUR_GMAIL_EMAIL')
      ->setPassword('YOUR_GMAIL_PASSWORD');

    $mailer = Swift_Mailer::newInstance($transporter);  

    $message = Swift_Message::newInstance($transporter)
        ->setSubject($subject)
        ->setFrom(array($from_email => $from))
        ->setTo(array($to_email))
        ->setBody($message);

    $mailer->send($message);
    
    echo " * Message was sent", "\n";
    $msg->delivery_info['channel']->basic_ack($msg->delivery_info['delivery_tag']);
};

$channel->basic_qos(null, 1, null);
$channel->basic_consume('email_queue', '', false, false, false, false, $callback);

while(count($channel->callbacks)) {
    $channel->wait();
}
?>
```

Breaking it down, the first 5 lines of code are basically the same as the one we have on the `sender.php` file. Then we just output a message saying how we can stop the file from running. We need to run this file from the terminal so to stop it we just hit `CTRL + C`.

Next we declare a named function. This will be used for processing the message that we passed from the sender. The first thing it does is output that the message was received. Then we use `json_decode()` to convert the JSON string back to an array.

```
<?php
$callback = function($msg){
    echo " * Message received", "\n";
    $data = json_decode($msg->body, true);
};
?>
```

Next we extract the data and assign them to each of their own variables:

```
<?php
$from = $data['from'];
$from_email = $data['from_email'];
$to_email = $data['to_email'];
$subject = $data['subject'];
$message = $data['message'];
?>
```

Next we declare a new transporter to be used by Swiftmailer. This allows us to use a gmail account for sending emails. Declaring a new instance accepts 3 arguments: the host, port and the encryption. Then we set the username and password.

```
<?php
$transporter = Swift_SmtpTransport::newInstance('smtp.gmail.com', 465, 'ssl')
      ->setUsername('YOUR_GMAIL_EMAIL')
      ->setPassword('YOUR_GMAIL_PASSWORD');
?>
```

Next we declare a new mailer instance, and supplying the transporter as an argument.

```
<?php
$mailer = Swift_Mailer::newInstance($transporter);  
?>
```

Next create a new message, this also takes up the transporter as its argument. We then set the subject, from field, to field, and body of the message.

```
<?php
$message = Swift_Message::newInstance($transporter)
        ->setSubject($subject)
        ->setFrom(array($from_email => $from))
        ->setTo(array($to_email))
        ->setBody($message);
?>
```

Finally we send the message and output that the message was sent. The last line basically tells RabbitMQ that the sending of the message has indeed been successful. 

```
<?php
$mailer->send($message); 
echo " * Message was sent", "\n";
    
$msg->delivery_info['channel']->basic_ack($msg->delivery_info['delivery_tag']);
?>
```

####Running the program

You can now run the receiver by going to your terminal and executing the following command:

```
php receiver.php
```

Once its running, go to your browser and access the `sender.php` file. Enter the details of your message and click on send. You're instantly greeted by a 'Your message was sent!' text but if you immediately check your email account its not there yet. If its not there then the queue is still processing it. Check the output displayed on the terminal window where you executed the receiver. You should see a 'Message was sent' output if the email was already sent.

###Conclusion

RabbitMQ is a nice way for implementing messaging applications such as the one we created in this tutorial. We have barely scratch the surface with this tutorial. I recommend you check out the [getting started guides](http://www.rabbitmq.com/getstarted.html) and the [documentation](http://www.rabbitmq.com/documentation.html) to learn more.
