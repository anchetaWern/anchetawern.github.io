---
layout: post
title: "A Whirlwind Tour of Web Developer Tools: Build Tools"
date: 2014-03-30 16:58
comments: true
categories: 
published: false
---

In this part seven of this series I'm going to walk you through build tools. As usual I'm going to summon a [Wikipedia page](http://en.wikipedia.org/wiki/Build_automation) to do the definition for me because I really suck at defining things:

{% blockquote %}
Build automation is the act of scripting or automating a wide variety of tasks that software developers do in their day-to-day activities including things like compiling computer source code into binary code, packaging binary code, running tests, deployment to production systems, creating documentation and/or release notes
{% endblockquote %}

In other words build tools makes developers life easier by automating mundane tasks. In the web development world we commonly use build tools to lint, test, minify and deploy source code.


####Test Project

Before we move on to actually playing with the build tools first let me discuss about the test project that we will be working with. The test project is a useless project in which we will use all of the build tools that I'm going to discuss in this tutorial.

```
test-proj
 - css
   - normalize.css
   - main.css
 - js
   - jquery.js
   - main.js
 - img
   - dfrag.png
   - hamatora.png
   - magis.jpg
   - spacedandy.png
 - dist
   - css
   - js
   - img
   - index.html
```

`test-proj` is our working directory. The first 3 folders (css, js, img) is pretty self-explanatory, that is where our project assets goes. The `dist` folder is where the processed files goes. And what I mean by processing is that all the css files will get minified and concatenated, the same is true with all the javascript files. Then the html will also get minified. Finally all the images will get compressed. So the idea is that the `dist` folder will have the processed version of same folders and files that are in the root of our working directory.

####Bash

First on the list is bash. With simple bash scripts you can actually do some pretty decent web development task automation.

#####Concatenation

You can concatenate the contents of files by using the `cat` command then passing in the name of the files to concatenate and then redirect its output to a non existent file. The `cat` command is primarily used for outputting all the contents of a file from the command line. But when passing in two or more files you get the effect of outputting the contents of both files. Here's an example:

```
cat jquery.js accounting.js > script.js
```

Since the `script.min.js` file doesn't exist yet it will have a side-effect of creating the file which contains the contents of both `jquery.js` and `accounting.js`.

The above script is fine but what if you want to concatenate the contents of a specific file type within a directory? Well its also fairly simple:

```
cat *.js > script.js
```

Note that the default behavior for the above command is that it will concatenate the contents of the files based on the filename so if you have `accounting.js` and `jquery.js` in the directory where you executed the command `accounting.js` comes first and then `jquery.js` is appended to it.

You can also add an alias on `.bash_aliases`:

```
alias min_js='cat *.js'
```

Then you can just call the alias and redirect the output to a filename that you want:

```
min_js > script.js
```

You can use bash with simple stuff like concatenating the contents of file. But if you want to do more automation you can use the tools the below. 
We won't use bash with the test project that I discussed earlier I just showed an example to you so that you'll know that bash can be used for simple automation stuff.

####Apache Ant

Next on the list is Apache Ant, the automation tool from the same guys who brought us Apache Web Server. Ant uses the  `build.xml` files to do its magic. So you basically specify what it needs to do in the `build.xml` file. Ant already comes with some [default tasks](http://ant.apache.org/manual/tasksoverview.html) that you can use but you can also create custom tasks.

#####Installing Ant

To install Ant on Ubuntu and other debian based Linux distributions:

```
sudo apt-get install ant
```

If you get a message similar to the following when executing an ant task:

```
unable to locate tools.jar
```

You might also need to install openjdk:

```
sudo apt-get install openjdk-7-jdk
```

On Windows you can [winant](https://code.google.com/p/winant/) which is an Ant installer specifically made for Windows. If that doesn't work out for you you can also follow the following tutorial on [how to install apache ant on windows](http://www.nczonline.net/blog/2012/04/12/how-to-install-apache-ant-on-windows/).

If you're on Mac OS X ant is already installed by default. If you don't already have it on your version of Mac you can also have it installed using [homebrew](http://homebrew.sh/):

```
brew install ant
```

#####Using Apache Ant

Once you're done installing Apache Ant you can check if its successfully installed by executing the following command:

```
ant -version
```

At the time of writing of this tutorial its in version 1.9.2.

To begin using ant create a `build.xml` file in the root of the test project that we talked about earlier. Once created paste in the following contents:

```xml
<?xml version="1.0"?>
<project name="Webdev task processor" default="init">
<target name="get_config">
    <property file="ant.properties" />
    <echo>Got the configuration!</echo>
</target>
<target name="concat_css">
    <concat destfile="${dist_dir}/css/style.css">
        <filelist id="files" dir="${css_dir}">
            <file name="normalize.css" /> 
            <file name="main.css" /> 
        </filelist>
    </concat>
</target>
<target name="concat_js">
    <concat destfile="${dist_dir}/js/script.js">
        <filelist id="files" dir="${js_dir}">
            <file name="jquery.js" />  
            <file name="main.js" /> 
        </filelist>
    </concat>
</target>
<target name="minify_css_js">
    <java jar="/usr/bin/yuicompressor.jar" fork="true">
        <arg value="${file}" />
        <arg value="-o" />
        <arg value="${file}" />
    </java>
    <echo>${file}</echo> 
</target>
<target name="minify_html">
    <java jar="/usr/bin/htmlcompressor.jar" fork="true">
        <arg value="index.html" />
        <arg value="-o" />
        <arg value="${dist_dir}/index.html" />
    </java>
    <echo>${file}</echo> 
</target>
<target name="minify_css" depends="concat_css">
    <antcall target="minify_css_js">
        <param name="file" value="${dist_dir}/css/style.css" />
    </antcall>
</target>
<target name="minify_js" depends="concat_js">
    <antcall target="minify_css_js">
        <param name="file" value="${dist_dir}/js/script.js" />
    </antcall>
</target>
<target name="delete_existing" depends="get_config">
    <delete dir="${dist_dir}" />
</target>
<target name="create_new" depends="delete_existing">
    <mkdir dir="${dist_dir}/css" />
    <mkdir dir="${dist_dir}/js" />
    <mkdir dir="${dist_dir}/img" />
</target>
<target name="minify_img">
    <taskdef name="optipng" classname="com.pensioenpage.jynx.optipng.OptiPNGTask" classpath="optipng-ant-task/build/optipng-ant-task.jar" />
    <optipng dir="img" todir="dist/img" />
</target>
<target name="init" depends="get_config,delete_existing,create_new">
    <mkdir dir="${dist_dir}" />
    <antcall target="minify_css" />
    <antcall target="minify_js"  />
    <antcall target="minify_html"  />
    <antcall target="minify_img" />
    <echo>Done!</echo>
</target>
</project>
```

Ok so that's a lot of xml, but don't worry since I'll walk you through what each line does.

The first line is where the xml version goes:

```
<?xml version="1.0"?>
```

If you're using html its basically the same as the doctype declaration:

```
<!doctype html>
```

What it does is telling ant want specific xml version we are working with.

Next is the project body. This is where you put all the task configuration for your project:

```
<project name="Webdev task processor" default="init">
</project>
```

In ant the actual tag that you use has a special meaning so using the `project` tag tells ant that we are working with a project. The `project` tag takes 2 attributes:  `name` and `default`. `name is basically the name that you want to give to your project. `default` is where you tell ant the name of the default task. In this case we give it a name of `init`. This means that when you execute `ant` from your working directory it will look for the `init` task and it will execute it.

######Directory Configuration

Next we create an ant task. We can do this by using the `target` tag. We can give a name to task by specifying a value for the `name` attribute, note that this has to be a machine friendly name (no special characters or spaces). Inside the task  we specify the property file to be `ant.properties`. This is the file where we need to put our directory configuration.

```
<target name="get_config">
    <property file="ant.properties" />
    <echo>Got the configuration!</echo>
</target>
```

In our test project the `ant.properties` file contains the following:

```
css_dir = css
js_dir = js
dist_dir = dist
```

So what were actually doing is giving a specific directory an alias that we can refer to later from our `build.xml` file.

Finally the `echo` tag is where we can specify text to output whenever this specific task is done executing.

######Concatenating Files

Next we create a task that will concatenate specific file types together. If you don't know what concatenating is its basically putting all the contents of specific files together. For css files we name the task `concat_css` and for javascript files it will be `concat_js`. Here's what we have for the `concat_js` task:

```
<target name="concat_js">
    <concat destfile="${dist_dir}/js/script.js">
        <filelist id="files" dir="${js_dir}">
            <file name="jquery.js" />  
            <file name="main.js" /> 
        </filelist>
    </concat>
</target>
```

Note that to ant there's really no special meaning to the name of the task so you can just give it any name. Just be sure to give a task a name that makes sense the moment you read it later on.

Ant already comes with a concatenation task so we can just refer to it from inside the task itself. The `concat` task takes up an attribute called `destfile`, this is the path to which the output file will be saved. In this case we are referring to the `dist_dir` that we declared earlier in our `ant.properties` file. You can refer to the config inside the `ant.properties` file by using the `$` and wrapping the actual config name with curly brackets `{}`. We specified our output file to be `script.js` so it will get created under our `dist/js` directory once the task is done executing:

```
<concat destfile="${dist_dir}/js/script.js">
</concat>
```

We can then specify a list of files to work with inside the `concat` task. This will be the list of files that the concat task will process. To tell ant that we are working with a list of files you can use the `filelist` tag. You can then specify the individual files using the `file` tag and giving it a `name` attribute that is the same as the actual name of the file that you want to process:

```
<filelist id="files" dir="${js_dir}">
    <file name="jquery.js" />  
    <file name="main.js" /> 
</filelist>
```

You can also use a more concised alternative:

```
<filelist dir="${js_dir}" files="jquery.js,main.js" />
```

If you do not care about the ordering of files when they get concatenated you can use the `fileset` tag. This allows you to specify a pattern for targetting specific file types under the directory that you specify. The example below will use all the javascript files inside the `js` directory as the input. You can also set the `casesensitive` attribute to `yes` to tell ant that you want to match for the exact pattern that you specified and it will be case sensitive. This means that it won't match files with the `.JS` extension:

```
<fileset dir="${js_dir}" casesensitive="yes" includes="*.js" />
```

Similarly the task for concatenating all the css files together has the same pattern:

```
<target name="concat_css">
    <concat destfile="${dist_dir}/css/style.css">
        <filelist dir="${css_dir}">
            <file name="normalize.css" /> 
            <file name="main.css" /> 
        </filelist>
    </concat>
</target>
```

######Minifying Files

Next is the task for minifying files. What minification does is remove all the whitespaces, comments and all other unnecessary characters from code. And what I mean by unnecessary is all the stuff that the computer doesn't need to run your script.

To keep our `build.xml` file dry we will create a generalized task in which other tasks that's specifically made for minifying css or javascript files will call. Think of this like declaring a function. So the name of the task will be `minify_css_js` to indicate that this is a generalized task that can be used later on to minify css or javascript files. 

```
<target name="minify_css_js">
    <java jar="/usr/bin/yuicompressor.jar" fork="true">
        <arg value="${file}" />
        <arg value="-o" />
        <arg value="${file}" />
    </java>
    <echo>${file}</echo> 
</target>
```

Inside it will be a `java` tag to tell ant that we want to execute a java class. In this case we want to use [yui compressor](http://yui.github.io/yuicompressor/). The yui compressor has an executable jar file that you can use to minify css or javascript files so its perfect for our needs. With the `java` tag we specify 2 attributes: the `jar` in which we pass in the location of the executable jar file and the `fork` attribute takes up a boolean value, specifying `true` will tell ant to execute the jar file in another java VM separate from the one that runs ant itself.

Before we move on further let's examine how the `yuicompressor.jar` file can be executed from the command line:

```
java -jar yuicompressor.jar script.js -o script.min.js
```

As you can see from the above command it takes up 2 arguments the input which is `script.js` and the name of the output file which is `script.min.js`.

Going back to the `minify_css_js` task we now have an idea what the following line does is basically the same as what we are doing when executing the command from the terminal. So the first `arg` tag is the input file, the second `arg` tag is for specifying the output option, and the third one is for the output file. As you can see we are using the same variable for the output and input file so this means that they will have the same filename. The value for the `file` variable will be supplied from the task that will call this task so you can think of it as the arguments for a function:

```
<arg value="${file}" />
<arg value="-o" />
<arg value="${file}" />
```

Next create the task that will minify css files. Give it a name of `minify_css`. It will take a `depends` attribute. This tells ant to execute the task that is specified as a value for this attribute first before executing this task. In this case this will tell ant to execute the `concat_css` task before executing this task. Inside it is the `antcall` tag, this tells ant to execute the task specified as the value for the `target` attribute, in this case this will execute the `minify_css_js` task that we created earlier. Inside it we can pass the arguments that the `minify_css_js` task needs to work. We can do that using the `param` tag. The value of the `name` attribute for the `param` tag should be the same as the value of the `value` attribute for the `arg` tag in the main task. And then the `value` attribute for the `param` task would be the actual file path to the minified css file:

```
<target name="minify_css" depends="concat_css">
    <antcall target="minify_css_js">
        <param name="file" value="${dist_dir}/css/style.css" />
    </antcall>
</target>
```

The task for minifying javascript file would have the same pattern:

```
<target name="minify_js" depends="concat_js">
    <antcall target="minify_css_js">
        <param name="file" value="${dist_dir}/js/script.js" />
    </antcall>
</target>
```

Next is the task for minifying the html. Its basically the same as the 2 previous tasks only this time we are directly specifying the values that we need for the input and output since we are using a different jar file (`htmlcompressor.jar`):

```
<target name="minify_html">
    <java jar="/usr/bin/htmlcompressor.jar" fork="true">
        <arg value="index.html" />
        <arg value="-o" />
        <arg value="${dist_dir}/index.html" />
    </java>
    <echo>${file}</echo> 
</target>
```

You can download the htmlcompressor jar file from [google code's html compressor download page](https://code.google.com/p/htmlcompressor/downloads/list).


######Compressing Images

Next is compressing images. Unlike the other tasks that we have used so far this will take a little bit of work. 

First you have to install [optipng](http://optipng.sourceforge.net/). 

In Ubuntu and other debian based Linux distribution you can install optipng by executing the following commands:

1.  `wget --quiet http://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.3/optipng-0.7.4.tar.gz`
2.  `tar xf optipng-0.7.3.tar.gz`
3. `cd optipng-0.7.4`
4. `./configure > /dev/null 2>&1`
5. `make > /dev/null 2>&1`
6. `cd ..` 
7. `cp optipng-0.7.3/src/optipng/optipng /usr/bin/`

The commands above will build optipng from source. Be sure to use the current version of optipng when executing the `wget` command. If you don't know what the current version is then visit the [official sourceforge page of the optipng project](http://optipng.sourceforge.net/).

For Mac OS X users you can install it with Homebrew:

```
brew install optipng
```

And for Windows you can simply download the Windows (32-bit) build for optipng then extract the `zip` file and then include the path to the `optipng.exe` file into your [environment path](http://kyokasuigetsu25.wordpress.com/2010/10/29/how-to-set-environment-variables/).

Next clone the [optipng ant task project](https://github.com/znerd/optipng-ant-task) using the following command:

```
git clone https://github.com/znerd/optipng-ant-task.git
```

Note that you must have git installed on your system to execute the command above. If you don't have git then just download the `zip` file from [their github page](https://github.com/znerd/optipng-ant-task) then extract it in your working directory.

After that `cd` into the cloned github repo:

```
cd optipng-ant-task
```

Then execute `ant jar`. This will create the `optipng-ant-task.jar` file under the `build` directory of the `optipng-ant-task`.

Once that's successful you can then create the corresponding task:

```
<target name="minify_img">
    <taskdef name="optipng" classname="com.pensioenpage.jynx.optipng.OptiPNGTask" classpath="optipng-ant-task/build/optipng-ant-task.jar" />
    <optipng dir="img" todir="dist/img" />
</target>
```

The only thing that you need to modify in the task above is the `dir` and `todir` attribute for the `optipng` tag. Those 2 attributes lets you specify the source path and destination path for the images.

If you have cloned or downloaded the optipng-ant-task under a different directory then you might also need to modify the value for the `classpath` attribute under the `taskdef` tag to include the actual path to the `optipng-ant-task.jar` file.

######Cleaning up 

Next is the task for cleaning up the `dist` directory. Apache ant already comes with a `delete` task so we can just call it directly by specifying the path to the directory that we want to delete in the `dir` attribute, in this case we just want to delete the `dist_dir`:

```
<target name="delete_existing" depends="get_config">
    <delete dir="${dist_dir}" />
</target>
```

######Recreating

After we delete the `dist` directory we would also need to create it back. The sole purpose of the task for deleting the `dist` directory and creating it again is to clean up all the files that are no longer needed. This can happen quite often when we change the dependencies of our project. Of course this task will depend on the the `delete_existing` task to be executed first. Again were using a built-in ant task called `mkdir` to create the `css` and `js` directories under the `dist` dir:

```
<target name="create_new" depends="delete_existing">
    <mkdir dir="${dist_dir}/css" />
    <mkdir dir="${dist_dir}/js" />
</target>
```

That's it! Once you're happy with your `build.xml` file you can just call `ant` in your working directory and ant will do its thing. If you want to learn more about ant be sure to check out the resources below.

#####Resources for learning Ant

- [Ant Manual](http://ant.apache.org/manual/index.html)
- [Automate your Projects with Apache Ant](http://code.tutsplus.com/tutorials/automate-your-projects-with-apache-ant--net-18595)
- [Building Web Applications with Apache Ant](http://www.julienlecomte.net/blog/2007/09/16/)


####Grunt

Another tool that we can use to automate mundane web development tasks is Grunt. Just like what the name sounds like Grunt is your friendly task runner that will do your bidding for you. Just tell it what specific tasks to run and it will do it for you. Here are some tasks that Grunt allows you to run:

- **linting** - this allows you to determine common errors in your code or check if follows a specific coding standard.
- **testing** - this allows you to run tests on your code.
- **compiling** - this allows you to compile languages such as Coffeescript into JavaScript, LESS or SASS into CSS, Mustache or Handlebars templates into JavaScript, etc. 
- **minifying** - this allows you to minify source code. Minifying is the process of removing unnecessary characters in a source code. Things such as whitespaces, line breaks, optional block delimiters and comments are removed by using minification.
- **concatenating** - this allows you to concatenate related source code into a single file. This improves performance because instead of requesting several files from the server there will be only one request made. Each requested file carries a certain amount of latency therefore minimizing the number of files requested means lesser latency this then leads to faster download times.
- **image compression** - this allows you to compress image sizes. Again this has something to do with improving performance.
- **benchmarking** - this allows you measure the performance of your website based on specific standards and best practices.
- **server** - this allows you to serve the files in your project so you can access it through your browser.
- **watcher** - watches changes in your project and automatically calls linting, minifying and concatenating tasks.

#####Installing Grunt

Before you can install grunt you first need to have [node.js](http://nodejs.org/download/) installed. Grunt is preferred to be installed globally so you can use it on all of your projects. That is specified by using the `-g` option. Execute the following command in your terminal to install grunt:

```
npm install -g grunt-cli
```

Note that you might need to prefix it with `sudo` or any command that allows you to run a specific command as an administrator if you get any errors when installing grunt.

#####Package.json

The `package.json` file is where we specify project details. Things such as the project name, version, author and dependencies can be added from this file. Here's an example `package.json` file:

```
{
  "name": "my-superawesomeproject",
  "version": "0.0.1",
  "author": "Hitler",
  "devDependencies": {
    "grunt": "~0.4.2",
    "grunt-contrib-watch": "~0.5.3",
    "grunt-contrib-htmlmin": "~0.2.0",
    "grunt-contrib-jshint": "~0.6.3"
  }
}
```

Note that if you're reading this 1 or more years later after the first time I published this be sure to use the current version of the plugins, a simple Google search will give you the version that you need. Better yet start with an empty `devDependencies` object and install the plugins by explicitly using their name. This ensures the the latest version is installed:

```
npm install grunt grunt-contrib-htmlmin grunt-contrib-jshint grunt-contrib-watch --save-dev
```

Going back to `package.json` file. Breaking it down:

- `name` - a machine-friendly name for your project.
- `version` - the version number of your project.
- `author` - you.
- `devDependencies` - the grunt tasks that you want to use in your project. 

Under the `devDependencies` we specified the task that we want grunt to use. The first one should be `grunt` as this is the main npm module. You can consider this the framework in which the plugins build upon. The current version as of the time of writing of this tutorial is `0.4.2` so we specified that. You can determine the grunt version installed by executing the following command:

```
grunt --version
```

This will output 2 versions of grunt. One for the `grunt-cli` and one for the core grunt. The version returned for the core grunt is what you need to input in your `package.json` file.

Once you're happy with your `package.json` file simply run `npm install` on your current working directory to install all the packages that you've specified under `devDependencies`.
After the installation you will have a `node_modules` folder created in the root of your working directory. It will have contents similar to the following:

![grunt tasks](/images/posts/2014-03-09-a-whirlwind-tour-of-web-developer-tools-build-tools/node-modules.png)

If you want to install more tasks you can visit the [grunt plugins](http://gruntjs.com/plugins) page. You can simply refer to the name when installing. Just prefix the name that you see from the plugins page with `grunt`. And be sure that you're running this in your working directory and add the `--save-dev` option to let npm know that it should update the `package.json` file to include the grunt plugin under the `devDependencies` after its done with the installation. In the example below were installing the `contrib-uglify`:

```
npm install grunt-contrib-uglify --save-dev
```

#####Gruntfile

The Gruntfile is were all the magic happens. This is where you specify all the tasks that grunt needs to do. Here's the `Gruntfile.js` that utilizes the packages that we installed above:

```javascript
module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    jshint: {
      options: {
        jshintrc: '.jshintrc'
      },
      all: ['Gruntfile.js', 'js/*.js']
    },
    htmlmin: {                                    
	dist: {                                    
	  options: {                                
	    removeComments: true,
	    collapseWhitespace: true,
            removeRedundantAttributes: true
	 },
	 expand: true,
	 src: ['*.html'],
	 dest: 'dist/'
       }
    },
    watch: {
      js: {
        files: [
          'js/*.js',
          'Gruntfile.js'
        ],
        tasks: ['jshint']
      },
      html: {
		files: [
			'*.html'
		],
		tasks: ['htmlmin']
      }
    }	
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-htmlmin');

  grunt.registerTask('default', ['watch']);
};
```

Ok so that's a bunch of code I've just thrown at you. But don't be intimidated I'll walk you through what it does line by line.

First we have the grunt wrapper. Every gruntfile should start with this particular code:

```
module.exports = function(grunt) {
  //all things grunt here
};
```

If you're familiar with node this is how custom functions is usually defined with node. This simply means that all of the code defined inside of it depends on the grunt module that we installed.

Next is the project configuration. We specify it inside the `initConfig` function:

```
grunt.initConfig({
  //project configuration here
});
```

Next specify the package file that were using:

```
pkg: grunt.file.readJSON('package.json')
```

This allows us to refer to the project details inside the gruntfile later on. An example would be using the package name as the filename for a JavaScript output file:

```
'<%= pkg.name %>.js'
```

You can also refer to other information that's available in your `package.json` all through the `pkg` variable:

- `pkg.author` - returns the author's name
- `pkg.version` - returns the project's version number

Just be sure to wrap it in ruby style template tags and wrap it in quotes if you want to use these values:

```
'<%= pkg.version %>'
```

As an additional note you can also apply this technique when referring to information inside the gruntfile itself. We can see this in action later.

Now were ready to actually give instructions as to what each task will do. 

######JSHint

First is the [jshint](https://github.com/gruntjs/grunt-contrib-jshint) task. This allows us to check the quality of our code against a specific coding standard. Things like always using identity (`===`) operator instead of the equality (`==`) operator when comparing values. 

Note that information about how to use a specific task is always available on the github page for a specific task. Here's the one for [jshint](https://github.com/gruntjs/grunt-contrib-jshint). Under the `jshint` task we have the following:

```
jshint: {
  options: {
     jshintrc: '.jshintrc'
   },
   all: ['Gruntfile.js', 'js/*.js']
}
```

Here's a breakdown of the `jshint` configuration:

- `options` - this is where you can specify all the options that jshint will use. In the example we just supplied `jshintrc` as the option because we want to be as portable as possible. Specifying `jshintrc` allows us to use a `.jshintrc` file as the source of configuration. Inside the `.jshintrc` file we can specify the following options:

```
{
 "camelcase": true,
 "curly": true,
 "eqeqeq": true,
 "plusplus": true
}
```

Breaking it down:

- `camelcase` - force all variable names to use camelCase or UPPER_CASE with underscores.
- `curly` - requires you to always put curly braces to wrap blocks even if its optional.
- `eqeqeq` - requires you to use `===` instead of `==` annd `!==` instead of `!=` when comparing values.
- `plusplus` - requires you to use alternatives to `++` when incrementing a value.

More information on the available options can be found [here](http://www.jshint.com/docs/options/).

Going back to our gruntfile under the jshint configuration we have the `all` attribute where we can specify an array of files or paths that we want to lint. In our example we want to lint `Gruntfile.js` and all the javascript files inside the `js` directory:

```
all: ['Gruntfile.js', 'js/*.js']
```

######HTML Min

Next we have the [HTML min](https://github.com/gruntjs/grunt-contrib-htmlmin) task. This allows us to compress HTML files by removing whitespaces, line breaks, comments and other unnecessary attributes. Here's the configuration that we used for htmlmin:

```
htmlmin: {                                    
	dist: {                                    
		options: {                                
			removeComments: true,
			collapseWhitespace: true,
                        removeRedundantAttributes: true
		},
		expand: true,
		src: ['*.html'],
		dest: 'dist/'
	}
}
```

Breaking it down:

- `dist` - this refers to distribution or production. With htmlmin you can specify different options for `dev` or `dist`. 
- `options` - these are the options for a specific environment. There are a number of options that we can use but I only chose `removeComments`,  `collapseWhitespace`, and `removeRedundantAttributes` for this particular project. This is because all the other options that are available can be dangerous. You know what I mean when you check out the [page for htmlmin](https://github.com/gruntjs/grunt-contrib-htmlmin).
- `expand` - allows you to use wildcards for `src` and `dest`.
- `src` - the directory in which the source HTML files are stored. In the example above were simply telling htmlmin to use all the html files in the current working directory as the source.
- `dest` - the directory in which all the files processed by htmlmin is saved.


######Watch

Lastly there's [watch](https://github.com/gruntjs/grunt-contrib-watch). This allows you to watch changes to specific files and automatically call up a specific grunt task when a file is updated. Here's the configuration for the watch task:

```
watch: {
  js: {
    files: [
      'js/*.js',
      'Gruntfile.js'
    ],
    tasks: ['jshint']
  },
  html: {
    files: [
    	'*.html'
    ],
    tasks: ['htmlmin']
  }
}
```

Breaking it down we can see that under the `watch` task we have defined `js` and `html`. This is a means of separating which specific tasks to run for a specific project asset. Under the `js` we can specify an array of file paths and files. In this case we have specified all the files under the `js` directory as well as the gruntfile. 

If you remember earlier we have done the same thing with the jshint task so if you don't want to repeat yourself you can also do something like:

```
files: '<%= jshint.all %>'
```

This passes whatever it is that's inside the `all` attribute under the `jshint` object.

Then under the `tasks` we can specify any number of tasks to execute targeting the files that we specified. In this case were simply going to execute the `jshint` task. By default the watch task executes the task that you specify whenever you hit `ctrl + s` on any targeted file.

Going back to the watch task, under the `html` we simply tell watch to target all the html files under the current working directory and the task to execute will be `htmlmin`.

Ok were almost done, the only thing left to do now is to let grunt know what specific tasks we want to load. We can do that using the `loadNpmTasks` command. 

```
grunt.loadNpmTasks('grunt-contrib-watch');
grunt.loadNpmTasks('grunt-contrib-jshint');
grunt.loadNpmTasks('grunt-contrib-htmlmin');
```

You can do it this way or install [load-grunt-tasks](https://github.com/sindresorhus/load-grunt-tasks). This allows you to automatically load whatever it is that's inside the `node_modules` directory of your current working directory.

You can install it by using the following command:

```
npm install --save-dev load-grunt-tasks
```

Once that's done you can just require load-grunt-tasks:

```
require('load-grunt-tasks')(grunt);
```

Instead of loading each task manually:

```
grunt.loadNpmTasks('grunt-contrib-watch');
grunt.loadNpmTasks('grunt-contrib-jshint');
grunt.loadNpmTasks('grunt-contrib-htmlmin');
```

Going back to running the tasks. After that we can just call it a day with just that and execute the watch task like this:

```
grunt watch
```

But if you're executing the same command frequently its best practice to tell grunt to use it as a default. You can do that by executing the `registerTask` function and specifying the default inside an array. Note that you can specify more than one task as the default one.

```
grunt.registerTask('default', ['watch']);
```

This allows you to just execute `grunt` and it will automatically run the watch task. Pretty neat!

You can also create aliases for specific grunt tasks using this method:

```
grunt.registerTask('hm', ['htmlmin']);
grunt.registerTask('jh', ['jshint']);
```

So when you want to execute the htmlmin task you just have to type in `grunt hm` instead of `grunt htmlmin`. But of course if your laziness doesn't permit even this then you can shove your alias inside the `.bash_aliases` file in your home directory.

#####Useful grunt plugins

Here are some useful grunt plugins:

######General

- [grunt-contrib-connect](https://github.com/gruntjs/grunt-contrib-connect) - starts a static web server
- [grunt-contrib-watch](https://github.com/gruntjs/grunt-contrib-watch) - run specific grunt tasks whenever project files are updated
- [grunt-autoprefixer](https://github.com/nDmitry/grunt-autoprefixer) - automatically add vendor prefix to css files
- [grunt-shell](https://github.com/sindresorhus/grunt-shell) - run shell commands

######Code Quality

- [grunt-htmlhint](https://github.com/yaniswang/grunt-htmlhint) - validates html files
- [grunt-contrib-csshint](https://github.com/gruntjs/grunt-contrib-csslint) - lint CSS files
- [grunt-contrib-jshint](https://github.com/gruntjs/grunt-contrib-jshint) - lint JavaScript files
- [grunt-plato](https://github.com/jsoverson/grunt-plato) - provides static analysis report
- [grunt-complexity](https://github.com/vigetlabs/grunt-complexity) - checks the complexity of your JavaScript code

######Testing

- [grunt-mocha](https://github.com/kmiyashiro/grunt-mocha)
- [grunt-contrib-jasmine](https://github.com/gruntjs/grunt-contrib-jasmine)
- [grunt-contrib-qunit](https://github.com/gruntjs/grunt-contrib-qunit)

######Performance Optimization

- [grunt-contrib-htmlmin](https://github.com/gruntjs/grunt-contrib-htmlmin)
- [grunt-contrib-cssmin](https://github.com/gruntjs/grunt-contrib-cssmin) - minify css files.
- [grunt-uncss](https://github.com/addyosmani/grunt-uncss) - removes unused css.
- [grunt-contrib-imagemin](https://github.com/gruntjs/grunt-contrib-imagemin) - for compressing images.
- [grunt-svg-min](https://github.com/sindresorhus/grunt-svgmin) - minifying svg images.
- [grunt-webp](https://github.com/somerandomdude/grunt-webp) - converts images to webp format.
- [grunt-contrib-uglify](https://github.com/gruntjs/grunt-contrib-uglify) - minify and concatenate javascript files.
- [grunt-closure-compiler](https://github.com/gmarty/grunt-closure-compiler) - can be used as an alternative to grunt-contrib-uglify. 
- [grunt-contrib-concat](https://github.com/gruntjs/grunt-contrib-concat) - concatenates files.

#####Resources for learning grunt

- [Official Grunt Getting Started Guide](http://gruntjs.com/getting-started)
- [Get Up and Running with Grunt](http://coding.smashingmagazine.com/2013/10/29/get-up-running-grunt/)
- [Writing an Awesome Build Script with Grunt](http://www.sitepoint.com/writing-awesome-build-script-grunt/)
- [Advanced Grunt Tooling](http://chrisawren.com/posts/Advanced-Grunt-tooling)

####Gulp

Gulp is the new kid on the block when it comes to running tasks. Its basically an alternative to Grunt. Why would you want to use it instead of Grunt? Here's why?

- with Gulp your build file is code, not config
- You use standard libraries to do things
- Plugins are simple and do one thing
- Tasks are executed with maximum concurrency
- I/O works the way you picture it

That was taken from the [Gulp slides](http://slid.es/contra/gulp) by Eric Schoffstall. To sum it up Gulp is easier on the eyes. 

#####Installing Gulp

Just like Grunt Gulp can be installed using npm:

```
npm install -g gulp
```

This install gulp globally.

Now create your working directory if you haven't already done so. Under the root of your working directory create a `package.json` file and put the following contents:

```
{
  "name": "gulp-test-project",
  "version": "0.1.0",
  "author": "Nobunaga",
  "devDependencies": {
  }
}
```

Next install gulp locally:

```
npm install gulp --save-dev
```

Now were ready to install the plugins that we will use. Execute the following:

```
npm install gulp-cssmin gulp-imagemin gulp-uglify --save-dev
```

#####gulpfile.js

Once everything is installed we can now start using gulp. Just like with grunt gulp uses a file wherein all the tasks that you want to run is specified. The equivalent of `Gruntfile.js` in the gulp world is `gulpfile.js` (Yup! I know its shocking). Under the `gulpfile.js` we have the following:

```
var gulp = require('gulp'); 
var jshint = require('gulp-jshint');
var imagemin = require('gulp-imagemin');
var cssmin = require('gulp-cssmin');
var htmlmin = require('gulp-minify-html');
var uglify = require('gulp-uglify');

gulp.task('lint_js', function(){
  gulp.src('js/*.js')
    .pipe(jshint())
    .pipe(jshint.reporter('default'))
});

gulp.task('min_html', function() {
  var opts = {comments: true};
  gulp.src('*.html')
    .pipe(htmlmin(opts))
    .pipe(gulp.dest('dist/'))
});

gulp.task('min_js', function(){
  gulp.src('js/*.js')
    .pipe(uglify({outSourceMap: true}))
    .pipe(gulp.dest('dist/js'))
});

gulp.task('min_css', function(){
	gulp.src('css/*.css')
		.pipe(cssmin())
		.pipe(gulp.dest('dist/css'))
});

gulp.task('min_img', function(){
	gulp.src(['img/*.png', 'img/*.jpg'])
		.pipe(imagemin())
		.pipe(gulp.dest('dist/img'))
});

gulp.task('watch', function() {
    gulp.watch('js/*.js', ['lint_js', 'min_js']);
    gulp.watch('*.html', ['min_html']);
    gulp.watch('css/*.css', ['min_css']);
    gulp.watch('img/', ['min_img']);
});

gulp.task('default', ['watch']);
gulp.task('min', ['min_js', 'min_css', 'min_img', 'min_html']);
```

Yup! Gulp is really easier on the eyes. It's like were writing code and not config files. The gulpfile has 3 parts. The first part is where we define the plugins that we want to run, the second part is where we specify the configuration for each task, and the third is where we define aliases to the tasks that we want to run.

Breaking it down. Here were loading the tasks using node.js style code:

```
var gulp = require('gulp'); 
var jshint = require('gulp-jshint');
var imagemin = require('gulp-imagemin');
var cssmin = require('gulp-cssmin');
var htmlmin = require('gulp-minify-html');
var uglify = require('gulp-uglify');
```

Next we define the options for each tasks: 

######JS Hint

To define what a specific task will do we use the `task` method. This takes up 2 arguments, the first is the alias for the task that we want to run. The second is the actual function to run whenever this task is called. Here were giving the JS hint task an alias of `lint_js`. 

Then under the function we specify it to use all the `.js` files in the `js` directory as the source file. We can do this by calling the `src` method. Note the the `src` method can take up a string or an array of strings. Another thing that you have to remember is that you can only use globbing patterns and not solo paths like `js/` or just `js`. Gulp wouldn't know what to do with just a path you have to specify the actual file extension to target. 

Next you call the `pipe` method to specify the actual task to call when this specific task is run.
Lastly call the `pipe` method again to set the jshint reporter to default.

```
gulp.task('lint_js', function(){
  gulp.src('js/*.js')
    .pipe(jshint())
    .pipe(jshint.reporter('default'))
});
```


######HTML min

Next is the HTML min task. This will remove all the whitespaces from the targeted html files and save them in your desired output folder. You can also pass in options to remove all the comments, empty and redundant attributes, cdata or quotes. It follows the same pattern as the previous task, only this time we have declared a variable `opts` that stores the options for this specific task. We have set the `comments` to `true`. This will remove all the comments from the minified HTML output. Then we call the `src` method and pass in `*.html` which targets all the html files in your working directory. Then we call the `pipe` method and pass in `htmlmin` with the options as its argument. Lastly we pipe it again and call the `dest` method passing in the path to where we want to save the output files. In this case we simply want to save in the `dist` directory:

```
gulp.task('min_html', function() {
  var opts = {comments: true};
  gulp.src('*.html')
    .pipe(htmlmin(opts))
    .pipe(gulp.dest('dist/'))
});
```

If you want to know more about HTML min be sure to check out its [Github page](https://github.com/jonathanepollack/gulp-minify-html).

######Uglify JS

Next is the Uglify task, this will minify all the targeted JavaScript files and save them in your desired output folder. Again it uses the same pattern as the previous tasks that we have seen so far. `src` is where you pass in the path of the files that you want to process and `dest` is where you pass in the destination. The first `pipe` method call is where you pass in the actual task that you want to call. Here were passing an object to the `uglify` method which sets `outSourceMap` to `true`, what this does is save the source map in the same directory which the final JavaScript file is saved. Source maps basically allows you to debug your minified code. Here's the uglify task:

```
gulp.task('min_js', function(){
  gulp.src('js/*.js')
    .pipe(uglify({outSourceMap: true}))
    .pipe(gulp.dest('dist/js'))
});
```


######Image Min

Next is the image min task. This time we are passing an array to the `src` method so that we can target both png's and jpg's:

```
gulp.task('min_img', function(){
	gulp.src(['img/*.png', 'img/*.jpg'])
		.pipe(imagemin())
		.pipe(gulp.dest('dist/img'))
});
```

######Watch

Unlike grunt where we had to install the watch task separately gulp has it by default. You can use it by calling the `watch` method and passing in the files that you want to target as the first argument and the tasks that you want to run when the targeted files are updated:

```
gulp.task('watch', function() {
    gulp.watch('js/*.js', ['lint_js', 'min_js']);
    gulp.watch('*.html', ['min_html']);
    gulp.watch('css/*.css', ['min_css']);
    gulp.watch('img/', ['min_img']);
});
```

######Defining aliases

Lastly we define our aliases. Again we can use the `task` method for this. This time it takes the alias that we want to give to a specific task that we have already defined and then a string or an array of tasks that gulp will run when the specific alias is called. In the example below were telling gulp to use the `watch` task as its default task. This means that when we call either `gulp default` or just `gulp` from the command-line it will execute the watch task for us. On the second line we specify a minification task giving it an alias of `min`. This will simply call the tasks for minifying html, css, javascript and images:

```
gulp.task('default', ['watch']);
gulp.task('min', ['min_js', 'min_css', 'min_img', 'min_html']);
```

#####Useful Gulp Plugins

######General

- [gulp-clean](https://github.com/peter-vilja/gulp-clean) - removes files and folders
- [gulp-concat](http://github.com/wearefractal/gulp-concat) - concatenate files
- [gulp-replace](http://github.com/lazd/gulp-replace.git) - replaces strings

#####Code Quality

- [gulp-jshint](http://github.com/wearefractal/gulp-jshint) - jshint plugin for gulp
- [gulp-plato](https://github.com/sindresorhus/gulp-plato) - generate complexity analysis reports
- [gulp-coverage](https://github.com/dylanb/gulp-coverage) - instrument and generate code coverage independent of test runner
- [gulp-jscs](https://github.com/sindresorhus/gulp-jscs) - checks JavaScript code style with jscs
- [gulp-htmllint](https://github.com/bezoerb/gulp-htmlhint) - checks html files

#####Testing

- [gulp-mocha](https://github.com/sindresorhus/gulp-mocha)
- [gulp-jasmine](https://github.com/sindresorhus/gulp-jasmine)
- [gulp-qunit](https://github.com/jonkemp/gulp-qunit)

#####Performance Optimization

- [gulp-htmlmin](https://github.com/jonschlinkert/gulp-htmlmin) - minify html files
- [gulp-cssmin](https://github.com/chilijung/gulp-cssmin/) - minifying css
- [gulp-uncss](https://github.com/ben-eb/gulp-uncss) - remove unused css
- [gulp-imagemin](https://github.com/sindresorhus/gulp-imagemin) - compressing image sizes
- [gulp-svgmin](https://github.com/ben-eb/gulp-svgmin) - compressing svg images
- [gulp-webp](https://github.com/sindresorhus/gulp-webp) - converting images to webp format
- [gulp-uglify](https://github.com/terinjokes/gulp-uglify) - minify JavaScript files
- [gulp-jsmin](https://github.com/chilijung/gulp-jsmin/) - minify JavaScript files

#####Resources for learning gulp

- [Getting Started with Gulp](http://travismaynard.com/writing/getting-started-with-gulp)


####Rake

Lastly there's Rake. Rake is a build tool for Ruby.

#####Installing Rake

Rake depends on Ruby and Ruby Gems to be installed. You can install Ruby by using [RVM](http://rvm.io/). You can get RVM using curl. You can install curl in Ubuntu and other debian based Linux distributions by executing the following command:

```
sudo apt-get install curl
```

In Windows all you have to do is download the zip file from the [Curl downloads page](http://curl.haxx.se/download.html), extract it and `cd` into the extracted directory. You can then use curl from that directory.

For Mac OS X users you can install it with homebrew (yes you can pretty much install everything using homebrew, and yes I know you're probably tired of me mentioning homebrew every time we need to install something).

```
brew install curl
```

After installing curl we can then use the `curl` command to get and install rvm:

```
curl -L https://get.rvm.io | bash -s stable
```

Next we tell rvm to install ruby 1.9.3 (you can also use a later version if you want):

```
rvm install 1.9.3
```

Then tell rvm to use the version that you just installed:

```
rvm use 1.9.3
```

Next install ruby gems:

```
rvm rubygems latest
```

Lastly install rake:

```
gem install rake
```

#####Using Rake

To use rake all you have to do is create a new `Rakefile` in the root of your project and put the following contents:

```ruby
require 'rake'
 
task :default => :concat_files

dist_dir = 'dist' 

task :create_dir => :delete_dir do
	if !File.exists? dist_dir
		Dir.mkdir(dist_dir, 0700)
	end
	dirs = ['js', 'css', 'img']
	dirs.each do |dir_name|
		Dir.mkdir(dist_dir + '/' + dir_name, 0700)
		puts "creating " + dist_dir + '/' + dir_name
	end
	puts "done creating dist directory"
end

task :delete_dir do
	Dir[dist_dir + '/*'].each do |dir_name|
	    Dir.rmdir dir_name
	    puts dir_name + " is deleted"
	end
end

task :concat_files => :create_dir do
    out = ""
    js_files = ['jquery', 'main']
    js_files.each do |file|
        out += File.read('js/' + file + '.js')
    end
 
    File.open('dist/js/script.js', 'a') { |file|
        file.write(out)
    }
    puts "done concatenating javascript files"

    out = ""
    css_files = ['normalize', 'main']
    css_files.each do |file|
    	out += File.read('css/' + file + '.css')
    end
    File.open('dist/css/style.css', 'a'){ |file|
    	file.write(out)
    }
    puts "done concatenating css files"
    
end
```

Breaking it down, this line allows you to use the rake gem that you installed earlier in your `Rakefile`:

```
require 'rake'
```

Next is the line where we specify the default task. Rake allows you to specify a default task, a default task will automatically run when you execute the `rake` command from your terminal. In this case the default task is `concat_files`.

```
task :default => :concat_files
```

Next we set the distribution directory to `dist`. This is where the files processed by rake will be saved.

```
dist_dir = 'dist' 
```

Next we define the `create_dir` method. What this does is create the `dist` directory if it doesn't already exists. We use the `mkdir` method in the `Dir` class to create the `dist` directory. This takes up 2 arguments: the path to the directory that you want to create and then the file permissions. If you're not familiar with file permissions in Unix systems `0700` basically means that the creator of the directory will have write(4), read(2), and execute(1) permissions. 
Next we declare an array that contains the names of the folders that we want to create inside the `dist` directory. We simply loop over this array using the `each` method and then call the `mkdir` method to create those. Once its created it will output to the terminal the name of the directory that was created. Finally we also output that the `dist` directory has been created.

```
task :create_dir => :delete_dir do
	if !File.exists? dist_dir
		Dir.mkdir(dist_dir, 0700)
	end
	dirs = ['js', 'css', 'img']
	dirs.each do |dir_name|
		Dir.mkdir(dist_dir + '/' + dir_name, 0700)
		puts "creating " + dist_dir + '/' + dir_name
	end
	puts "done creating dist directory"
end
```

Before we move on to the next task you might be wondering what the fat arrow (`=>`) does and why did we place `:delete_dir` after it. Well the answer is that this lets us specify a task that the task that were defining depends on. So this basically means that the `create_dir` task depends on the `delete_dir` task. This means that rake will execute the `delete_dir` task first before executing the `create_dir` task. 

```
task :create_dir => :delete_dir do
```

You can then use this knowledge to specify the order of execution of different tasks. For example if we have task A, task B, task C, and task D. And we want them to execute in the following order:

```
A
B
C
D
```

Converting our requirements to code it will look like the following:

```
require 'rake'

task :default => :D

task :D => :C do
	puts "this is task D\n"
end

task :C => :B do
	puts "this is task C\n"
end

task :B => :A do
	puts "this is task B\n"
end

task :A do
	puts "this is task A\n"
end
```

As you can see from the code above we have specified the default task to the `D` task, but the `D` task depends on `C` task and the `C` task depends on `B` task, finally `B` task depends on `A` task. So this means that `A` task ends up executed first and then `B` and so on. You can see from the screenshot below that indeed the tasks were executed in the order that we wanted:

![rake output](/images/posts/2014-03-09-a-whirlwind-tour-of-web-developer-tools-build-tools/rake-output.png)

Going back to our original `Rakefile` let's now go through what the `delete_dir` task does:

```
task :delete_dir do
	Dir[dist_dir + '/*'].each do |dir_name|
	    Dir.rmdir dir_name
	    puts dir_name + " is deleted"
	end
end
```

The code is very straightforward. What were doing in the above code is looping through all the directories in the `dist` directory and then delete them using the `rmdir` method in the `Dir` class. The `rmdir` method takes up a single argument which is the name of the directory that you want to delete. Once its deleted the directory in the current iteration of the loop it just outputs into the terminal that the directory is deleted.

Lastly let's go through the `concat_files` method. What this does is concatenate the contents of the files that you specify. So all the javascript files gets concatenated and all the css files gets concatenated. This method depends on the `create_dir` method to be executed first. The first thing that were doing in this task is declaring the `out` variable and instantiate it with an empty string value. Next we define the filenames of the javascript files that we want to concatenate in order. Here we have declared `jquery` and then `main` which means that the contents of the `jquery` file will come first and then the contents of the `main` file will get appended after it. 
Next we loop over these files then use the `read` method in the `File` class to get the contents of the file. The `read` method takes up the path to the file as its argument. We simply append its contents to the `out` variable that we declared initially. Next we call the `open` command in the `File` class and pass in the path to the main javascript file where we want to put all the contents of all the javascript files that we defined in the `js_files` array. The `open` command has a side effect of creating the file if it doesn't already exists so were taking advantage of that side effect in this method. Next we just call the `write` method from the file and pass in the `out` variable. Lastly we just output in the terminal that concatenating the javascript files is already done.

For the concatenation of css files were basically doing the same thing only this time were reading from all the css files and putting all of its contents in the `style.css` file.

```
task :concat_files => :create_dir do
    out = ""
    js_files = ['jquery', 'main']
    js_files.each do |file|
        out += File.read('js/' + file + '.js')
    end
 
    File.open('dist/js/script.js', 'a') { |file|
        file.write(out)
    }
    puts "done concatenating javascript files"

    out = ""
    css_files = ['normalize', 'main']
    css_files.each do |file|
    	out += File.read('css/' + file + '.css')
    end
    File.open('dist/css/style.css', 'a'){ |file|
    	file.write(out)
    }
    puts "done concatenating css files"
    
end
```

#####Useful resources for task automation

If you would like to use Ruby for your task automation needs you don't really need to be writing code from scratch like what we have done above. Most of the boring tasks that we need to do as web developers are already taken care by some brilliant people so all you have to do is install the software that they wrote and use it on your own projects. Here are some resources for task automation in ruby:

- [Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html)
- [JSHint Gem](https://github.com/rquinlivan/jshint-gem)
- [Asset Hat](http://mintdigital.github.io/asset_hat/)
- [Rake Minify](https://github.com/mcollina/rake-minify)

###Conclusion

Build tools are very important tools to have in our web development arsenal. They make boring, repetitive or unsexy manual tasks easier to handle. After all computers were originally made to make tasks easier so we as developers have to take advantage of that.

###Resources

- [Grunt JS](http://gruntjs.com/)
- [Gulp JS](http://gulpjs.com/)
- [Rake](http://rake.rubyforge.org/)

=======================================