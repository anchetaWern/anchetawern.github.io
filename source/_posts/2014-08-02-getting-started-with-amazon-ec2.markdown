---
layout: post
title: "Getting Started with Amazon EC2"
date: 2014-08-24 19:00
comments: true
categories: [ec2]
published: true
---

In this tutorial I'm going to give you an introduction on how to setup an Amazon EC2 instance that uses the LAMP stack. This tutorial assumes that you already have an AWS account setup. 

####Setting up the instance

The first thing that you need to do is to login to your AWS account. Once logged in, click on the instances link found on the left side of the screen. Once in the instances page, click on the 'Launch Instance' button. You will then be redirected to the page where you can select the operating system that will be used for the instance that you want to create:

![choose AMI](/images/posts/amazon_ec2/start.png)

If you're using Ubuntu for your development, it would be much easier for you if you also select the Ubuntu Server, the 64-bit version if preferred. Just click on the 'select' button beside the Ubuntu instance. 

Next, we need to select the instance type. For starters you may want to try the t2.micro instance as its eligible for the free tier, this means that you don't have to pay anything when you launch this type instance.

![choose instance](/images/posts/amazon_ec2/instance-type.png)

If you're looking into launching an instance which exactly fits your needs, check out [ec2instances.info](http://www.ec2instances.info/). Note that an instance that's not eligible for free tier would cost you per hour so be really careful with the instance that you select.

Once you're done selecting the instance type, click on the 'Next: Configure Instance Details', that will redirect you to the page where you can configure details about your instance. Things like the Virtual Private Cloud, Subnet and Public IP. Usually you don't really have to touch these settings so just leave the default ones.

![configure instance](/images/posts/amazon_ec2/configure-instance.png)

Next click on the 'Next: Add Storage' button. That will redirect you to the page where you can configure the size and volume type of the storage that will be used for your instance. Just input 30 for the size as free tiers are eligible for up to 30 GB. If you have selected something higher than the free tier, you can find information on how much storage size you can have at [ec2instances.info](http://www.ec2instances.info/). For the volume type, just use the general purpose SSD.

![add storage](/images/posts/amazon_ec2/add-storage.png)

Next click on the 'Next: Tag Instance' button. That will redirect you to the page where you can assign a key-value pair to your instance. This allows you to tag your instance with those key-value pairs which enables you to categorize your AWS resources in different ways. We won't really be using tags in this tutorial so if you want to learn more about tagging your instance, check out the [official docs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html).

![tag instance](/images/posts/amazon_ec2/tag-instance.png)

Next click on the 'Next: Configure Security Group' button. That will redirect you to the page where you can configure the security group used by the instance. In simple terms, security groups allows you to set the ports used by your instance and which IP addresses are allowed access to those ports. You can assign different settings for inbound and outbound rules. Inbound rules are the settings used for requests made to your server by other computers. 

For inbound rules you would commonly have the following settings:

- **Type:** SSH - this allows you to access your instance via SSH.
- **Protocol:** TCP
- **Port:** 22
- **Source:** 0.0.0.0/0 - if you got a static IP assigned to your computer, its more secure if you set that IP for this field. Otherwise just select 'Anywhere' which allows access to any IP.

- *Type:* - HTTP - this allows you to access your instance from the browser.
- **Protocol:** TCP
- **Port:** 80
- **Source:** 0.0.0.0/0 - this means anyone which has access to the internet can access your instance via the DNS provided by Amazon or the public IP assigned to your instance.

For outbound rules:

- *Type:* - HTTP - this allows your instance to download stuff from the internet.
- **Protocol:** TCP
- **Port:** 80
- **Destination:** 0.0.0.0/0 - this means that your instance can make the request to any server.

- *Type:* MYSQL - this allows your instance to make a request to the MySQL server. 
- **Protocol:** TCP
- **Port:** 3306
- **Destination:** 0.0.0.0/0 - this allows your instance access to any MySQL server. You can also set this to the private IP of your instance. You can only specify a single IP so if you're planning to access other MySQL servers aside from the one installed on your ec2 instance then just select 'Anywhere'.

That's pretty much it. 

You can learn more about security groups in this page: [Amazon EC2 Security Groups](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html)

Once you're done configuring the security group, click on 'Review and Launch' button. You can now review the details of the instance, once you're done reviewing just click on the 'Launch' button. Amazon will now prompt you to create an ssh key or use an existing key if you already have an existing one. You can use the ssh key to authenticate yourself when logging in to your instance via ssh. Keep the ssh key somewhere where you can easily find it. For me I prefer putting it in the `~/.ssh` directory.


####Installing Software

Now that you have launch the instance you can now access it via ssh. To do that, login to your amazon account, click the 'services' link on the upper left corner of the screen, hover on the 'All AWS Services' link then click on 'EC2'. That will redirect you to the ec2 dashboard page. Once you're there, click on the 'instances' link. This will list out all the instances that you have created in the current region that you have selected. If nothing is listed on that page the instance that you have created might be on another region. To change the region you can click on the second link from the right. The one which looks like a place in the world. Select any of the places listed in there and your instance will be listed in any of those.
Next click on the instance listed then copy the value for the 'Public DNS'. 
Open up a terminal, `cd` into the directory where you have your ssh key then execute the following command:

```
ssh -i amazon-aws.pem ubuntu@the-public-dns-of-your-instance
```

Breaking the command down, `-i` allows you to specify the ssh key file. In this case the file name is `amazon-aws.pem`. Next is the username of the user you want to use to login, in this case the username is `ubuntu`. That's the default username for Ubuntu ec2 instances. Next is `@` followed by the public dns of your instance. If you have already assigned a domain name to your instance you can also use that.

Once you're logged in you can now start installing software. Ec2 instances doesn't come pre-installed with Apache, PHP and MySQL. So you would need to install it yourself. Here are some of the software that I usually install on an ec2 instance:

Curl:

```
sudo apt-get install curl
sudo apt-get update
sudo apt-get install libcurl3 php5-curl
```

Composer:

```
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
```

Apache:

```
sudo apt-get install apache2
sudo /etc/init.d/apache2 restart
```

PHP:

```
sudo apt-get install php5
sudo apt-get install libapache2-mod-php5
```

MySQL:

```
sudo apt-get install mysql-server
sudo apt-get install php5-mysql
```


####Configuring Apache

Once everything is installed you still have to configure Apache to use a different web directory. This is because the default one isn't really that friendly. As you have to `sudo` every time you need to save or update something from the directory. My preferred directory is one that is on the home directory. As you won't need any special privileges to do anything inside of it. To configure Apache to use a different directory, `cd` into the `/etc/apache2` directory then open up the `apache2.conf` file. You can open up the file using a text editor like `nano`, `vi` or `vim`. Once you're in that directory open up the file using the text editor of your choice:

```
sudo nano apache2.conf
```

Now look for the `Directory` directives and update it to use a value similar to the following:

```
<Directory />
        Options FollowSymLinks
        AllowOverride None
        Require all denied
</Directory>

<Directory /usr/share>
        AllowOverride None
        Require all granted
</Directory>

<Directory /home/ubuntu/www>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
</Directory>
```

For the configuration file above were using `/home/ubuntu/www` as the web root directory. You can change this to any directory on your `home` folder. Just be sure that the directory exists.

Still on the same directory, `cd` into the `sites-available` directory then open up the `000-default.conf` file. Look for the `DocumentRoot` directive and specify the path to your web root directory.

```
DocumentRoot /home/ubuntu/www
```

Once everything is done, restart Apache using the following command:

```
sudo service apache2 restart
```


###Conclusion

That's it! In this tutorial you have learned how to set up an ec2 instance, install software needed to host a website. You can use the free tier to quickly test out an app idea and bring it online for everyone to test out.

