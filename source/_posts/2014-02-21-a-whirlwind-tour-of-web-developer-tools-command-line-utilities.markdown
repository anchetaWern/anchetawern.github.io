---
layout: post
title: "A Whirlwind Tour of Web Developer Tools: Command Line Utilities"
date: 2014-03-08 14:45
comments: true
categories: [tools, command-line]
published: true
---

In this part five of the series A Whirlwind Tour of Web Developer Tools I'll walk you through some of the tools that you can use in the command line.  But before we dive in to some of the tools lets first define what a command line is. According to [Wikipedia](http://en.wikipedia.org/wiki/Command-line_interface):

{% blockquote %}
A command-line interface (CLI), also known as command-line user interface, console user interface, and character user interface (CUI), is a means of interacting with a computer program where the user (or client) issues commands to the program in the form of successive lines of text (command lines).
{% endblockquote %}

So the command line is basically an interface where you can type in a bunch of commands to interact with the computer.

<!--more-->

###Command Line Basics

Before we jump into the tools its important that we first understand the basics of using the command line. To access the command line in Linux press `ctrl + alt + t` on your keyboard. For Mac just look for the terminal from your menu. And for Windows just press `window + r` and then type in `cmd` then press `enter`.

####Commonly used Commands

Here are some of the commands that you'll commonly used on a day to day basis:

- **cd** - change directory
- **mkdir** - create a new directory
- **rmdir** - delete an existing directory
- **touch** - create an empty file
- **pushd** - push directory
- **popd** - pop directory
- **ls** - list files in a specific directory
- **grep** - find specific text inside files
- **man** - read a manual page
- **apropos** - lists outs commands that does a specific action
- **cat** - print out all the contents of a file
- **less** - view the contents of a file (with pagination)
- **sudo** - execute command as super user
- **chmod** - modify the file permissions
- **chown** - change file ownership
- **find** - find files from a specific directory
- **pwd** - print working directory
- **history** - returns a list of the commands that you have previously executed
- **tar** - creates a tar archive from a list of files

If you are on Windows some commands might not be available to you. The solution would be to either switch to Linux, I definitely recommend Linux Mint or Ubuntu if you're planning to switch. Or if you want to stick with Windows you can install [Cygwin](http://www.cygwin.com/) or the [GNU utilities](http://unxutils.sourceforge.net/) for Windows.

I won't go ahead and provide you with a tutorial on how to use the commands above. There's tons of tutorials out there so use Google to your advantage. You also have the `man` command to help you out. Here's how to use the `man` command:

```
man cd
```

This will output all the information related to the `cd` command and how to use it.
The `man` command is useful if you already know the name of the command. But in case you do not already know you also have access to the `apropos` command which lists out commands that matches a specific action. Here's how to use it:

```
apropos delete
```

Executing the command above produces an output similar to the following:

![apropos](/images/posts/2014-02-21-a-whirlwind-tour-of-web-developer-tools-command-line-utilities/apropos.png)

As you can see you can pretty much scan through the results and determine the command that you need to use based on the description provided.  So if you want to delete a file you can just call the `unlink` command.

####Aliases

Once you've gotten comfortable with the default commands you can start using shortcuts in order to make typing commands faster and easier. You can add aliases by creating a `.bash_aliases` file inside your home directory then add contents similar to the following:

```
alias subl='/usr/bin/subl'
alias c='clear'
alias install='sudo apt-get install'
alias cp='cp -iv'
alias mv='mv -iv'
alias md='mkdir'
alias t='touch'
alias rm='rm -i'
alias la='ls -alh'
alias web-dir='cd ~/web_files'
alias e='exit'
alias s='sudo'
alias a='echo "------------Your aliases------------";alias'
alias ni='sudo npm install'
alias snemo='sudo nemo'
alias gi='git init'
alias ga='git add'
alias gc='git commit -m'
alias gca='git commit --amend -m'
alias gu='git push'
alias gd='git pull'
alias gs='git status'
alias gl='git log'
```

As you can see from the example above to add an alias simply put `alias` followed by the alias that you want to use, then `=` and followed by the path to the executable wrapped in quotes. If you do not know the path to the executable file you can use the `which` command followed by the command that you usually use. For example for the `less` command:

```
which less
```

It will then output the path to the executable file:

```
/usr/bin/less
```

This is the path that you can add in the specific alias.

###Command Line Tools

####Wget

Useful for pulling files from a server. For example you can use this to download a specific library or asset for your project into your current working directory:

```
wget http://cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.10/angular.min.js
```

The command above will pull the file from the URL that you specified and copy it into the directory where your current terminal window is opened.

####Curl

Curl is used for making HTTP request. I'd like to describe it as a browser but for the command line. You can do all sorts of stuff with Curl. For example you can use it to request a specific page from the web:

```
curl http://anchetawern.github.io
```

#####Basic HTTP Authentication

If the page uses basic HTTP authentication you can also specify a user name and a password. In the example below I am using Curl to request my recently bookmarked links from the delicious API:

```
curl -u username:password  https://api.del.icio.us/v1/posts/recent
```

#####Saving the Results to a File

This will return an XML string. If you want to copy the result to a file you can simply redirect the output to a file:

```
curl -u username:password  https://api.del.icio.us/v1/posts/recent > recent-bookmarks.xml
```

#####Getting Header Information

If you only want to get the header information from a specific request you can add the `-I` option:

```
curl -I http://google.com
```

This will output a result similar to the following:

```
Location: http://www.google.com/
Content-Type: text/html; charset=UTF-8
Date: Fri, 21 Feb 2014 10:16:19 GMT
Expires: Sun, 23 Mar 2014 10:16:19 GMT
Cache-Control: public, max-age=2592000
Server: gws
Content-Length: 219
X-XSS-Protection: 1; mode=block
X-Frame-Options: SAMEORIGIN
Alternate-Protocol: 80:quic
```

This is the same as the one that you see under the network tab in Chrome Developer Tools under the headers section.

#####Interacting with Forms

You can also perform actions on forms. So for example if you have the following form from a web page somewhere:

```html
<form action="form.php" method="GET">
	<input type="text" name="query">
	<input type="submit">
</form>
```

You can fill up the form and perform the action as if you're in a browser by simply getting the required inputs and supplying them from your command:

```
curl http://localhost/tester/curl/form.php?query=dogs
```

For forms which has its method set to `POST`. You can also make the request using curl. All you have to do is add a `--data` option followed by the name-value pair. With the name being the name assigned to the input and the value is the value that you want to supply:

```
curl --data "query=cats" http://loca/form.php?query=cats
```

#####Spoofing the HTTP referrer

You can also spoof the http-referrer when making a request:

```
curl --referer http://somesite.com http://anothersite.com
```

This reminds us that using the HTTP referrer as a means of checking whether to perform a specific action or not is really useless as it can be easily spoofed.

#####Follow Redirects

Curl also allows you to follow redirects. So for example if you're accessing a page which has a redirect like this:

```php
<?php
header('Location: anotherfile.php');
echo 'zup yo!';
?>
```

Simply using the following command will result in the execution of the `echo` statement below the redirect:

```
curl http://localhost/tester/curl/file.php
```

But if you add the `--location` option curl will follow the page that is specified in the redirect:

```
curl --location http://localhost/tester/curl/file.php
```

So the output of the command above will be the contents of the `anotherfile.php`.

#####Cookies

You can also supply cookie information on the requests that you make. So for example you are requesting a page which uses cookies as a means of determining if a user is logged in or not (note: you shouldn't use this kind of code in production):

```
<?php
$name = $_COOKIE["name"];
$db->query("SELECT id FROM tbl_users WHERE name = '$name'");
if($db->num_rows > 0){
	echo 'logged in!';
}else{
	echo 'sorry user does not exist';
}
?>
```

To request from the page above just add the `--cookie` option followed by the cookies that the page needs:

```
curl --cookie "name=fred" http://localhost/tester/curl/cookie.php
```

If you need to specify more than one cookie simply separate them with a semi-colon:

```
curl --cookie "name=fred;age=22" http://localhost/tester/curl/cookie.php
```

####jq

If you normally work with web API's in your job, you might find the jq utility useful. What this does is formatting JSON strings, it also adds syntax highlighting so they become more readable.  To install jq all you have to do is download the `jq` file from the [downloads page](http://stedolan.github.io/jq/download/) and then move it into your `bin` folder:

```
mv ~/Downloads/jq /bin/jq
```

After that you can start using jq to process JSON strings that comes from curl requests by simply piping it to the `jq` command. For example, we are making a request to the following file:

```php
<?php
$names = array(
	array(
		'fname' => 'Gon',
		'lname' => 'Freecs',
		'nen_type' => 'enhancement',
		'abilities' => array(
			'rock', 'paper', 'scissors'
		)
	), 
	array(
		'fname' => 'Killua',
		'lname' => 'Zoldyc',
		'nen_type' => 'transmutation',
		'abilities' => array(
			'lightning bolt',
			'thunderbolt',
			'godspeed'
		)
	),
	array(
		'fname' => 'Kurapika',
		'lname' => '',
		'nen_type' => array('conjuration', 'specialization'),
		'abilities' => array(
			'holy chain',
			'dowsing chain',
			'chain jail',
			'judgement chain',
			'emperor time'
		)
	),
	array(
		'fname' => 'Isaac',
		'lname' => 'Netero',
		'nen_type' => 'enhancement',
		'abilities' => array(
			'100-Type Guanyin Bodhisattva',
			'First Hand',
			'Third Hand',
			'Ninety-Ninth Hand'
		)
	),
	array(
		'fname' => 'Neferpitou',
		'lname' => '',
		'nen_type' => 'specialization',
		'abilities' => array(
			'Terpsichora',
			'Doctor Blythe',
			'Puppeteering'
		)
	)
	
);
echo json_encode($names);
```

Normally we would do something like this:

```
curl http://localhost/tester/curl/json.php
```

But this returns a result that looks like this:

![json string](/images/posts/2014-02-21-a-whirlwind-tour-of-web-developer-tools-command-line-utilities/json-string.png)

Piping the result to `jq`:

```
curl http://localhost/tester/curl/json.php | jq "."
```

We get a result similar to the following:

![jq formatted](/images/posts/2014-02-21-a-whirlwind-tour-of-web-developer-tools-command-line-utilities/jq.png)

Pretty sweet! But you can do much more than that, check out the [manual page](http://stedolan.github.io/jq/manual/) for the jq project for more information.

####Vim

Vim is a text-editor that is based on Vi, which is a text-editor that's pre-installed on common Linux distributions. But hey you might say that the main topic of this blog post is command-line tools why are we suddenly talking about text-editors here? Well its because Vim is tightly coupled with the terminal. It's like a terminal-text editor crossbreed. You can both execute commands and write code with it.

You can download Vim from the [Vim downloads page](http://www.vim.org/download.php) simply select the version that's applicable to the operating system that you're currently using. But if you're on Linux mint, Ubuntu or other Linux distributions that uses `apt-get` then you simply execute the following command from the terminal:

```
sudo apt-get install vim
```

There are lots of tutorials in the web that can help you with learning vim (I'll link to them later). But for now I'm going to give you a quick tutorial to get you started. 

First thing that you need to know is how to open up files with vim. You can do it by executing the following command:

```
vim file_that_you_want_to_edit.txt
```

You can also open up more than one file:

```
vim file1.txt file2.txt file3.txt
```

You can then switch between the files while on command mode. First list out the files that are currently opened in vim:

```
:ls
```

This will give you an output of the list of files with an id that you can use to refer to them when switching:

![list of files](/images/posts/2014-02-21-a-whirlwind-tour-of-web-developer-tools-command-line-utilities/ls.png)

To switch to `file2.txt` you can use the `:b` command followed by its id:

```
:b2
```

An alternative would be to use the file name itself:

```
:b file2.txt
```

Or you can also just switch to the next file:

```
:bn
```

Or switch to the previous file:

```
:bp
```

Second thing that you need to know is that vim has 3 modes:

- **command** - used for telling vim to do things. This is the default mode that vim is in when you open it. If you are on another mode other than the command mode you can press on `esc` to go back to the command mode. 
- **insert** - used for inserting things on the current file that you're working on. This is basically the text editor mode. You can only get to this mode when you are currently on the command mode. To get to this mode press the `i` key.
- **visual** - used for selecting text. Just like the insert mode you can only get to this mode when you are in command mode. To get to this mode press the `v` key.

**Basic Commands**

Here are some of the basic commands that you would commonly use when working with a file. Note that you can only type in these commands while you are in command mode.

- `:w` - save file
- `:wq` - save file and quit
- `:q!` - quit vim without saving the changes
- `u` - undo last action
- `ctrl + r` - redo
- `x` - delete character under the cursor
- `dd` - delete current line
- `D` - delete to the end of the line. The main difference between this and the `dd` command is that the `dd` command deletes even the line breaks but the `D` command simply deletes to the end of the line leaving the line break behind.

**Basic Navigation**

You can navigate a file while you're in the command mode or insert mode by pressing the arrow keys. You can also use the following keys for navigating but only when you are in command mode:

- `h` - left
- `l` - right
- `j` - down
- `k` - up
- `0` - move to the beginning of the line
- `$` - move to the end of the line
- `w` - move forward by one word
- `b` - move backward by one word
- `gg` - move to the top of the screen
- `G` - move to the bottom of the screen
- `line_numberH` - move to a specific line number
 
**Searching Text**

You can search for a specific text while you are in command mode by pressing the `/` key and entering the text that you want to search for and then press enter to execute the command. Vim will then highlight each instance of the text. You can move to the next instance by pressing the `n` key or `N` to go back to the previous instance. 

**Modifying Text**

You can modify text by switching to insert mode. You can switch to insert mode by first going to command mode (`esc` key) then press the `i` key.  Once you are on insert mode you can now start typing text just like you do with a normal text editor. While inside this mode and you want to select specific text to copy press the `esc` key to go back to command mode and then press the `v` key to switch to visual mode. From the visual mode you can then start selecting the text. To copy the text switch to the command mode then press the `y` key. To paste the copied text press the `p` key. You can do the same thing when you want to cut and paste. Simply use the `d` key instead of the `y` key.

**Vim Configuration**

You can use the `.vimrc` file to configure vim settings. It doesn't exist by default so you have to create it under the home directory:

```
touch ~/.vimrc
```

Some of the most common configuration that you would want to add:

```
syntax on
set number
set wrap
set tabstop=2
```

Here's a description of what each option does:

- **syntax on** - this enables syntax highlighting
- **set number** - this enables line numbers
- **set wrap** - this tells vim to word wrap visually
- **set tabstop** - you can use this to specify the tab size. In the example above I've set it to `2` so when you press tab vim will insert 2 spaces

**Resources for learning Vim**

Be sure to check out the resources below to learn more about Vim. Learning Vim is really a painful process since you have to memorize a whole bunch of commands and practice it like you're practicing how to play the piano. Learning Vim is not that easy, lots of practice is required before you can get productive with using it. You can easily get away with just using a text-editor when writing code but if you want some productivity boost then take the time to really learn Vim even if it is painful. Here are some resources for learning Vim:

- [Vim Tutorial and Primer](http://www.danielmiessler.com/study/vim/)
- [Vim Wikia Page](http://vim.wikia.com/wiki/Vim_Tips_Wiki)
- [Vimcasts](http://vimcasts.org/) - screencasts on Vim
- [25 Vim Tutorials, Screencasts and Resources](http://code.tutsplus.com/articles/25-vim-tutorials-screencasts-and-resources--net-14631)
- [Vim Interactive Tutorial](http://www.openvim.com/tutorial.html)
- [Learning Vim Progressively](http://yannesposito.com/Scratch/en/blog/Learn-Vim-Progressively/)
- [Vim Tips and Tricks](http://www.cs.swarthmore.edu/help/vim/home.html)
- **Vimtutor** - not really a website, this is the vim guide that comes with installing vim. You can access it by executing `vimtutor` from your terminal

####Siege

Siege is an HTTP load testing and benchmarking utility. You can mainly use this tool to stress test your web project with a bunch of requests to see how it holds up. Execute the following command to install siege:

```
sudo apt-get install siege
```

To use it you can execute:

```
siege -b -t60S -c30 http://url-of-the-web-project-that-you-want-to-test
```

The `-b` option tells siege to run the tests without delay. By default siege runs the test with a one second delay between each requests. Adding the `-b` option makes sure that the requests are made concurrently.

The `-t60S` option tells siege to run the tests in 60 seconds (60S). If you want to run it for 30 minutes you can do `30M`. Or `1H` for an hour. 

The `-c30` option tells siege to have 30 concurrent connections.

The last part of the command is the url that you want to test. If you only want to test out one url you can directly specify it in the command. But if you want to test out more than one url then you can create a new text file with the urls that you want to test out (one url per line) and then add the `-f` option followed by the path to the text file that you created to tell siege that you want to make use of a file:

```
siege -b -t60S -c30 ~/test/urls.text
```

Here's an example usage of siege:

![siege](/images/posts/2014-02-21-a-whirlwind-tour-of-web-developer-tools-command-line-utilities/siege.png)

Interpreting the results above:
 
- **transactions** - the total number of hits to the server.
- **availability** - This is the availability of your web project to users. Ideally you would want the availability to be 100%. Anything below it would mean that some users accessing your web project won't be able to access it because of the load. 
- **elapsed time** - this is the time you specified in your options when you executed siege. It wouldn't be perfect though, as you can see from the results above we only got 59.37 seconds but we specified 60 seconds.
- **data transferred** - the size of transferred data for each request
- **response time** - the average response time for each request
- **transaction rate** - the number of hits to the server per second
- **throughput** - the average number of bytes transferred every second from the server to all the simulated users
- **concurrency** - the average number of simultaneous connections
- **successful transactions** - the number of successful transactions
- **failed transactions** - the number of failed transactions
- **longest transaction** - the total number of seconds the longest transaction took to finish
- **shortest transaction** - the total number of seconds the shortest transaction took to finish 

####Sed

Sed is a tool for automatically modifying files. You can basically use this for writing scripts that does search and replace on multiple files. A common use case for developers would be for writing scripts that automatically formats source code according to a specific [coding standard](http://en.wikipedia.org/wiki/Coding_conventions).   

Yes you can do this sort of task using the built-in search and replace utility on text-editors like Sublime Text. But if you want something that lets you specify a lot of options and offers a lot of flexibility then sed is the tool for the job.
Sed is pre-installed on most Linux distributions and also on Mac OS so you won't really have to do any installation. For windows users there's also [Sed for Windows](http://gnuwin32.sourceforge.net/packages/sed.htm) which you can install. 

Here's an example on how to use sed. For example you have the following file (`sed-test.php`):

```php
<?php
$superStars = array();
$rockStars = array();
$keyboardNinjas = array();
?>
```
And you want to modify all variable declarations to be all in lowercase. You would do something like:

```
sed 's/\$\([A-Za-z]*\([\$A-Za-z_,\s]*\)\)/$\L\1/' sed-test.php
```

Sed will then output the following result in the terminal screen:

```
<?php
$superstars = array();
$rockstars = array();
$keyboardninjas = array();
?>
```

To save the changes to the same file you need to do a little bit of a trick since sed doesn't have the functionality to commit the changes to the input file. The trick would be to temporarily save the results to a new file (`sed-test.new.php`) and then use `mv` to rename the new file (`sed-test.new.php`) to the old file name (`sed-test.php`) :

```
sed 's/\$\([A-Za-z]*\([\$A-Za-z_,\s]*\)\)/$\L\1/' sed-test.php > sed-test.new.php
mv sed-test.new.php sed-test.php
```

If you want to learn more about sed check out the following resources:
- [Sed - An Introduction and Tutorial](http://www.grymoire.com/Unix/Sed.html)
- [Getting Started with Sed](http://sed.sourceforge.net/local/docs/An_introduction_to_sed.html)

You can also check out the following related tools:

- [tr](http://www.tutorialspoint.com/unix_commands/tr.htm)
- [awk](http://www.grymoire.com/Unix/Awk.html) 


####Ruby Gems

There's also lots of command line tools in the Ruby world. And you can have access to those tools by installing Ruby. 

In Linux and in Mac OS you can install Ruby by using RVM (Ruby Version Manager). First make sure that all the packages are up to date by executing the following command:

```
sudo apt-get update
```

We will get RVM by using Curl so we also have to install it:

```
sudo apt-get install curl
```

Once curl is installed, download rvm using curl and then pipe it to `bash` so we can use it immediately right after the download is finished:

```
curl -L https://get.rvm.io | bash -s stable
```

Install Ruby version `1.9.3` using rvm. For this step you don't really have to stick with version `1.9.3`. If there is already a later and stable version available you can use that as well:

```
rvm install 1.9.3
```

Tell rvm to use Ruby version `1.9.3`:

```
rvm use 1.9.3
```

You can then install the latest version of `rubygems`:

```
rvm rubygems latest
```

For Windows users you can just use the [ruby installer for Windows](http://rubyinstaller.org/).

Once ruby gems is installed you can now install gems like there's no tomorrow. Here's a starting point: [Ruby Gems for Command-line Apps](http://www.awesomecommandlineapps.com/gems.html). On the next section there's a gem called `tmuxinator` that you can install to manage tmux projects easily.

####Tmux

Tmux or terminal multiplexer is an application that allows you to multiplex several terminal windows. It basically makes it easier to work on several related terminal windows. In Linux you can install tmux from the terminal by executing the following command:

```
sudo apt-get install tmux
```

For Mac OS you can install tmux through brew:

```
brew install tmux
```

And on Windows tmux is not really directly supported. You first have to install [cygwin](http://cygwin.org/) and then add [this patch](http://sourceforge.net/mailarchive/message.php?msg_id=30850840) to install tmux. Or if you don't want to go through all the trouble you can install [console2](http://sourceforge.net/projects/console/files/) which is a tmux alternative for Windows.

Once you're done installing tmux you can now go ahead and play with it. To start tmux first create a new named session:

```
tmux new -s name_of_session
```

This will create a new tmux session with the name that you supplied:
![tmux session](/images/posts/2014-02-21-a-whirlwind-tour-of-web-developer-tools-command-line-utilities/tmux.png)

You can then execute commands just like you do with a normal terminal window. 
If you want to create a new window press `ctrl + b` then release and then press `c`. This will create a new window under the current session:

![tmux new window](/images/posts/2014-02-21-a-whirlwind-tour-of-web-developer-tools-command-line-utilities/tmux-new-window.png)

As you can see from the screenshot above we now have two windows (see the text highlighted in green on the lower part of the terminal window on the left side). One is named `0:bash` and the other is `1:bash*`. The one with the `*` is the current window. 

You can rename the current window by pressing `ctrl + b` then release and then `,`. This will prompt you to enter a new name for the window. You can just press enter once you're done renaming it:

![tmux rename window](/images/posts/2014-02-21-a-whirlwind-tour-of-web-developer-tools-command-line-utilities/tmux-rename-window.png)

To switch between the windows you can either press `ctrl + b` then release and then the index of the window that you want to switch to. You can determine the index by looking at the lower left part of the terminal screen. So if you have only two windows opened the index can either be 0 or 1. You can also press `ctrl + b` then release and then `p` for previous or `n` for next window.

You can also further divide each window into multiple panes by pressing `ctrl + b` then release and then the `%` key to divide the current window vertically or the `"` key to divide it horizontally. This will give you a screen similar to the following:

![tmux panes](/images/posts/2014-02-21-a-whirlwind-tour-of-web-developer-tools-command-line-utilities/tmux-panes.png)

You can then switch between those panes by pressing `ctrl + b` then release and then the `o` key.

What's good about tmux is that it allows you to keep multiple terminal sessions and you'll be able to access them even after restarting your computer. To list out available sessions you can execute the following command:

```
tmux ls
```

This will list out all the sessions that you created using the `tmux new - s` command or simply `tmux`. You can then open up the specific session by executing the following command:

```
tmux attach -t name_of_session
```

If you no longer want to work with a particular session you can just do the following:

```
tmux kill-session -t name_of_session
```

Or if you want to kill all sessions:

```
tmux kill-server
```

There's also this ruby gem called [tmuxinator](http://rubygems.org/gems/tmuxinator) which allows you to create and manage complex tmux sessions easily. You can install it via ruby gems:

```
gem install tmuxinator
```

Or if you're like me and you installed Ruby via RVM:

```
rvmsudo gem install tmuxinator
```

You can then create project-based tmux sessions. To create a new project you can do:

```
tmuxinator open name_of_project
```

This will create a `name_of_project.yml` file under the `~/.tmuxinator` directory. You can then open up this file and modify the default configuration. For me I simply deleted the commented lines (except for the first one which is the path to the current file) and then specified the project path. In my case its the `octopress` directory under the home directory. Then under the `windows` the `layout` is `main-vertical`, this means that the panes that I will specify would be divided vertically.  There would be 2 panes, one is empty so I can just type in whatever commands I wish to execute and the other is `rake preview` which is the command for previewing an octopress blog locally:

```
# ~/.tmuxinator/blog.yml

name: blog
root: ~/octopress

windows:
  - editor:
      layout: main-vertical
      panes:
        - #empty
        - rake preview
```

To open up the project at a later time you execute the following:

```
tmuxinator start name_of_project
```

If you do not know the name of a specific project, you can list out all projects using the following command:

```
tmuxinator list
```

If you no longer wish to work with a project in the future:

```
tmuxinator delete name_of_project
```

####SSH

SSH can be used to login to remote servers. SSH is pre-installed on both Linux and Mac OS. But for Windows you can use the alternative which is [open SSH](http://sshwindows.sourceforge.net/) since SSH isn't installed on Windows by default. 


#####Logging in to remote server

Once you have SSH installed you can now login to a remote server by executing the following command:

```
ssh username@hostname
```

Where the username is the `username` given to you by your web host. While the `hostname` can be a domain name, public dns or an IP address. For [Openshift](https://www.openshift.com/) its something like: 

```
xxxxxxxxxxxxxxxxxxxxxxxxxxxx@somesite-username.rhcloud.com
```

Where `x` is a random string of number and letters.

Executing the `ssh` command with the correct username and hostname combination will prompt you to enter your password. Again, the password here is the password given to you by your web host.

#####SSH Keys

You can also make use of SSH keys to authenticate yourself to a remote server. This will allow you to login without entering your password. 

To setup an ssh key navigate to the `.ssh` directory:

```
cd ~/.ssh
```
 
If you don't have already one, create it by executing the following command:

```
mkdir ~/.ssh
```

Once you're done with that, check if you already have a private and public key pair in the `~/.ssh` directory:

```
ls
```

It would look something like `id_rsa` and `id_rsa.pub`. 
If you don't already have those 2 files generate it by executing:

```
ssh-keygen -t rsa -C "your_email@provider.com"
```

This generates the `id_rsa` and `id_rsa.pub` files using your email address as the label. You can also use other information as the label.

Next copy the public key (`id_rsa.pub`) into the remote server by using secure copy (`scp`):

```
scp -p id_rsa.pub username@hostname
```

Now open up a new terminal window and login to the remote server.

```
ssh username@hostname
```

Check if the `id_rsa.pub` has indeed been copied by using the following command:

```
ls -al id_rsa.pub
```

If it returns "there's no such file or directory" return to the other terminal window (local machine) and execute the `scp` command again.

Once that's done the next step is to copy all the contents of the `id_rsa.pub` file into the `authorized_keys` file inside the `.~/ssh` directory:

```
cat id_rsa.pub > ~/.ssh/authorized_keys
```

Next update the `/etc/ssh/sshd_config` file using either `vi` or `nanoc`:

```
vi /etc/ssh/sshd_config
```

Uncomment the line where it says `# AuthorizedKeysFile`, to uncomment all you have to do is remove the `#` symbol right before it. Vi is basically like vim so the key strokes that you use are pretty much the same. So first you place the cursor right above the `#` symbol then press `x` to delete the `#` symbol. And then press the `esc` key to go back to command mode and then type in `:wq` to save and quit editing the file:

```
AuthorizedKeysFile %h/.ssh/authorized_keys
```

Just make sure the path that its pointing to is the same path as the file that we updated earlier. 
The `%h` refers to the host so its basically the same as saying `~/.ssh/authorized_keys`.

Once all of that is done you can now test it out by logging in once again. Note that for the first time after the update is done it will still ask you the password. But for the next one's it will no longer ask you the password.

###Conclusion

That's it! The command line is a must-use tool for every developer. In this blog post we've covered the essentials of using the command line along with some tools that can help you become more productive when it comes to using it.
There's a lot more command line tools that I haven't covered in this blog post. I believe those tools deserves a blog post of their own so I'll be covering each of those in a future part of this series. For now I recommend that you check out the resources below for more command-line ninja skills.

###Resources

- [Command Line Crash Course](http://cli.learncodethehardway.org/book/)
- [Cool but Obscure Unix Tools](http://kkovacs.eu/cool-but-obscure-unix-tools/)
- [Command Line Fu](http://www.commandlinefu.com/commands/browse)
- [Powerful Command Line Tools for Developers](http://coding.smashingmagazine.com/2012/10/29/powerful-command-line-tools-developers)
- [Linux Terminal Command Reference](http://community.linuxmint.com/tutorial/view/244)
- [Mac OS Command Reference](http://ss64.com/osx/)
- [Windows Command Reference](http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/ntcmds.mspx?mfr=true)