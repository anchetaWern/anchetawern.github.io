---
layout: post
title: "Digging into Chrome Dev Tools"
date: 2013-04-21 17:15
comments: true
categories: [tools]
published: true
---

In this article I'm going to walk you through some of the things that we can do with the Chrome Developer Tools to improve our web development workflow.


<!--More-->


###Accessing Chrome Dev Tools

You can access the Chrome Developer Tools by clicking on the Chrome Settings button -> Tools -> Developer Tools.


####Elements Panel

First there's the elements panel which we can use to inspect and edit the html that is used in a web page.

![elements panel](/images/posts/digging_into_chrome_dev_tools/elements_panel.jpg)

This is very useful for when you want to edit the HTML of the web page that you're working on, adding some classes or attributes on the fly. 

![elements options](/images/posts/digging_into_chrome_dev_tools/element_options.jpg)

As you can see from the screenshot above there's a bunch of things that you can do with the currently selected element like copying its HTML, Edit the HTML, or deleting the node which you can do by just pressing delete on your keyboard. If you mess up you can always press on ctrl + z to undo the changes that you've made.

You can also edit entire HTML blocks or navigate directly to the parent element of the currently selected element.

![edit html blocks](/images/posts/digging_into_chrome_dev_tools/edit_html_block.jpg)

You can also drag elements around by holding the left mouse button and then dragging the element to where you want it to be and then finally releasing it.

Another thing that you can do within the elements panel is live editing of the CSS used in a particular element.

You can add new styles by pressing tab while the cursor is inside the value of the last property for a specific selector. As you can see from the screenshot below it also gives you a nice auto-completion for every property and values that are currently supported by the browser.

![add styling](/images/posts/digging_into_chrome_dev_tools/add_styling.jpg)

You can also disable a specific style by unchecking the checkbox before the property:

![remove styling](/images/posts/digging_into_chrome_dev_tools/disable_styling.jpg)

To delete a property entirely you can press delete while the cursor is either inside of the property or the value.

There's also a sweet color picker which you can use to experiment on the color that you want to use.

![color picker](/images/posts/digging_into_chrome_dev_tools/color_picker.jpg)


You can also directly edit the css file by clicking on the name of the css file that you want to edit.

![css file](/images/posts/digging_into_chrome_dev_tools/css_file.jpg)

After that you can just edit the file like you usually do in a text-editor and the web page will be automatically updated as you type in the value for each property. The only difference is that you don't get the auto-completion while in this mode.

![css editing](/images/posts/digging_into_chrome_dev_tools/css_editing.jpg)

But the only problem with this is that all your changes only lives on the browser once you refresh the page all your changes will be gone. And the only plugin-less solution would be to click on the filename of the css file that you've edited then copy all of its contents and then paste it back on your source file. Or you can actually right click on the file and then click on save.

![save css file](/images/posts/digging_into_chrome_dev_tools/save_css.jpg)



###Resources Panel

Next is the resources panel where we can see some of the resources that the web page has loaded on initial page load. 
That includes the current page (html), images, script files (mainly JavaScript), stylesheets, and other types of media.
Each of these files are group according to their file type so all stylesheets are under the same group, all the JavaScript are in the same group, etc. Also note that the ordering depends on what has been loaded first. So the first files that were loaded during page load are first on the list.

From the resources panel you can also see what's stored in Web SQL, Indexed DB, local storage, session storage, cookies, and application cache which is mainly specified in the manifest file whenever you want your application to be accessed offline. 

![resources panel](/images/posts/digging_into_chrome_dev_tools/resources_panel.jpg)

The resources panel also gives you a nice preview of the file that you're currently viewing. 
For images you get something like this:

![image preview](/images/posts/digging_into_chrome_dev_tools/image_preview.jpg)

And for HTML, CSS, and JavaScript files you get to view the source:

![html source](/images/posts/digging_into_chrome_dev_tools/html_source.jpg)


###Network Panel

Next is the network panel where you can see the list of files which are loaded by the web page.
Either on initial page load or while the users are interacting with the web page. 
So you can actually see the AJAX requests, template files and other network requests in the network panel.

![network panel](/images/posts/digging_into_chrome_dev_tools/network_panel.jpg)

Here are some of the information that you can see on the Network Panel:

**Name** - the name of the file that was requested.

**Method** - the method that was used to get the specific file (GET, POST).

**Type** - the [type of file](http://en.wikipedia.org/wiki/MIME) that was requested. 

**Status** - the status of the request [status](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes). The common status are 200 OK which means the request was successful and the file was directly downloaded from the server. There's also 304 not modified.

**Initiator** - the page that requested the file or resource. This is usually the current page.

**Size** - the size of the requested file in kilobytes. 

**Time** -  the time between making the request and the server's first response in milliseconds.

**Timeline** - shows the waiting and receiving time for each file. The waiting time is the amount of time in which the browsers waits for the file upon requesting it. The receiving time is the amount of time in which the file is downloaded.


Clicking on each file allows you to view the request headers, preview, response, cookies and the timing.

**headers** - this shows you the details of the request like the Request URL which is the URL to the file that is requested.
The request method which is usually GET or POST. The status code which you also saw from the network request summary earlier.

There's also the Request Headers and Response Headers. The Request Headers are the information that is present in the browser. And the Response Headers is the information returned from the server.

Some of the information that are present in the Request Headers are the  Referer which is basically the url of the file that initially requested the file or resource, the User-Agent is the browser used by the user to access the web page.

While the Response Headers contains information like the name of the Server (Apache, ECS, Nginx and a bunch of others), the current system date of the server, the [entity tag](http://en.wikipedia.org/wiki/HTTP_ETag).

![network request](/images/posts/digging_into_chrome_dev_tools/network_request.jpg)

**preview** - this is usually the source of the file. If its an image file you usually get a preview of the image.

**response** - the same as preview but this time you only get the raw data. 

![response](/images/posts/digging_into_chrome_dev_tools/response.jpg)

**cookies** - this is usually the cookies stored by the website that the user is currently looking at.

![cookies](/images/posts/digging_into_chrome_dev_tools/cookies.jpg)

**timing** - the same as the information displayed in the waterfall timeline that you see on the network request summary only this time its only for the file that you have clicked on.

![timing](/images/posts/digging_into_chrome_dev_tools/timing.jpg)


###Sources Panel

The sources panel allows you to view and edit the source files used in the current web page. 
We kind of touch on this earlier when we click on a filename on the elements panel we get redirected to the sources panel and then it allows us to edit the file that we selected and the changes would be automatically reflected on the page. But that's just on the css side of things. You can actually debug JavaScript code as well in the sources panel. The official Chrome Dev Tools documentation already had us covered in the [Breakpoints](https://developers.google.com/chrome-developer-tools/docs/scripts-breakpoints) section so I won't delve much in how that's done.


###Timeline Panel

The timeline panel allows you to view information regarding the performance of your web app. Things like paint times, frames per second, and memory consumption. It gives you a complete overview of how your web app performs.

![timeline panel](/images/posts/digging_into_chrome_dev_tools/timeline_panel.jpg)

You can start using the timeline panel by clicking on the `record` button found at the lower left portion of chrome dev tools.

![record button](/images/posts/digging_into_chrome_dev_tools/record_button.jpg)

Then interact with your app a bit. Usually you would interact on the parts of your app in which you want to measure the performance. Once you're done click on the `stop` button.

On first look this might really look complicated. I also had no idea where the hell should I start looking the first time I used the timeline panel.

First let's talk about the colors that you see in the timeline panel:

**Blue** - sending of requests and network related stuff.
**Yellow** - execution of JavaScript code. 
**Purple** - css calculation and rendering.
**Green** - repaints (updating the page).

The length of these colors depends on the amount of time (in milliseconds) that the browser executed the operation.
That's about all I can share about the timeline panel. I'm not really in the level yet of measuring the performance of the applications that I'm trying to build especially in the frontend because I do more backend than I do frontend.


###Console

The console panel allows you to play around with JavaScript code that you want to include in your application.
It also serves as a shortcut in selecting elements in the DOM.

![selecting in the console](/images/posts/digging_into_chrome_dev_tools/console_select.jpg)

There are also some shortcuts which you can use to select elements.

To select the element that is currently selected in the elements panel you can use `$0`:

![$0](/images/posts/digging_into_chrome_dev_tools/dollar_zero.jpg)

Of course you can also use `$1`, `$2` and other numbers for as far as your memory can reach to select the elements that were previously selected. So if you select the body then the main wrapper then the first child of that wrapper. `$0` returns the first child of the wrapper, `$1` returns the wrapper, and `$0` returns the body. 


Other things that the console allows you to do:

- view errors - the console automatically allows you to view errors in your JavaScript code like parse errors when trying to call `JSON.parse` on an invalid JSON string. 

- assertion - checking if a specific condition is true. You can use the `assert` method to do assertions.
For example when checking if the following values are true:

![asserting values](/images/posts/digging_into_chrome_dev_tools/console_assert_numbers.jpg)

As you can see from the screenshot above the first two conditions returned `undefined` which means the assertion has pass. While on the 3rd condition the assertion failed since were using the strict equality operator which also checks the data type of the variable and not just its value.

![typeof](/images/posts/digging_into_chrome_dev_tools/typeof.jpg)

You can also assert return values from functions as well:

![asserting functions](/images/posts/digging_into_chrome_dev_tools/assert_functions.jpg)

As you can see from the screenshot above the first assertion failed since 3 is not equal to 4. But the second assertion passes since 3 is less than 4. This is a pretty simple example but you can also have more complex functions checked by `console.assert` as long as they have return values which it can check.



###Resources

[Chrome Dev Tools Documentation](https://developers.google.com/chrome-developer-tools/)
