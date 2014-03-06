---
layout: post
title: "A Whirlwind Tour of Web Developer Tools: Package Managers"
date: 2014-03-17 12:10
comments: true
categories: [tools, package-managers]
published: false
---

In this part of the series I'll walk you through package managers. I believe the definition available at [Wikipedia](http://en.wikipedia.org/wiki/Package_management_system) really gives a good overview on what package managers are:

{% blockquote %}
In software, a package management system, also called package manager, is a collection of software tools to automate the process of installing, upgrading, configuring, and removing software packages for a computer's operating system in a consistent manner. It typically maintains a database of software dependencies and version information to prevent software mismatches and missing prerequisites.
{% endblockquote %}

In simple terms package managers make it easy to install and modify software. In this blog post we'll be walking through some of the package managers available for Linux, Mac and Windows. And also package managers for easily installing front-end dependencies like jQuery or Twitter Bootstrap.

####Advanced Package Tool

Advanced Package Tool is the package manager used in Ubuntu and other Debian based Linux Distributions. You can use it to install new software, upgrade existing software or updating the package list index.


#####Searching for Packages

You can search for packages using the following command:

```
apt-cache search package_name
```

The `package_name` here doesn't have to be exact as the package manager itself will list out all possible matches and not exact one's.  So for example if you're trying to install filezilla:

![apt-cache search](/images/posts/2014-02-25-a-whirlwind-tour-of-web-developer-tools-package-managers/apt-cache-searchfilezilla.png)

An alternative for doing a search is directly addressing a specific package from the terminal. So if you want to use install `php` you simply execute the following command:

```
php
```

If the package which adds this specific command to your system path is not installed yet. Apt will make a suggestion on which package to install along with the command on how to install it.

#####Installing Packages

To install a package all you have to do is execute `sudo apt-get install` followed by the name of the package that you want to install:

```
sudo apt-get install filezilla
```

#####List Package Dependencies

Dependencies are the packages that needs to be installed before you can use the package that you want to install. These are installed by default so you won't really need to install them manually. If you want to know the dependencies of a specific package:

```
apt-cache depends package_name
```

#####Removing Packages

To remove installed packages:

```
sudo apt-get remove filezilla
```

If you also want to remove the configuration files for a specific package:

```
sudo apt-get remove --purge package_name
```

#####Updating Package List

To download the package lists from the repositories and updates those to get information on the most recent versions of packages and their dependencies:

```
sudo apt-get update
```

#####Upgrading Installed Packages

To upgrade all existing packages:

```
sudo apt-get upgrade
```

To upgrade a specific package:

```
sudo apt-get upgrade package_name
```

Executing the command above will list out all the available upgrades to the package. Just select `y` to install the upgrades.

#####Alternatives

If you are using a Linux distribution that is not Debian based. You might want to use the following:

- zypper
- yum
- urpmi
- rpm
- dpkg

####Chocolatey

Chocolatey is a package manager for Windows. Its pretty much the equivalent of `apt-get` in Windows.

To install chocolatey, open up the command line and execute the following command:

```
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%systemdrive%\chocolatey\bin
```

What this does is to download the chocolatey installer and copies it into the Windows path so it can be called from anywhere.

Here's a list of all the available [chocolatey packages](https://chocolatey.org/packages). 
As you can see, chocolatey is built with programmers in mind so there are packages for easily installing git, nodejs, ruby, python, phantomjs, vim and any other developer tool that you can think of. For your convenience, I've compiled some development tools and their corresponding install command below:

**Sublime Text 2**

```
cinst sublimetext2
```

**Fiddler**

```
cinst fiddler
```

**Node JS**

```
cinst nodejs
```

**Console2**

```
cinst Console2
```

**Putty**

```
cinst putty
```

**Git**

```
cinst git.install
```

**Ruby**

```
cinst ruby
```

**Python**

```
cinst python
```
 
**Vim**

```
cinst vim
```

**Mercurial**

```
cinst hg
```

**Curl**

```
cinst curl
```

**Wget**

```
cinst Wget
```

**Yeoman**

```
cinst Yeoman
```

**Easy Install**

```
cinst easy.install
```

**Cygwin**

```
cinst Cygwin
```

**Expresso**

```
cinst expresso
```

**Vagrant**

```
cinst vagrant
```

**MySQL**

```
cinst mysql
```

**PHP**

```
cinst php
```
 
**Everything**

```
cinst Everything
```

####Homebrew

Homebrew is a package manager for Mac OS. You can install it by executing the following command from the terminal:

```
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
```

Note that the command above uses ruby. Ruby is already pre-installed on Mac OS so you can just execute it without installing Ruby.

Once homebrew is installed you can then start installing packages by using the `brew` command. So for example if you want to install git:

```
brew install git
```

Here's a [list of homebrew packages](https://github.com/Homebrew/homebrew/tree/master/Library/Formula) that you can install. Note that you will have to omit the `.rb` extension. So when installing the `wget.rb` package you only have to execute the following command:

```
brew install wget
```

####NPM

NPM is the package manager that comes with Node. Its commonly used for installing JavaScript tools that runs on the command line such as Grunt, Bower and Yeoman. Or JavaScript libraries or frameworks that you can use on your project such as Express, Underscore or Socket.IO.

#####Installing Node

Like I said earlier NPM comes with Node so you have to install Node before you can use NPM. 
The first choice for installing Node would be to [download the installer](http://nodejs.org/download/) that was built for the operating system that you're using. If that doesn't work you can try any of the methods below:

In Linux you can install Node from the terminal by executing the following commands:

```
sudo apt-get install python-software-properties python g++ make
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install nodejs
```

For Windows, you can install [chocolatey](https://chocolatey.org/) then install Node by executing the following command:

```
cinst nodejs
```

For Mac OS, you install [homebrew](http://brew.sh/) then install Node by executing the following command:

```
brew install node
```

If all else fails, be sure to do a google search on each error that pops out and follow through any solution that you might find. 

#####Installing NVM

Another option would be to install Node using NVM (Node Version Manager). A bash script that allows you to install and manage multiple versions of Node. Note that the following method requires Git to be installed, so if you don't have it already installed on your machine you can download the available installers from the [Git Download Page](http://git-scm.com/downloads). After downloading check out the [guide on how to install git](http://git-scm.com/book/en/Getting-Started-Installing-Git).

Going back to installing nvm. You can do that by executing the following command:

```
curl https://raw.github.com/creationix/nvm/master/install.sh | sh
```

The command above copies nvm binaries into your system path so you can just call `nvm` from any directory after the installation is done.

You can install any version of Node by using the `nvm install` command:

```
nvm install 0.10
```

Once the installation is done you can then tell nvm to use the specific version that you installed:

```
nvm use 0.10
```

#####Using NPM

**Installing Packages Locally**

Once that's done you can now install packages via npm by using the following command:

```
npm install package_name
```

This installs the package under the `node_modules` folder in your working directory. 

You can install packages using the above method but the preferred method is to create a `package.json` file in which you specify all the dependencies of your current project:

```
{
    "name": "super-awesome-app",
    "version": "0.0.1",
    "private": true,
    "dependencies": {
      "express": ">=3.0.0",
      "jade": ">=1.1.5"
    }
}
```

Breaking it down:

- `name` - the name of your app, note that this should be a machine friendly name.
- `version` - the version of your app
- `private` - supplying a value of `true` tells npm that your app is private, therefore it shouldn't be listed in the npm registry. 
- `dependencies` - an object containing the name and version of packages in which your app depends. You can use the [npm website](https://www.npmjs.org/) to search for packages that you can install.

Once you have a valid `package.json` in the root of your project directory. You can just execute `npm install` from the root of your project directory. This will install all your dependencies under the `node_modules` folder:

![node modules](/images/posts/2014-02-25-a-whirlwind-tour-of-web-developer-tools-package-managers/node-modules.png)

The packages will be installed in their own folders. There's also the `.bin` folder where the executable file for each packages can be called.

**Installing Packages Globally**

If you want to install a specific package globally, simply add the `-g` option:

```
npm install -g package_name
```

This will install the package under the `/usr/local/lib/node_modules` directory or the `node_modules` directory of wherever node is installed. 

**Searching for Packages**

You can also search for packages using the `npm search`:

```
npm search grunt
```

This might take a while the first time you execute it since it will be downloading an index of all the packages that are available in the npm repository.

**Uninstalling Packages**

You can uninstall packages using the `uninstall` command:

```
npm uninstall moment
```

Be sure to add the `-g` option if you installed the package globally:

```
npm uninstall grunt -g
```

####Bower

Bower is the package manager for front-end dependencies of your app. Its specifically useful for easily installing libraries such as jQuery or Twitter Bootstrap. It is loader agnostic, which means that you can use any module loader such as AMD or CommonJS.

Bower is available from npm so you can install it via nvm:

```
npm install -g bower
```

A global install is recommended for bower so that you can use it from any project.

#####Installing Packages

Once bower is installed you can then start installing packages in your working directory by using the `bower install` command:

```
bower install package_name
```

The command above will install the latest version by default. If you want to install a specific version you do:

```
bower install package_name#version_number
```

If you're not sure about the name of a specific package that you're trying to install you can visit the [bower website](http://bower.io/search/) and search for it.

The command above will install the package under the `bower_components` folder by default. But if you want it to install somewhere else you can do so by creating a `.bowerrc` file. So for example if you want bower to install your apps dependencies under the `libraries` folder:

```
{
  "directory": "libraries"
}
```

Again there's more than one way to go with things. With bower you can also install your apps dependencies by creating a `bower.json` file where you will specify its dependencies. Note that this is very similar to that of the `package.json` file that we used earlier with npm, the only difference is that were requiring front-end dependencies:

```
{
  "name": "my-super-awesome-app",
  "version": "0.0.1",
  "dependencies": {
    "bootstrap": "~3.1.1",
    "moment": "~2.0.0",
    "jquery": "~1.10.2"
  },
  "private": true
}
```

#####Listing Installed Packages

You can also list out packages that are currently installed by using the `list` command:

```
bower list
```

This will list out all the packages and their dependencies:

![bower list](/images/posts/2014-02-25-a-whirlwind-tour-of-web-developer-tools-package-managers/bower-packages.png)

Inspecting the screenshot above you can see that bootstrap depends on jquery.
And sure enough when we open up the `bower.json` file inside the `bootstrap` directory we can see that `jquery` is listed under the `dependencies`:

```
{
  "name": "bootstrap",
  "version": "3.1.1",
  "main": [
    "./dist/css/bootstrap.css",
    "./dist/js/bootstrap.js",
    "./dist/fonts/glyphicons-halflings-regular.eot",
    "./dist/fonts/glyphicons-halflings-regular.svg",
    "./dist/fonts/glyphicons-halflings-regular.ttf",
    "./dist/fonts/glyphicons-halflings-regular.woff"
  ],
  "ignore": [
    "**/.*",
    "_config.yml",
    "CNAME",
    "composer.json",
    "CONTRIBUTING.md",
    "docs",
    "js/tests"
  ],
  "dependencies": {
    "jquery": ">= 1.9.0"
  }
}
```

Bower automatically installs the dependencies of each of your dependencies. Pretty neat!
Since we have specified `jquery` as a dependency under the `bower.json` file of our project bower already knows that it should install that version of jquery (`1.10.2`) instead of the one specified under the `bower.json` file under the `bootstrap` directory.


#####Updating Packages

You can also update installed packages using the `update` command. Be sure to update the `bower.json` file to use a later version of your apps dependencies and then execute the following command:

```
bower update
```

This will update all the installed packages in your project directory. You can also update specific packages by specifying the package name:

```
bower update bootstrap
```

#####Uninstalling Packages

You can also uninstall packages by using the `uninstall` command. This can take one or more packages. In the example below were uninstalling both `bootstrap` and `moment`:

```
bower uninstall bootstrap moment
```

####Bower and AMD

All of the previously mentioned features were good but what if we want to load up our dependencies asynchronously? Were pretty much out of luck with Bower since 

####Jam

Another front-end dependency package manager is Jam. What's nice about Jam is that it was built with script modularity in mind. It uses AMD (Asynchronous Module Definition) for loading up the dependencies of your app. 

Just like Bower you can install Jam using npm:

```
npm install -g jam
```

**Installing Packages**

You can install packages using the `install` command followed by the name of the package that you want to install:

```
jam install jquery
```

This will install your dependencies on the `jam` directory. Notice that a `require.config.js` and `require.js` file is also created. This is because Jam uses [requireJS](http://requirejs.org/) to asynchronously load your dependencies. This means that you can load your dependencies by requiring them instead of using script tags and specifying the source. The `require.js` file created by Jam is customized based on the packages that you have installed on your project directory. You'll have to include it first before trying to require your dependencies:

```
<script src="jam/require.js"></script>

<script>
  require(['jquery'], function ($) {
    $('body').text('Zup world!');
  });
</script>
```

Do note that installing a package using the method above isn't recommended since you will most likely have to install other packages as your project grows. The recommended method is creating a `package.json` file where you specify all your apps dependencies:

```
{
  "jam": {
    "packageDir": "public/vendor",
    "baseUrl": "public",
    "dependencies": {
    	"bootstrap" : "~2.3.2",
    	"jquery" : "~2.0.0",
    	"moment" : "~1.7.2",
	"underscore" : "~1.3.3"
    }
  }
}
```

The `packageDir` is where packages are installed.
The `baseUrl` is the directory in which to make relative package paths from.
The `dependencies` is where you specify the name and version of a package to install.
Once you're ready to install just execute the `jam install` command in the root of your projects directory.

If at a later time you decide to add another dependency you can just add it to the `package.json` file. In the example below were adding `knockout` version `2.2.0` as a dependency:

```
{
  "jam": {
    "packageDir": "public/vendor",
    "baseUrl": "public",
    "dependencies": {
    	"bootstrap" : "~2.3.2",
    	"jquery" : "~2.0.0",
    	"moment" : "~1.7.2",
	"underscore" : "~1.3.3",
        "knockout" : "~2.2.0"
    }
  }
}
```

Once you've added the new dependency simply execute the `jam install` command again. Jam will also update the `require.js` and `require.config.js` file to include your new dependency.

**Require.js File**

Inspecting the `require.js` file we can see that the following code has been added near the bottom of the file:

```
var jam = {
    "packages": [
        {
            "name": "jquery",
            "location": "jam/jquery",
            "main": "dist/jquery.js"
        }
    ],
    "version": "0.2.17",
    "shim": {}
};

if (typeof require !== "undefined" && require.config) {
    require.config({
    "packages": [
        {
            "name": "jquery",
            "location": "jam/jquery",
            "main": "dist/jquery.js"
        }
    ],
    "shim": {}
});
}
else {
    var require = {
    "packages": [
        {
            "name": "jquery",
            "location": "jam/jquery",
            "main": "dist/jquery.js"
        }
    ],
    "shim": {}
};
}

if (typeof exports !== "undefined" && typeof module !== "undefined") {
    module.exports = jam;
}
```

As you can see it contains the name, location and the main file of the packages that you installed. So that when you require them later on on your script it knows exactly where to find them and which file to load. If you're new to the concept of module loading be sure to check out the following resources:
 
- [Understanding RequireJS for Effective Module Loading](http://www.sitepoint.com/understanding-requirejs-for-effective-javascript-module-loading/)
- [Writing Modular JavaScript With AMD, CommonJS & ES Harmony](http://addyosmani.com/writing-modular-js/)

**Searching for Packages**

You can search for jam packages using the `search` command:

```
jam search package_name
```

You can also use the [jam packages page](http://jamjs.org/packages/#/) to look for packages to install.

**Uninstalling Packages**

You can uninstall packages by executing the following command:

```
jam remove jquery
```

This will also update the `require.config.js` and `require.js` file. Note that this won't update your `package.json` file so you have to remove the specific dependency in that file as well if you don't want it to get installed when you execute the `jam install` command later on. Also note that if the specific package that you are trying to remove is a dependency of another package jam won't remove it. Here's an example of removing a package in which another package is dependent on:

![jam remove error](/images/posts/2014-02-25-a-whirlwind-tour-of-web-developer-tools-package-managers/remove-error.png)

**Compiling Scripts**

Jam also allows you to compile your script and its dependencies using the `compile` command:

```
jam compile -i script -o main
```

Breaking the command down, we used the `-i` option to specify the input file. The input file is basically the main JavaScript file used by our app. Here's an example:

```
require(['jquery'], function ($) {
	$('body').text('zup world!');
});
```

The `-o` is where we specify the output. By default jam saves the output file on the directory where the `compile` command is called.

The `compile` command assumes that you have a `package.json` file where you specified the `baseUrl`. In the `package.json` file that we used earlier the `baseUrl` is set to `public`. This means that jam will look into the `public` directory for the `script.js` file. Note that we didn't have to specify the extension (`.js`) in the example since jam already assumes that the extension is `.js`.


####Browserify

Unlike npm, bower or jam its not really considered a full-fledged package manager since it doesn't allow you to install or manage packages. However it allows you to write node.js-style modules in the front-end.

Browserify is also preffered to be installed globally since you can use it on multiple projects:

```
npm install -g browserify
```

Once you're done installing you can then install the packages in which your app depends on:

```
npm install jquery
```

Then you can use the package that you just installed by requiring it into your main JavaScript file (`js/main.js`):

```
var $ = require('jquery');
$(function(){
	$('body').text('zup world from browserify!');
});
```

Note that you won't be able to run this on the browser just yet. You first have to compile it using browserify. Execute the following command on the root of your apps directory:

```
browserify js/main.js -o dist/js/main.js
```

The command above assumes that you have your main JavaScript file inside the `js` directory which is under the root directory of your app. The `-o` option allows you to specify the output file. In this case the output file is under `dist/js/main.js`. This will be the file that you're going to link into the page where you plan to run the script (`index.html`):

```
<script src="dist/js/main.js"></script>
```

When you run this file in the browser you will see the following output:

```
zup world from browserify!
```

If you want to minify the output of browserify you can also install uglify js:

```
npm install -g uglify-js
```

Then pipe browserify's output to `uglify-js`:

```
browserify js/main.js | uglify-js > dist/js/main.js
```

Note that in the above command we didn't supply the `-o` option so that browserify will simply return the output as a string. We then piped it to the `uglify-js` command and specifying the output file from there.

Browserify is a good alternative to RequireJS for managing the front-end dependencies of your app.

####Component

Lastly there's component, a package manager that allows you to write modular commonjs components.

To install component:

```
npm install -g component
```

**Searching for Components**

You can then find a list of components that you can install from this [page](https://github.com/component/component/wiki/Components). Or use the `search` command to search for existing components that matches your query:

```
component search jquery
```

**Installing a Component**

Writing an app using component requires a `component.json` file to be created in the root of the app:

```
{
  "name": "component-tester",
  "description": "testing component",
  "dependencies": {
    "component/datepicker": "*"
  },
  "main": "main.js",
  "scripts": [
    "main.js"
  ]
}
```

The `component.json` file looks similar to the `package.json` and `bower.json` file that we've seen so far. Remember that the `name` should be a machine-friendly name. There's also a bit difference in the name of the dependencies. The convention used by component is `author/component` in order to avoid naming collisions. In the example above we only have one dependency which is the `component/datepicker`. This allows us to add a datepicker on text fields.
We also have to specify the main JavaScript file (`main.js`). There's also the `scripts` where we specify the other scripts that is used by the app. In this case we only have the main JavaScript file so its the only file that we put in.

Once you're done building the `component.json` file execute the `install` command to install your dependencies:

```
component install
```

This will install your dependencies under the `components` directory:

![components directory](/images/posts/2014-02-25-a-whirlwind-tour-of-web-developer-tools-package-managers/components.png)

As you can see from the screenshot above component creates a bunch of folders under the components directory. When you open up the folders you will see that there's a `component.json` file in each of them. Here's the contents of the `component.json` file under the `component/aurora` directory:

```
{
  "name": "aurora",
  "repo": "component/aurora",
  "description": "Aurora theme for Calendar, Popover, and Tip",
  "version": "0.0.1",
  "keywords": [
    "aurora",
    "theme",
    "bundle"
  ],
  "dependencies": {
    "component/aurora-popover": "*",
    "component/aurora-calendar": "*"
  },
  "development": {}
}
```

As you can see it also specifies its on dependency. There's also an additional `repo` property, this is the Github repository in which the component is hosted. To access it from the browser all you have to do is prefix it with github.com/{repo}.

Checking out each of the dependencies you can see that they're also installed on your `components` directory each with their own assets (stylesheets, scripts and images).

And that is the philosophy behind component. Splitting up packages into multiple distinct modules. This encourages code-reuse. This means that you will be able to easily import and add various dependencies in your app. But only those that are really needed. This means that a component can comprise of many different components that represent a single module.

Going back to our example. In the `main.js` file put in the following code:

```
var picker = require('datepicker');
var el = document.querySelector('[name=date]');
picker(el);
``` 

What this does is requiring the `datepicker` component that we installed earlier and transforms all the elements which has a `name` of `date` into a date picker.

Once you're done with that execute the `build` command:

```
component build
```

This will tell component to build the components that you installed. In simple terms this brings in all the components together in a single file. One main file for each file type. By default component saves these files into the `build` directory of your app. So the main stylesheet will be named `build.css` and the main script file will be named `build.js`. You can then use it from any page in your app:

```html
<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>component test</title>
	<link rel="stylesheet" href="build/build.css">
</head>
<body>
	<input type="text" name="date" id="birthday" placeholder="Pick a date">
	<script src="build/build.js"></script>
	<script>
	require('component-tester');
	</script>
</body>
</html>
```

As you can see from the code above we're calling up what's in our main JavaScript file (`main.js`) by requiring it into the page:

```
require('component-tester');
```

The name here is basically the name that you used in your `component.json` file earlier.


###Conclusion

That's it! In this blog post we've gone over some of the package managers that we can use to easily install and manage software. We've also gone over some of the front-end package managers. We have barely scratch the surface in this blog post. The next step would be to find a way in which these package managers will fit into your current workflow. Or you can also look at how to automate the building of the final script so you won't have to manually build the dependencies together with the main script of your app.

###Resources

- [Package Managers: An Introductory Guide For The Uninitiated Front-End Developer](http://tech.pro/tutorial/1190/package-managers-an-introductory-guide-for-the-uninitiated-front-end-developer)