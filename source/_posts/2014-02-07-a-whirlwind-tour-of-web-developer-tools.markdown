---
layout: post
title: "A Whirlwind Tour of Web Developer Tools: In-Browser Tools"
date: 2014-02-09 12:30
comments: true
categories: [web-development, tools, browser-tools]
published: true
updated: 2014-02-25 
---

In this series of blog posts I'm going to give you an overview of some of the tools that are commonly used by web developers to get their work done. You can expect some examples on how to install and use each tool but I won't be going too deep. The main purpose is to simply give you an idea on what tools are available, how to use them and encourage you to integrate them into your workflow. Note that the tools that will be mentioned in this blog post aren't platform specific so you can use them whether you're developing in Windows, Linux or Mac. Over the coming weeks I'm going to walk you through the following:

 - In-Browser Tools
 - Text Editor
 - Virtualization
 - Web Servers
 - Command Line Utilities
 - Package Managers
 - Source Control
 - Build Tools
 - Linting
 - Testing
 - Language Compilers
 - Coding Standards
 - Boilerplates and Front-end Frameworks
 - Templating
 - Deployment
 - Miscellaneous

<!-- more -->

###In-Browser Tools

First on the list is the browser tools. Browser tools are a set of tools that live on the browser which can help you in inspecting and debugging web applications. 

####Chrome Developer Tools

One of the most popular browser tool today is the Chrome Developer Tools. You can access it by pressing `Ctrl + Shift + I` or `Cmd + Opt + I` on your keyboard. By default this opens up the last panel that you have accessed. 
 
 - **Elements** - allows DOM inspection and modification, changes are reflected on the page as you update.
 - **Network** - this is where you can view all of the HTTP requests made by your web project. The size and time it took to download each requested file are also viewable so the network panel is mostly used for evaluating the performance of your web project in terms of the HTTP requests that are made.
 - **Sources** - used for viewing and updating the source files used by your web project. If you selected a JavaScript file it will also allow you to debug it.
 - **Timeline** - used for evaluating the performance of your web project in terms of frames and memory consumed 
 - **Profiles** - used for profiling JavaScript performance
 - **Resources** - kind of similar with the sources panel, but it doesn't allow you to edit the source files. It also allows you to view and modify cookie and local storage information.
 - **Audits** - evaluates the web page performance in terms of network utilization and css and JavaScript performance.
 - **Console** - allows you to run JavaScript code and inspect JavaScript objects.


####Useful Extensions and Plugins

 - **Web Developer** - packs various extensions and tools to help in testing web pages [[chrome]](https://chrome.google.com/webstore/detail/web-developer/bfbameneiokkgbdmiekhjnmfkcnldhhm) [[firefox]](https://addons.mozilla.org/en-US/firefox/addon/web-developer/)
 - **Tincr** - allows live reloading of web pages as you make changes to the source file. The saving of changes is also bi-directional which means that if you edit the file in the sources panel of the Chrome Developer Tools the changes will also get saved to the source file. Pretty sweet! [[chrome]](https://chrome.google.com/webstore/detail/tincr/lfjbhpnjiajjgnjganiaggebdhhpnbih?hl=en)
 - **Pagespeed Insights** - used for evaluating the performance of web pages based on industry best practices. It will give you some suggestions on how you can improve the performance of your website based on its evaluation. [[chrome]](https://chrome.google.com/webstore/detail/pagespeed-insights-by-goo/gplegfbjlmmehdoakndmohflojccocli?hl=en) 
 - **YSlow** - the same as Pagespeed Insights. [[chrome]](https://chrome.google.com/webstore/detail/yslow/ninejjcohidippngpapiilnmkgllmakh) [[firefox]](https://addons.mozilla.org/en-US/firefox/addon/yslow/)


####Firefox Developer Tools

Pretty much the same with the Chrome Developer Tools. It also allows you to inspect and modify a web page, debug JavaScript code, monitor and inspect HTTP requests as they happen. During my testing I found out that most of the features are the same, the only tool that is not present by default in the Chrome Developer Tools is the 3d view for web pages. 

![3d view](/images/posts/whirlwind_tour_web_developer_tools/3dview.png)


####Firebug

The in-browser tool that started it all. It was already around before Chrome Dev Tools and Firefox Dev Tools came out. Most of the features are also the same with that of Chrome Dev Tools and Firefox Dev Tools. 

###Conclusion

In-browser tools are a nice way to easily design and test websites. They allow you to do almost everything right from the browser itself. The main benefit of this is instant feedback. You get to see what effect your changes have on the website right after making the change. Tools like tincr even make it possible to commit your changes to your source files so you won't have to go back to the text-editor and commit your changes.

###Resources

 - [Chrome Developer Tools](https://developers.google.com/chrome-developer-tools/)
 - [Chrome Developer Tools Tools Tips and Tricks](https://developers.google.com/chrome-developer-tools/docs/tips-and-tricks)
 - [Firebug](https://getfirebug.com/faq/)
 - [Firefox Developer Tools](https://developer.mozilla.org/en/docs/Tools)