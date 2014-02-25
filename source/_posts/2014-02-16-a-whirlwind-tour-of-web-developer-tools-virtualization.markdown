---
layout: post
title: "A Whirlwind Tour of Web Developer Tools: Virtualization"
date: 2014-02-23 08:16
comments: true
categories: [virtualization, vagrant, tools]
published: true
updated: 2014-02-25
---

In this third part of the series [A Whirlwind Tour of Web Developer Tools](http://anchetawern.github.io/blog/2014/02/09/a-whirlwind-tour-of-web-developer-tools/) I'll walk you through virtualization.
But before we dive in let's first define what virtualization is. According to Wikipedia:

{% blockquote %}
Virtualization is the act of creating a virtual (rather than actual) version of something, including but not limited to a virtual computer hardware platform, operating system, storage device, or computer network resources.
{% endblockquote %}	

In simple terms virtualization is creating a virtual copy of something. Virtual meaning that its not actually real but you can actually do things just like you do with the real thing. 

<!--more-->

The first thing that comes to mind when you say virtualization in the world of computing is Virtualbox, VMWare and other virtualization software. And that's exactly what I'm going to talk about in this blog post but of course in relation to web development. 

###VirtualBox

Virtualbox is a free cross-platform virtualization platform. Cross-platform meaning you can run it on every major operating system (Windows, Linux, Mac). And yeah if you haven't catch it the first time its free so you can use it however you want without paying for it. 
Virtualbox allows you to run a copy of the operating system that you don't currently have on your machine. For example if you're currently using Ubuntu then you can run Windows or Mac on Virtualbox. And the same is true with whatever operating system you have currently installed physically.

This blog post isn't going to be a whole tutorial about Virtualbox. There's already a bunch of information about that in the [official documentation](https://www.virtualbox.org/manual/ch01.html) so use that if you don't know how to use Virtualbox yet. But one thing to keep in mind when using Virtualbox is that you should acquire an installer of the operating system that you want virtualize using Virtualbox just like you do when you want to install it on your machine. 


###Emulation Software

One subject that's related to Virtualization is Emulation. They're sort of similar but they're not. Basically the main difference is the environment (hardware) where the software runs. When you say emulation the environment doesn't necessarily have to be the same to that of the original piece of software that you're trying to run. For example when playing an [NDS](http://en.wikipedia.org/wiki/Nintendo_DS) game in your computer. That is possible through the use of an emulator. Your computer doesn't have the same hardware to that of an NDS but the emulator software makes it as if the game is running on an actual NDS hardware.

Whereas Virtualization is running a piece of software, in this case the operating system in the same type of environment. 

So why did I just go over the difference between Emulation and Virtualization? That's because emulation is another piece of this whole blog post. You can also use emulation software as a substitute if Virtualization isn't feasible in your case. 

Emulation software allows you to run software that you can only run on a specific operating system. For example if you only want to test out the website that you created in Internet Explorer and you're currently running Linux then you can use an emulation software instead of installing a copy of the Windows operating system on Virtualbox. Again I won't be walking you through how to install an emulation software. Instead I'll just provide you with some links to get you started:

- [Wine](http://www.winehq.org/) - windows software emulator for Linux, BSD, Solaris and Mac OS X.
- [Crossover](http://www.codeweavers.com/products/crossover-mac/) - windows software emulator for Mac.
- [Winebottler](http://winebottler.kronenberg.org/) - run windows-based programs on Mac.
- [Cygwin](http://www.cygwin.com/) - provides a unix-like environment and command-line interface for Windows.
- [Fink](http://www.finkproject.org/) - run unix-based software on Mac.

###Vagrant

Using Virtualbox or emulation software for testing the websites that you have created is nice but what if you need to test it out on a machine with exactly the same environment? Developers are known for making the excuse "It works on my machine" when the application that they have developed suddenly stops working or acts weird. With Vagrant you can now say goodbye to that excuse. What Vagrant allows you to do is create a virtual copy of a specific operating system and access and modify its files right from the host operating system (the operating system that you're currently running).
It also allows you to install software into the virtual operating system directly from your terminal through the use of `ssh`. 
But what is the advantage of this over using Virtualbox? Its true that you can do any of the things that I've mentioned above without using Vagrant. But the main advantage I think is the performance. Vagrant allows you to perform the installation of software and manipulating of files right from your host operating system so its a lot faster than booting up your virtual machine and doing your modifications from there. That is especially true if your machine doesn't have the most badass processor, solid state drive, and a bazillion of memory.  

####Installing Vagrant

Vagrant depends on Virtualbox in order to work so you need to have Virtualbox installed before installing Vagrant. The current version of Vagrant at the time of writing of this post is 1.4.3 and its only compatible with version 4.2.16 of Virtualbox. This poses some trouble for Linux users since the official repository for Virtualbox only serves the latest version of Virtualbox which is 4.3.6. For Windows and Mac users there's no problem since you can just download an older version of Virtualbox from [this page](https://www.virtualbox.org/wiki/Download_Old_Builds_4_2) and install it using the installer. For Linux users the installers for old versions are also available from that page and you can also try installing Virtualbox using those installers. But as for my personal experience I didn't have any luck with any of those installers. I get an error whenever I try to install it. Thankfully I found a good tutorial on [how to install Virtualbox 4.2.16](http://linuxg.net/how-to-install-virtualbox-4-2-16-on-ubuntu-linux-mint-debian-and-fedora/) on some of the most popular Linux distributions. If you didn't have any luck with the installers provided from the Virtualbox site then you might as well try that link.

Once you're done installing Virtualbox you can now download the Vagrant installer from the [Vagrant downloads page](http://www.vagrantup.com/downloads) just select the installer that applies for you then install it. The installer will automatically add `vagrant` to your system path so you can simply use the `vagrant` command from your terminal without having to specify the path.

###Using Vagrant

After installing Vagrant you should already have access to the `vagrant` command from your terminal. You can execute the following command to test out if Vagrant was successfully installed:

```
vagrant --version
```

If it returns something like `vagrant version 1.2.2` then Vagrant was successfully installed on your machine.

The next step is a pretty long wait if you do not have a fast internet connection and the server that is serving the vagrant box files are busy. As for me it took a whole afternoon (around 6-8 hours) for the vagrant box to be fully downloaded.

But before we move on I believe a little background on what a vagrant box is is necessary. Basically vagrant boxes are virtual copies of an operating system. Pretty much like the `.vdi` or `.vmdk` file that's being created by Virtualbox or VMWare when you create a virtual machine. 

####Adding Vagrant Boxes

Vagrant boxes can be downloaded from [vagrantbox.es](http://www.vagrantbox.es/). You can add a box to Vagrant by executing the following command from the terminal:

```
vagrant box add box_name url_from_vagrantboxes
```

Where `box_name` is any machine friendly title (use underscores or dashes instead of spaces) that you want to use to refer to your box later on. And the `url_from_vagrantboxes` is the URL that you get from the vagrantboxes site. For this tutorial were going to work with the Ubuntu precise 32 box:

```
vagrant box add precise32 http://files.vagrantup.com/precise32.box
```

After executing the command above you might want to go out a bit or watch a whole season of your favorite TV show unless your download speed is blazingly fast.

####Vagrant Box Configuration File

Once that's done you can now start using the box as a template for the machine that you need to build. First create your working directory and open up a terminal and execute the following:

```
vagrant init
```

This will create a vagrant init file. This file will contain the configuration for the box that you're going to build. The `Vagrantfile` generated by using `vagrant init` will just contain comments and some sample configuration. You can read through those comments if you want. But to avoid confusion simply create your own vagrant configuration file by creating a new file and putting the following contents:

```
Vagrant.configure("2") do |config|
  config.vm.box = "precise32" #the box_name that you used earlier
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.network :forwarded_port, guest: 80, host: 8080
end
```

Just name the file `Vagrantfile` so it can be recognized by vagrant when you execute any vagrant commands. Note that for the value for the `config.vm.box` it should be the `box_name` that you used earlier when you executed the `vagrant box add` command. If you're not sure what the name of your box is then simply execute `vagrant box list` to list all the boxes that's currently available on your machine. The `config.vm.box_url` is the url in which vagrant will download the box if it hasn't already been installed in your machine. We already installed the box earlier so vagrant will simply ignore this option. The last setting is the `config.vm.network` this simply tells vagrant to forward port 80 from the guest machine to port 8080 on the host machine. I'll explain more on this later.

Now you can execute `vagrant up` to initialize the box. You can see something similar to the following when vagrant has successfully brought up the box:

![vagrant up](/images/posts/whirlwind_tour_virtualization/vagrant-up.png)

Once this is executed for the first time you will notice that vagrant automatically creates a virtual machine on virtualbox:

![virtual machine](/images/posts/whirlwind_tour_virtualization/vagrant-box.png)

You can perfectly access this machine from virtualbox if you want to do anything manually from the guest operating system.

####Logging in to the box

Next execute `vagrant ssh`. This will allow you to login to the box. After executing that you will see something similar to the following:

![vagrant ssh](/images/posts/whirlwind_tour_virtualization/vagrant-login.png)

####Installing Software

Now you can run wild and go crazy. Install all the applications that you need to install. As for me I'm primarily working on a LAMP (Linux, Apache, MySQL, PHP) stack so I'm going to install PHP, MySQL, and Apache on this box. But first we need to download the package lists from the software repositories and update the existing ones to get information on the latest versions of packages and their dependencies. You can do that by executing the following command:

```
apt-get update
```

Once that's done we can now install the things that we need:

```
echo "Y" | apt-get install -y apache2 
echo "Y" | apt-get install curl
echo "Y" | apt-get install libcurl3 php5-curl
echo "Y" | apt-get install php5
echo "Y" | apt-get install libapache2-mod-php5
echo "Y" | apt-get install mysql-server
echo "Y" | apt-get install php5-mysql
```

Note that the `echo "Y"` here simply means that we supply `Y` as the answer if ever the installer asks for a response on whether to install the software or not. `Y` means yes in this case.

####Linking Up Directories

Once those are done delete the `/var/www` directory and all of its contents and create a soft link between the the `/vagrant` directory and the `/var/www` directory.  You can do that by executing the following command:

```
rm -rf /var/www
ln -fs /vagrant /var/www
```

You may ask we just deleted the `/var/www` directory and all of its contents so why are we creating a link to something that's already deleted? Good question! Making a soft link to a non-existent directory has the side-effect of creating that directory. We deleted it so we become the owner of that directory.

Once that's done you can now treat your working directory as if its the `/var/www` directory in your box. Don't believe me? You can go ahead and create a new file in your working directory (open up a new terminal since the current terminal is referring to your box):

```
touch newfile.txt 
```

Now go back to the terminal window in which you have logged in to your box using `vagrant ssh`. Go back two directories and enter the `vagrant` directory (this assumes that you're currently in the directory that's listing the `postinstall.sh` file when you execute the `ls` command) :

```
cd ../../vagrant
```

Now execute the `ls` command to list out all the files in that directory. You'll see that your `newfile.txt` is listed. Yes you can go ahead on go crazy and create a whole bunch of files through your host operating system in your working directory. Once you're satisfied come back to this blog post. I'll wait.

####Port-Forwarding

Now if you remember earlier on the `Vagrantfile` that you created we have this particular line:

```
config.vm.network :forwarded_port, guest: 80, host: 8080
```

What this does is forwarding the port 80 of the guest (your box) to port 8080 of your host operating system. As you might already know port 80 is the default port used by Apache so if we access `http://localhost:8080` from the browser in the host OS it will actually give us what's in `http://localhost:80` in the box. 
You can test it out by creating an `index.php` file on your working directory (host OS) and put the following contents:

```php
<?php
echo 'hello world from vagrant box';
?>
```

Now access `http://localhost:8080` from your browser and it will output 'hello world from vagrant box'.

####Logging out of the box

Once you're done playing with Vagrant you can now execute `exit` to logout from the box. After that you can either execute `vagrant halt` to shutdown the box or `vagrant suspend` to save the state of the machine, its like doing a hibernate so the box won't have to do a full boot when you access the box again. To work with your box again the `vagrant resume` command is used when you do `vagrant suspend` and the `vagrant up` is used when you do a `vagrant halt`. An important thing to remember is that you should do a `vagrant suspend` whenever you do not have any changes in your `Vagrantfile`. This makes it faster to get your guest machine running. However if you have some changes to your `Vagrantfile` you should do a `vagrant halt` for the changes to take effect when you do a `vagrant up`.

####Packaging the box

Another useful thing that you could do is packaging up the box so that you can share it with your team if you have any. This ensures that you have the same configuration with the rest of your team. This allows you to avoid any incompatibility issues like missing software or a different configuration of the `php.ini` file if you're primarily working with PHP.

To package up a box, navigate to your working directory and then execute the following command:

```
vagrant package --output package.box --vagrantfile Vagrantfile
```

Note that the command above will power of the box so you'll have to do `vagrant up` the next time you want to use the box even if you used `vagrant suspend` the last time you used it. The command above will also take a bit of time to finish depending on the amount of customization that you have done on the box. You may also end up with a larger `.box` file than the one that you previously downloaded from vagrantbox.es since all the software that you installed on the box will also be in the `.box` file that will be generated by vagrant.

Once vagrant is done you will have a `package.box` file under your working directory. You can then share this file along with the `Vagrantfile` to the rest of your team so that they can make use of the box. Another team member can just create his working directory and then copy the `package.box` file to that directory and then execute the following command:

```
vagrant box add box_name package.box
```

Be sure to change the `box_name` to a more recognizable name. You can also tell your team mate to just name it to be the same as the name of the box that you originally created so they won't need to update the `Vagrantfile` to use the new box name.

Once that's done they can just use `vagrant up` to boot up the box.

####Destroying the Box

If you want to delete a box (note that box in this case refers to the virtual machine that is generated when you executed `vagrant up`)  you can execute the following from your working directory:

```
vagrant destroy
```

This will delete the virtual machine and free up all the resources (hard disk space, memory, etc.) that it consumed when you created it.

####Removing the Box

If you want to delete a box (note that box in this case refers to the box that is created when you executed `vagrant box add`, in other words the box where your box originated from) execute the following command:

```
vagrant box remove box_name provider
```

Where the `box_name` refers to the name that you used when you created the box using `vagrant box add box_name`. And the provider refers to the virtualization software. If you do not know the box name and the provider simply execute `vagrant box list`. This will list out all the vagrant boxes installed on your machine. The one enclosed in parenthesis is the provider. In our case its virtualbox.

###Conclusion

Virtualization is a great way to experiment on different technologies if you want to avoid messing up your current system configuration. Its also a good way to test out your web projects on different machines without having to install it physically on your current machine.

###Resources

- [Virtualbox](https://www.virtualbox.org/)
- [Vagrant Documentation](http://docs.vagrantup.com/v2/)
- [Vagrant Boxes](http://www.vagrantbox.es/)
- [Rove](http://rove.io/) - you can use this for easily creating Vagrant files